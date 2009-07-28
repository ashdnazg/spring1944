function widget:GetInfo()
  return {
    name      = "1944 GUI",
    desc      = "Spring 1944 GUI",
    author    = "Evil4Zerggin",
    date      = "25 July 2009",
    license   = "GNU LGPL, v2.1 or later",
    layer     = 1, 
    enabled   = false  --  loaded by default?
  }
end

----------------------------------------------------------------
--speedups
----------------------------------------------------------------
local Echo = Spring.Echo
local IsGUIHidden = Spring.IsGUIHidden
local TraceScreenRay = Spring.TraceScreenRay
local GetMouseState = Spring.GetMouseState

local GetSelectedUnits = Spring.GetSelectedUnits
local GetUnitCmdDescs = Spring.GetUnitCmdDescs

local glLoadFont = gl.LoadFont
local glColor = gl.Color
local glRect = gl.Rect

----------------------------------------------------------------
--local vars
----------------------------------------------------------------
local FONT_DIR = LUAUI_DIRNAME .. "Fonts/"
local MAIN_DIRNAME = LUAUI_DIRNAME .. "Widgets/gui_s44_gui/"
local COMPONENT_DIRNAME = MAIN_DIRNAME .. "components/"

local components = {}

--callins we should autocreate lists for
local callins = {
  --standard
  "GameFrame",
  "Update",
  "SetConfigData", 
  
  --modified
  "CommandsChanged", --updates command lists
  "DrawScreen", --does not draw if GUI is hidden
  "MousePress", --any component with MousePress must also have a MouseRelease; does not take click if GUI is hidden
  "ViewResize", --ViewResize() -> nil; the viewsizes are stored in globals vsx, vsy
  "GetConfigData", --aggregates the data into a single table
  
  
  --unlisted: Initialize, Shutdown
  
  --nonstandard
  "DrawRolloverWorld", --DrawRolloverWorld(targetType, targetID) -> nil (same arguments as Spring.TraceScreenRay)
  "DrawRolloverScreen", --DrawRolloverScreen(mx, my, targetType, targetID) -> nil (same arguments as Spring.TraceScreenRay)
  "DrawTooltip", --DrawTooltip(x, y) -> component owns tooltip
}

--format: callinName = {component, component...}
local callinLists = {}

--owner of the the current MousePress
local clickOwner

----------------------------------------------------------------
--globals
----------------------------------------------------------------
guiOpacity = 0.4

font16 = glLoadFont(FONT_DIR .. "cmuntb.otf", 16, 2, 16)
font32 = glLoadFont(FONT_DIR .. "cmuntb.otf", 32, 4, 16)
vsx, vsy = 1280, 1024

local tooltipWidth = 0.25
local tooltipSizeX = vsx * tooltipWidth
local tooltipFontSize = 16
local tooltipOffsetX = 16

function DrawStandardTooltip(text, x, y, wrap)

  local sizeX = tooltipSizeX
  
  local numLines
  if wrap then
    text, numLines = font16:WrapText(text, tooltipSizeX - 8, vsy, tooltipFontSize)
  else
    _, numLines = text:gsub("\n", "\n")
    numLines = numLines + 1
    sizeX = font16:GetTextWidth(text) * tooltipFontSize + 8
  end
  
  local fontHeight, descender = font16:GetTextHeight(text) 
  
  local sizeY = fontHeight * tooltipFontSize * numLines * 1.25
  
  local drawX = x + tooltipOffsetX
  if drawX + sizeX > vsx then
    drawX = vsx - sizeX
  end
  
  local drawY = y
  if sizeY > y then
    sizeY = y
  end
  
  glColor(0, 0, 0, guiOpacity)
  glRect(drawX, drawY, drawX + sizeX, drawY - sizeY)
  glColor(1, 1, 1, 1)
  
  font16:Print(text, drawX, drawY, tooltipFontSize, "to")
  
end

allCommands = {}
orderCommands = {}
buildCommands = {}

local function UpdateCommandLists()
  allCommands = {}
  orderCommands = {}
  buildCommands = {}
  
  --construct a list of commands
  local selectedUnits = GetSelectedUnits()
  for i = 1, #selectedUnits do
    local unitID = selectedUnits[i]
    local cmdDescs = GetUnitCmdDescs(unitID)
    for j = 1, #cmdDescs do
      local cmdDesc = cmdDescs[j]
      local cmdDescID = cmdDesc.id
      if not cmdDesc.hidden and not cmdDesc.disabled then
        allCommands[cmdDescID] = cmdDesc
        if cmdDescID >= 0 then
          orderCommands[cmdDescID] = cmdDesc
        else
          buildCommands[cmdDescID] = cmdDesc
        end
      end
    end
  end
end

----------------------------------------------------------------
--setup
----------------------------------------------------------------
do
  local vfsInclude = VFS.Include
  
  local files = VFS.DirList(COMPONENT_DIRNAME, "*.lua")
  for i=1,#files do
    local file = files[i]
    components[i] = vfsInclude(file)
    Echo("<gui_s44_hud>: Loaded component from file '" .. file .. "'")
  end
