function gadget:GetInfo()
	return {
		name = "Clear Path",
		desc = "Improved mine and obstacle clearing for engineers",
		author = "ashdnazg",
		date = "26 May 2014",
		license = "GNU GPL v2",
		layer = 1,
		enabled = true
	}
end

-- Constants
local MINE_CLEAR_RADIUS = 200
--local FEATURE_CLEAR_RADIUS = 120
local OBSTACLE_CLEAR_RADIUS = 120

if (gadgetHandler:IsSyncedCode()) then
--SYNCED


-- Synced Read
local GetUnitDefID			= Spring.GetUnitDefID
local GetUnitPosition		= Spring.GetUnitPosition
local GetUnitsInCylinder	= Spring.GetUnitsInCylinder
local GetFeaturesInCylinder = Spring.GetFeaturesInCylinder
local GetFeatureBlocking    = Spring.GetFeatureBlocking
local ValidUnitID			= Spring.ValidUnitID
local GetGroundHeight	    = Spring.GetGroundHeight


-- Synced Ctrl
local CallCOBScript			= Spring.CallCOBScript
local DestroyUnit			= Spring.DestroyUnit
local RemoveBuildingDecal	= Spring.RemoveBuildingDecal
local SetUnitMoveGoal		= Spring.SetUnitMoveGoal
local SpawnCEG				= Spring.SpawnCEG
local GiveOrderToUnit       = Spring.GiveOrderToUnit


-- Constants
local CMD_CLEARPATH = GG.CustomCommands.GetCmdID("CMD_CLEARPATH")
local STOP_DIST = 5
local MIN_DIST = 20
local WAYPOINT_DIST = 100
local MINE_CLEAR_TIME = 3 -- time in seconds to clear single mine
local gMaxUnits = Game.maxUnits
-- Variables
local clearers = {} -- clearers[ownerID] = {target={x,y,z},waypoint={wx,wy,wz},delta={dx,dz}, new, active, on_waypoint, done}

local DelayCall = GG.Delay.DelayCall


local clearPathDesc = {
	name	= "Clear Path",
	action	= "clearpath",
	id		= CMD_CLEARPATH,
	type	= CMDTYPE.ICON_MAP, -- change to ICON_AREA?
	tooltip	= "Clear the path to a given location",
	cursor	= "Clear Path",
}


function gadget:GameFrame(f)
	for unitID, clearer in pairs(clearers) do
        if clearer.onWaypoint and not clearer.active and not clearer.done then
            local wx, wz = clearer.waypoint[1], clearer.waypoint[3]
            clearer.done = ClearWaypoint(unitID, wx, wz)
        end
	end
end


-- Callins

function BlowMine(mineID, engineerID)
    clearers[engineerID].active = false
	if ValidUnitID(engineerID) and ValidUnitID(mineID) then -- only destroy mines if clearer is still alive
		local px, py, pz = GetUnitPosition(mineID)
		DestroyUnit(mineID, false, true)
		SpawnCEG("HE_Small", px, py, pz)
		RemoveBuildingDecal(mineID)
	end
end

-- Returns true if finished clearing

