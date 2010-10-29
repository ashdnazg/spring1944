function gadget:GetInfo()
	return {
		name      = "Mine Clearance",
		desc      = "Implements mine clearance command for engineers",
		author    = "FLOZi (C.Lawrence)",
		date      = "03/10/10",
		license   = "GNU GPL v2",
		layer     = 1,
		enabled   = true  --  loaded by default?
  }
end

-- function localisations
-- Synced Read
local GetUnitDefID			= Spring.GetUnitDefID
local GetUnitPosition		= Spring.GetUnitPosition
local GetUnitsInCylinder	= Spring.GetUnitsInCylinder
-- Synced Ctrl
local CallCOBScript			= Spring.CallCOBScript
local DestroyUnit			= Spring.DestroyUnit
local SetUnitMoveGoal		= Spring.SetUnitMoveGoal

-- Constants
local CMD_CLEARMINES = 35522
local MIN_DIST = 25
local MINE_CLEAR_RADIUS = 200
local MINE_SEARCH_TIME = 5 -- time in seconds to clear spot
-- Variables
local sweepers = {}

if gadgetHandler:IsSyncedCode() then
--	SYNCED

local DelayCall = GG.Delay.DelayCall

local clearDesc = {
	name	= "Clear Mines",
	action	= "clearmines",
	id		= CMD_CLEARMINES,
	type	= CMDTYPE.ICON_MAP, -- change to ICON_AREA?
	tooltip	= "Clear mines at a given location",
	cursor	= "Clear Mines",
}

--	Custom Functions
function BlowMine(mineID)
	local px, py, pz = GetUnitPosition(mineID)
	DestroyUnit(mineID, false, true)
	Spring.SpawnCEG("HE_Small", px, py, pz)
	Spring.RemoveBuildingDecal(mineID)
end

function ClearMines(unitID, x, z)
	local tmpNearbyUnits = GetUnitsInCylinder(x, z, MINE_CLEAR_RADIUS)
	local mines = {}
	for _, tmpUnitID in pairs(tmpNearbyUnits) do
		-- check if that is a mine
		local tmpUD
		tmpUD = GetUnitDefID(tmpUnitID)
		tmpUnitDef=UnitDefs[tmpUD]
		if tmpUnitDef then
			if tmpUnitDef.customParams then
				if tonumber(UnitDefs[tmpUD].customParams.ismine) == 1 then
					table.insert(mines, tmpUnitID)
				end
			end
		end
	end
	for i = 1, #mines do
		-- remove this unit (maybe needs a special anim?)
		local mineID = mines[i]
		DelayCall(BlowMine, {mineID}, MINE_SEARCH_TIME / #mines * i * 30)
	end
end

--	CallIns

function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
	if cmdID == CMD_CLEARMINES then
		local ud = UnitDefs[unitDefID]
		local cp = ud.customParams
		if cp and cp.canclearmines then
			return true
		else
			-- Only allow CMD_CLEARMINES for units with the correct tag
			return false
		end
	else
		-- Allow any other command, cancel sweeper status
		sweepers[unitID] = nil
		return true
	end
end


function gadget:CommandFallback(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
	if cmdID == CMD_CLEARMINES then
		local ud = UnitDefs[unitDefID]
		local cp = ud.customParams
		if cp and cp.canclearmines then
			local x = cmdParams[1]
			local y = cmdParams[2]
			local z = cmdParams[3]	
			if not sweepers[unitID] then
				SetUnitMoveGoal(unitID, x, y, z) -- use radius, speed?
				sweepers[unitID] = true
				return true, false
			else
				local px, py, pz = GetUnitPosition(unitID)
				local distance = math.sqrt((x - px)^2 + (y - py)^2 + (z - pz)^2)
				if distance > MIN_DIST then
					return true, false
				else
					sweepers[unitID] = false
					CallCOBScript(unitID, "LookForMines", 0)
					ClearMines(unitID, x, z)
					return true, true
				end
			end
		else
			-- Only allow CMD_CLEARMINES for units with the correct tag
			return false
		end
	else
		-- Allow any other command
		return false
	end
end


function gadget:UnitCreated(unitID, unitDefID, teamID)
	local ud = UnitDefs[unitDefID]
	local cp = ud.customParams
	if cp and cp.canclearmines then
		Spring.InsertUnitCmdDesc(unitID, clearDesc)
	end
end


function gadget:Initialize()
	gadgetHandler:RegisterCMDID(CMD_CLEARMINES)
	-- Fake UnitCreated events for existing units. (for '/luarules reload')
	local allUnits = Spring.GetAllUnits()
	for i=1,#allUnits do
		local unitID = allUnits[i]
		gadget:UnitCreated(unitID, Spring.GetUnitDefID(unitID))
	end
	Spring.AssignMouseCursor("Clear Mines", "cursordemine", true, false)
	Spring.SetCustomCommandDrawData(CMD_CLEARMINES, "Clear Mines", {1,0.5,0,.8}, false)
end

else
--	UNSYNCED

end