end

for i = 1, #callins do
  local callin = callins[i]
  local callinList = {}
  callinLists[callin] = callinList
  for j = 1, #components do
    local component = components[j]
    if component[callin] then
      callinList[#callinList+1] = component
    end
  end
end

----------------------------------------------------------------
--standard callins
----------------------------------------------------------------

function widget:GameFrame(n)
  local callinList = callinLists["GameFrame"]
  for i = 1, #callinList do
    callinList[i]:GameFrame(n)
  end
end

function widget:Update(dt)
  local callinList = callinLists["Update"]
  for i = 1, #callinList do
    callinList[i]:Update(dt)
  end
end

function widget:SetConfigData(data)
  local callinList = callinLists["SetConfigData"]
  for i = 1, #callinList do
    callinList[i]:SetConfigData(data)
  end
end

----------------------------------------------------------------
--modified callins
----------------------------------------------------------------

--does not draw if GUI is hidden
function widget:DrawScreen()
  if IsGUIHidden() then return end

  local callinList = callinLists["DrawScreen"]
  for i = 1, #callinList do
    callinList[i]:DrawScreen()
  end
  
  local mx, my = GetMouseState()
  local targetType, targetID = TraceScreenRay(mx, my)
  
  local rolloverList = callinLists["DrawRolloverScreen"]
  for i = 1, #rolloverList do
    rolloverList[i]:DrawRolloverScreen(mx, my, targetType, targetID)
  end
  
  local tooltipList = callinLists["DrawTooltip"]
  for i = 1, #tooltipList do
    if tooltipList[i]:DrawTooltip(mx, my) then
      return
    end
  end
end

function widget:ViewResize(viewSizeX, viewSizeY)
  vsx, vsy = viewSizeX, viewSizeY
  tooltipSizeX = vsx * tooltipWidth
  
  local callinList = callinLists["ViewResize"]
  for i = 1, #callinList do
    callinList[i]:ViewResize()
  end
end

--track which component is the click owner; does not take click if GUI is hidden
function widget:MousePress(x, y, button)
  if IsGUIHidden() then return false end

  local callinList = callinLists["MousePress"]
  for i = 1, #callinList do
    local component = callinList[i]
    if component:MousePress(x, y, button) then
      clickOwner = component
      return true
    end
  end
  return false
end

--release the click if we have it
function widget:MouseRelease(x, y, button)
  if clickOwner then
    clickOwner:MouseRelease(x, y, button)
    clickOwner = nil
    return true
  else
    return false
  end
end

function widget:CommandsChanged()
  UpdateCommandLists()

  local callinList = callinLists["CommandsChanged"]
  for i = 1, #callinList do
    callinList[i]:CommandsChanged()
  end
end

function widget:GetConfigData()
  local result = {}
  
  local callinList = callinLists["GetConfigData"]
  for i = 1, #callinList do
    local subresult = callinList[i]:GetConfigData()
    for k, v in pairs(subresult) do
      result[k] = v
    end
  end
  
  return result
end

----------------------------------------------------------------
--unlisted callins
----------------------------------------------------------------

--includes a ViewResize

function widget:Initialize()
  
  local viewSizeX, viewSizeY = Spring.GetViewGeometry()
  widget:ViewResize(viewSizeX, viewSizeY)
  
  for i = 1, #components do
    local component = components[i]
    if component.Initialize then
      component:Initialize()
    end
  end
end

function widget:Shutdown()
  for i = 1, #components do
    local component = components[i]
    if component.Shutdown then
      component:Shutdown()
    end
  end
  
  local glDeleteFont = gl.DeleteFont
  glDeleteFont(font16)
  glDeleteFont(font32)
end

function widget:DrawWorld()
  local mx, my = GetMouseState()
  local targetType, targetID = TraceScreenRay(mx, my)
  
  local rolloverList = callinLists["DrawRolloverWorld"]
  for i = 1, #rolloverList do
    rolloverList[i]:DrawRolloverWorld(targetType, targetID)
  end
end

----------------------------------------------------------------
--api
----------------------------------------------------------------

local strChar = string.char
local floor = math.floor

function GetColorString(color, g, b)
  if g then
    color = {color, g, b}
  end
  
  for i = 1, 3 do
    color[i] = floor(color[i] * 255)
    if color[i] < 1 then color[i] = 1
    elseif color[i] > 255 then color[i] = 255
    end
  end
  
  return strChar(255, color[1], color[2], color[3])
end

function GetHealthColor(proportion)
  if proportion > 0.5 then
    return {2 - proportion * 2, 1, 0}
  else
    return {1, proportion * 2, 0}
  end
end

local api = {
  GetColorString = GetColorString,
  GetHealthColor = GetHealthColor,
}

WG.S44GUI = api