function ClearWaypoint(unitID, x, z)
	local tmpNearbyUnits = GetUnitsInCylinder(x, z, MINE_CLEAR_RADIUS)
	local mines = {}
    local obstacles = {}
	for _, tmpUnitID in pairs(tmpNearbyUnits) do
		-- check if that is a mine or an obstacle
		local tmpUD
		tmpUD = GetUnitDefID(tmpUnitID)
		tmpUnitDef=UnitDefs[tmpUD]
		if tmpUnitDef then
			if tmpUnitDef.customParams then
				if tonumber(UnitDefs[tmpUD].customParams.ismine) == 1 then
					table.insert(mines, tmpUnitID)
				elseif tonumber(UnitDefs[tmpUD].customParams.isobstacle) == 1 then
                    table.insert(obstacles, tmpUnitID)
                end
			end
		end
	end

    
	if #mines > 0 then
        DelayCall(BlowMine, {mines[math.random(#mines)], unitID}, MINE_CLEAR_TIME * 30)
        
        -- Shortened on purpose from 1000 to 700 due to the unit getting stuck
        -- occasionally
        CallCOBScript(unitID, "LookForMines", 0, MINE_CLEAR_TIME * 700)
        clearers[unitID].active = true
        return false
    end
    
    local tmpNearbyFeatures = GetFeaturesInCylinder(x,z, OBSTACLE_CLEAR_RADIUS)
    for _, featureID in pairs(tmpNearbyFeatures) do
		-- check if the feature is blocking
		if GetFeatureBlocking(featureID) then
            GiveOrderToUnit(unitID, CMD.INSERT,{0, CMD.RECLAIM, 0, gMaxUnits + featureID},{"alt"})
        end
	end
    
    for _, obstacleID in pairs(obstacles) do
        GiveOrderToUnit(unitID, CMD.INSERT,{0, CMD.RECLAIM, 0, obstacleID},{"alt"})
	end
    
    
    return true
end

function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
	if cmdID == CMD_CLEARPATH then
		local ud = UnitDefs[unitDefID]
		local cp = ud.customParams
		if cp and cp.canclearmines then
			return true
		else
			-- Only allow CMD_CLEARPATH for units with the correct tag
			return false
		end
	else
		-- Allow any other command
		return true
	end
end


function gadget:CommandFallback(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
	if cmdID == CMD_CLEARPATH then
		local ud = UnitDefs[unitDefID]
		local cp = ud.customParams
		if cp and cp.canclearmines then
            local clearer
            local x = cmdParams[1]
			local y = cmdParams[2]
			local z = cmdParams[3]
            local px, py, pz = GetUnitPosition(unitID)
            
            if not clearers[unitID] then
                clearers[unitID] = {target = {x, y, z}, waypoint={px, py, pz}, delta = {0.0, 0.0}, new = true, active = false, onWaypoint = false, done = true}
                clearer = clearers[unitID]
            else
                clearer = clearers[unitID]
                if clearer.active then
                    return true, false
                end
                local currentTarget = clearer.target
                if currentTarget[1] ~= x or currentTarget[2] ~= y or currentTarget[3] ~= z then
                    currentTarget[1], currentTarget[2], currentTarget[3] = x, y, z
                    clearer.new = true
                    clearer.waypoint[1], clearer.waypoint[2], clearer.waypoint[3] = px, py, pz
                    clearer.onWaypoint = false
                    clearer.done = true
                end
            end
            local wx, wy, wz, distance
            if not clearer.done then
                wx, wy, wz = clearer.waypoint[1], clearer.waypoint[2], clearer.waypoint[3]
                distance = math.sqrt((wx - px)^2 + (wy - py)^2 + (wz - pz)^2)
                if distance < MIN_DIST then
                    clearer.onWaypoint = true
                end
                return true, false
            else
                distance = math.sqrt((x - px)^2 + (y - py)^2 + (z - pz)^2)
                local dx, dz
                if distance > WAYPOINT_DIST then
                    if clearer.new then
                        local angle = math.atan2(x - px, z - pz)
                        dx = math.sin(angle) * WAYPOINT_DIST
                        dz = math.cos(angle) * WAYPOINT_DIST
                        clearer.delta[1], clearer.delta[2] = dx, dz
                        clearer.new = false
                    else
                        dx, dz = clearer.delta[1], clearer.delta[2]
                    end
                    wx, wz = clearer.waypoint[1], clearer.waypoint[3]
                    wx = wx + dx
                    wz = wz + dz
                elseif distance > MIN_DIST then
                    wx = x
                    wz = z
                else
                    return true, true
                end
                wy = GetGroundHeight(wx, wz)
                SetUnitMoveGoal(unitID, wx, wy, wz, STOP_DIST)
                clearer.waypoint[1], clearer.waypoint[2], clearer.waypoint[3] = wx, wy, wz
                clearer.done = false
                clearer.onWaypoint = false
                return true, false
            end
		else
			-- Don't take any action, the unit shouldn't be able to clear mines 
			--(we consider that they didn't get a mineclear command)
			return false
		end
	else
		-- It was a different command, do nothing
		return false
	end
end

function gadget:UnitCreated(unitID, unitDefID, teamID)
	local ud = UnitDefs[unitDefID]
	local cp = ud.customParams
	if cp and cp.canclearmines then
		Spring.InsertUnitCmdDesc(unitID, clearPathDesc)
	end
end

function gadget:Initialize()
	-- Fake UnitCreated events for existing units. (for '/luarules reload')
	local allUnits = Spring.GetAllUnits()
	for i=1,#allUnits do
		local unitID = allUnits[i]
		gadget:UnitCreated(unitID, Spring.GetUnitDefID(unitID))
	end
    Spring.AssignMouseCursor("Clear Path", "cursordemine", true, false)
	Spring.SetCustomCommandDrawData(CMD_CLEARPATH, "Clear Path", {1,0.5,0,.8}, false)
end

else

-- UNSYNCED


-- Unsynced Read
local GetActiveCommand = Spring.GetActiveCommand
local GetSelectedUnitsSorted = Spring.GetSelectedUnitsSorted
local TraceScreenRay = Spring.TraceScreenRay
local GetMouseState = Spring.GetMouseState
local GetUnitPositionAtEndOfQueue = GG.CmdQueue.GetUnitPositionAtEndOfQueue
local GetUnitActiveCommandPosition = GG.CmdQueue.GetUnitActiveCommandPosition

-- OpenGL
glColor = gl.Color
glDrawGroundQuad = gl.DrawGroundQuad
glPushMatrix = gl.PushMatrix
glPopMatrix = gl.PopMatrix
glTranslate = gl.Translate
glRotate = gl.Rotate
glShape = gl.Shape
-- variables

local clearInfos = {}


function gadget:Initialize()
    for unitDefID, unitDef in ipairs(UnitDefs) do
        local cp = unitDef.customParams
        if cp and cp.canclearmines then
            clearInfos[unitDefID] = true
        end
    end
end


function gadget:DrawWorld()
	local cmdID, cmdDescID, cmdDescType, cmdDescName = GetActiveCommand()
    
    if cmdDescName == "Clear Path" then
        local selectedUnitsSorted = GetSelectedUnitsSorted()
		local mx, my = GetMouseState()
		local what, coors = TraceScreenRay(mx, my, true)
        
		if (what == "ground") then
			local tx, tz = coors[1], coors[3]
            for unitDefID, _ in pairs(clearInfos) do
                local units = selectedUnitsSorted[unitDefID]
                if units then
                    local numUnits = #units
                    local rotation = 0
                    local distance = 0
                    local unitID
                    local ux, uy, uz
                    
                    -- Should find a way to use the average rotation for the actual command and not only the drawing
                    
                    -- for i=1, numUnits do
                        -- unitID = units[i]
                        -- ux, uy, uz = GetUnitActiveCommandPosition(unitID)
                        -- local dx, dz = tx - ux, tz - uz
                        -- rotation = rotation + math.atan2(dx, dz) / numUnits
                        -- distance = distance + math.sqrt(dx^2 + dz^2) / numUnits
                    -- end
                    
                    for i=1, numUnits do
                        unitID = units[i]
                        ux, uy, uz = GetUnitActiveCommandPosition(unitID)
                        local dx, dz = tx - ux, tz - uz
                        local rotation = math.atan2(dx, dz)
                        
                        local distance = math.sqrt(dx^2 + dz^2)
                        glColor(0, 255, 0, 0.1)
                        glPushMatrix()
                            glTranslate(ux, uy, uz)
                            glRotate(rotation  * (180 / 3.1415), 0, 1, 0)
                            local quadVertices = {
                                {v = {-MINE_CLEAR_RADIUS, 0, distance}},
                                {v = {-MINE_CLEAR_RADIUS, 0, 0}},
                                {v = {MINE_CLEAR_RADIUS, 0, 0}},
                                {v = {MINE_CLEAR_RADIUS, 0, distance}},
                            }
                            glShape(GL.QUADS, quadVertices)
                            quadVertices = {
                                {v = {-OBSTACLE_CLEAR_RADIUS, 0, distance}},
                                {v = {-OBSTACLE_CLEAR_RADIUS, 0, 0}},
                                {v = {OBSTACLE_CLEAR_RADIUS, 0, 0}},
                                {v = {OBSTACLE_CLEAR_RADIUS, 0, distance}},
                            }
                            glShape(GL.QUADS, quadVertices)

                        glPopMatrix()
                    end
                end
            end
		else
			return
		end
	end
end


end
