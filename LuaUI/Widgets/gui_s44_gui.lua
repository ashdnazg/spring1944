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

local glLoadFont = gl.LoadFont

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
  "CommandsChanged",
  
  --modified
  "DrawScreen", --does not draw if GUI is hidden
  "MousePress", --any component with MousePress must also have a MouseRelease; does not take click if GUI is hidden
  "ViewResize", --ViewResize() -> nil; the viewsizes are stored in globals vsx, vsy
  
  --unlisted: Initialize, Shutdown
  
  --nonstandard
  "DrawRolloverWorld", --DrawRolloverWorld(targetType, targetID) -> nil (same arguments as Spring.TraceScreenRay)
  "DrawRolloverScreen", --DrawRolloverScreen(targetType, targetID) -> nil (same arguments as Spring.TraceScreenRay)
  "DrawTooltip", --DrawTooltip(x, y) -> component owns tooltip
}

--format: callinName = {component, component...}
local callinLists = {}

--owner of the the current MousePress
local clickOwner

----------------------------------------------------------------
--global vars
----------------------------------------------------------------

font16 = glLoadFont(FONT_DIR .. "cmuntb.otf", 16, 0, 0)
font32 = glLoadFont(FONT_DIR .. "cmuntb.otf", 32, 0, 0)
vsx, vsy = 1280, 1024

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

function widget:CommandsChanged()
  local callinList = callinLists["CommandsChanged"]
  for i = 1, #callinList do
    callinList[i]:CommandsChanged()
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
    rolloverList[i]:DrawRolloverScreen(targetType, targetID)
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
