function gadget:GetInfo()
	return {
		name      = "Spring: 1944 Planes",
		desc      = "Allows structures to order aircraft sorties.",
		author    = "Evil4Zerggin",
		date      = "13 February 2008",
		license   = "GNU LGPL, v2.1 or later",
		layer     = -5,
		enabled   = true  --  loaded by default?
	}
end

if not gadgetHandler:IsSyncedCode() then return end

local sqrt = math.sqrt
local sin, cos, atan2 = math.sin, math.cos, math.atan2

local CMD_PLANES = 34400
local PATROL_DISTANCE = 1000
local FORMATION_SEPARATION = 128
local DIAG_FORMATION_SEPARATION = FORMATION_SEPARATION * sqrt(2)
local RETREAT_TOLERANCE = 64 --retreating planes disappear when they reach this distance from the map edge
local CRUISE_SPEED = 0.75
local PLANE_STATE_ACTIVE = 0
local PLANE_STATE_RETREAT = 1

local CreateUnit = Spring.CreateUnit
local DestroyUnit = Spring.DestroyUnit
local SetUnitPosition = Spring.SetUnitPosition
local SetUnitRotation = Spring.SetUnitRotation
local SetUnitVelocity = Spring.SetUnitVelocity
local GetTeamResources = Spring.GetTeamResources
local GetTeamStartPosition = Spring.GetTeamStartPosition
local GetUnitCmdDescs = Spring.GetUnitCmdDescs
local EditUnitCmdDesc = Spring.EditUnitCmdDesc
local InsertUnitCmdDesc = Spring.InsertUnitCmdDesc
local UseUnitResource = Spring.UseUnitResource
local GetUnitFuel = Spring.GetUnitFuel
local GetUnitIsStunned = Spring.GetUnitIsStunned
local GetUnitDefID = Spring.GetUnitDefID
local GetUnitTeam = Spring.GetUnitTeam
local GetUnitPosition = Spring.GetUnitPosition
local GetGameFrame = Spring.GetGameFrame
local GetGroundHeight = Spring.GetGroundHeight
local SendMessageToTeam = Spring.SendMessageToTeam

local vNormalized = GG.Vector.Normalized
local vRotateY = GG.Vector.RotateY
local vClampToMapSize = GG.Vector.ClampToMapSize
local vNearestMapEdge = GG.Vector.NearestMapEdge
local vDistanceToMapEdge = GG.Vector.DistanceToMapEdge

local DelayCall = GG.Delay.DelayCall

local SetUnitNoSelect = GG.SetUnitNoSelect --uses game_noselect gadget
local GiveOrderToUnit = GG.GiveOrderToUnitDisregardingNoSelect

local mapSizeX, mapSizeZ = Game.mapSizeX, Game.mapSizeZ

local CMDTYPE_ICON_MAP = CMDTYPE.ICON_MAP
local CMDTYPE_ICON_UNIT_OR_MAP = CMDTYPE.ICON_UNIT_OR_MAP
local CMD_IDLEMODE = CMD.IDLEMODE
local CMD_MOVE = CMD.MOVE
local CMD_FIGHT = CMD.FIGHT
local CMD_PATROL = CMD.PATROL
local CMD_ATTACK = CMD.ATTACK
local CMD_OPT_SHIFT = CMD.OPT_SHIFT

----------------------------------------------------------------
--cmds
----------------------------------------------------------------
--unitname = sorties
local planeDefs = VFS.Include("LuaRules/Configs/plane_defs.lua")

--cmdID = sortie
local planeCmdIDs = {}

--unitID = state
local planeStates = {}

--set of unitIDs
local radioTowers = {}

local currCmdID = CMD_PLANES

local function GetDefaultName(sortie)
	local unitname = sortie.units[1]
	local unitDef = UnitDefNames[unitname]
	if not unitDef then return end

	return unitDef.tooltip
end

local function GetDefaultTexture(sortie)
	local unitname = sortie.units[1]
	local unitDef = UnitDefNames[unitname]
	if not unitDef then return end

	return "unitpics/" .. unitDef.buildpicname
end

local function GetDefaultTooltip(sortie)
	local planeList = {}
	local units = sortie.units
	local duration = 0
	for i=1,#units do
		local unitDef = UnitDefNames[units[i]]
		local planeName = unitDef.humanName
		local fuel = unitDef.maxFuel
		if fuel > 0 and duration then
			if fuel > duration then
				duration = fuel
			end
		else
			duration = nil
		end

		if planeList[planeName] then
			planeList[planeName] = planeList[planeName] + 1
		else
			planeList[planeName] = 1
		end
	end

	local planeString = ""
	local notFirst = false
	for planeName, count in pairs(planeList) do
		if notFirst then
			planeString = planeString .. ", "
		else
			notFirst = true
		end
		planeString = planeString .. count .. "x " .. planeName
	end

	local result = "Order " .. sortie.name .. " Sortie (" .. planeString .. ")\n"
		.. "Command Cost " .. sortie.cost .. "\n"
		.. "Delay " .. (sortie.delay or 0) .. "s\n"
		.. "Duration " .. (duration or "Permanent") .. "s"

	return result
end

local function BuildCmdDesc(sortie)
	result = {
		id = currCmdID,
		type = CMDTYPE_ICON_UNIT_OR_MAP,
		name = sortie.shortname or "",
		cursor = sortie.cursor or "Attack",
		tooltip = sortie.tooltip or GetDefaultTooltip(sortie),
		texture = sortie.texture or GetDefaultTexture(sortie),
	}

	planeCmdIDs[currCmdID] = sortie

	currCmdID = currCmdID + 1

	return result
end

for radioTowerID, sorties in pairs(planeDefs) do
	for i=1,#sorties do
		local sortie = sorties[i]
		sortie.name = sortie.name or GetDefaultName(sortie) or ""
		sortie.cmdDesc = BuildCmdDesc(sorties[i])
	end
end

----------------------------------------------------------------
--spawning
----------------------------------------------------------------

local function SpawnPlane(teamID, unitname, sx, sy, sz, cmdParams, dx, dy, dz, rotation, waypoint, numInFlight)
	if #cmdParams == 3 then
		cmdParams[1], cmdParams[2], cmdParams[3] = vClampToMapSize(cmdParams[1], cmdParams[2], cmdParams[3])
	end

	local unitDef = UnitDefNames[unitname]
	--local speed = unitDef.speed / 30
	local drag = unitDef.drag
	local speed = 20 -- unitDef.maxAcc * (1 - drag) / drag * CRUISE_SPEED
	local altitude = unitDef.wantedHeight
	sy = sy + altitude
	local unitID = CreateUnit(unitname, sx, sy, sz, 0, teamID)
	SetUnitPosition(unitID, sx, sy, sz)
	SetUnitVelocity(unitID, dx * speed, dy * speed, dz * speed)
	SetUnitRotation(unitID, 0, -rotation, 0) --SetUnitRotation uses left-handed convention
	GiveOrderToUnit(unitID, CMD_IDLEMODE, {0}, {}) --no land
	if #cmdParams == 1 then --specific target: attack it, then patrol to waypoint
		GiveOrderToUnit(unitID, CMD_ATTACK, cmdParams, {"shift"})
		if waypoint then
			GiveOrderToUnit(unitID, CMD_PATROL, waypoint, {"shift"})
		end
	else --location: fight to waypoint, then patrol to target
		if waypoint then
			GiveOrderToUnit(unitID, CMD_FIGHT, waypoint, {"shift"})
		end
		GiveOrderToUnit(unitID, CMD_PATROL, cmdParams, {"shift"})
	end
	planeStates[unitID] = PLANE_STATE_ACTIVE
	-- make the plane say something if it's the first in its group
	if numInFlight==1 then
		if unitDef.customParams.planevoice=="1" then
			Spring.CallCOBScript(unitID, "PlaneVoice", 1, 1)
		end
	end
end

local function GetFormationOffsets(numUnits, rotation)
	local result = {}
	if numUnits == 1 then
		result[1] = {0, 0, 0}
	elseif numUnits == 2 then
		result[1] = {vRotateY(-FORMATION_SEPARATION, 0, 0, rotation)}
		result[2] = {vRotateY(FORMATION_SEPARATION, 0, 0, rotation)}
	else
		local i = 1
		local pairNum = 0
		while true do
			result[i] = {vRotateY(-DIAG_FORMATION_SEPARATION * pairNum, 0, -DIAG_FORMATION_SEPARATION * pairNum, rotation)}
			i = i + 1
			pairNum = pairNum + 1
			if i > numUnits then break end

			result[i] = {vRotateY(DIAG_FORMATION_SEPARATION * pairNum, 0, -DIAG_FORMATION_SEPARATION * pairNum, rotation)}
			i = i + 1
			if i > numUnits then break end
		end
	end

	return result
end

local function SpawnFlight(teamID, name, units, sx, sy, sz, cmdParams)
	local tx, ty, tz
	if #cmdParams == 1 then
		tx, ty, tz = GetUnitPosition(cmdParams[1])
		if not tx then
			tx, ty, tz = GetTeamStartPosition(teamID)
			cmdParams = {tx, ty, tz}
		end
	else
		tx, ty, tz = cmdParams[1], cmdParams[2], cmdParams[3]
	end

	local dx, dy, dz, dist = vNormalized(tx - sx, 0, tz - sz)
	local rotation = atan2(dx, dz)

	local offsets = GetFormationOffsets(#units, rotation)
	if dist >= PATROL_DISTANCE then
		local wbx, wbz = sx + (dist - PATROL_DISTANCE) * dx, sz + (dist - PATROL_DISTANCE) * dz
		for i=1, #units do
			local offset = offsets[i]
			local waypoint = {}
			waypoint[1], waypoint[2], waypoint[3] = offset[1] + wbx, 0, offset[3] + wbz
			local ux, uz = offset[1] + sx, offset[3] + sz
			local uy = GetGroundHeight(ux, uz)
			local unitname = units[i]
			SpawnPlane(teamID, unitname, ux, uy, uz, cmdParams, dx, dy, dz, rotation, waypoint, i)
		end
	else
		for i=1, #units do
			local offset = offsets[i]
			local ux, uz = offset[1] + sx, offset[3] + sz
			local uy = GetGroundHeight(ux, uz)
			local unitname = units[i]
			SpawnPlane(teamID, unitname, ux, uy, uz, cmdParams, dx, dy, dz, rotation, waypoint, i)
		end
	end

	SendMessageToTeam(teamID, name .. " sortie arrived.")
end

local function GetSpawnPoint(teamID, numPlanes)
	local margin = FORMATION_SEPARATION * 0.5 * (numPlanes or 0)
	local sx, sy, sz = GetTeamStartPosition(teamID)
	local rx, ry, rz = vNearestMapEdge(sx, sy, sz, margin)
	return rx, ry, rz
end

----------------------------------------------------------------
--callins
----------------------------------------------------------------

function gadget:UnitCreated(unitID, unitDefID, teamID)
	local unitDef = UnitDefs[unitDefID]
	local unitDefName = unitDef.name
	local sorties = planeDefs[unitDefName]

	if not sorties then return end
	radioTowers[unitID] = true
	for i=1,#sorties do
		InsertUnitCmdDesc(unitID, sorties[i].cmdDesc)
	end
end

function gadget:AllowCommand(unitID, unitDefID, teamID, cmdID, cmdParams, cmdOptions)
	local planeState = planeStates[unitID]
	if planeState == PLANE_STATE_RETREAT or (planeState and cmdID == CMD_IDLEMODE) then
		return false
	end

	local sortie = planeCmdIDs[cmdID]
	if not sortie then
		return true
	end

	local _, _, inBuild = GetUnitIsStunned(unitID)

	if inBuild then
		--?
	else
		if UseUnitResource(unitID, "m", sortie.cost) then
			local sx, sy, sz = GetSpawnPoint(teamID, #(sortie.units))
			DelayCall(SpawnFlight, {teamID, sortie.name, sortie.units, sx, sy, sz, cmdParams}, sortie.delay * 30)
			SendMessageToTeam(teamID, sortie.name .. " sortie ordered. ETE " .. (sortie.delay or 0) .. "s.")
			local _, _, _, _, _, allyTeam = Spring.GetTeamInfo(teamID)
			for _, alliance in ipairs(Spring.GetAllyTeamList()) do
				if alliance ~= allyTeam and sortie.name ~= "Recon Plane" then
					Spring.SendMessageToAllyTeam(alliance, "Incoming Enemy Aircraft Spotted, arriving in 15-45 seconds")
				end
			end
		else
			SendMessageToTeam(teamID, "Not enough command to order " .. sortie.name .. " sortie!")
		end
	end

	return false
end

function gadget:GameFrame(n)
	for unitID, state in pairs(planeStates) do
		local unitDefID = GetUnitDefID(unitID)
		local unitDef = UnitDefs[unitDefID]
		local teamID = GetUnitTeam(unitID)
		if state == PLANE_STATE_ACTIVE then
			if GetUnitFuel(unitID) < 1 and unitDef.maxFuel > 0 then
				SetUnitNoSelect(unitID, true)
				local ex, ey, ez = GetSpawnPoint(teamID)
				GiveOrderToUnit(unitID, CMD_MOVE, {ex, ey, ez}, {})
				planeStates[unitID] = PLANE_STATE_RETREAT
				-- make it say something
				if unitDef.customParams.planevoice=="1" then
					Spring.CallCOBScript(unitID, "PlaneVoice", 1, 3)
				end
			end
		elseif state == PLANE_STATE_RETREAT then
			local ux, uy, uz = GetUnitPosition(unitID)
			if vDistanceToMapEdge(ux, uy, uz) <= RETREAT_TOLERANCE then
				DestroyUnit(unitID, false, true)
			end
		end
	end
	if n % 11 < 0.1 then
		for unitID, _ in pairs(radioTowers) do
			local cmdDescs = GetUnitCmdDescs(unitID)
			local teamID = GetUnitTeam(unitID)
			local command = GetTeamResources(teamID, "metal")
			for i,cd in ipairs(cmdDescs) do
				local sortie = planeCmdIDs[cd.id]
				if sortie then
					local disabled = (command < sortie.cost)
					if disabled ~= cd.disabled then
						EditUnitCmdDesc(unitID, i, { disabled = disabled })
					end
				end
			end
		end
	end
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID)
	planeStates[unitID] = nil
	radioTowers[unitID] = nil
end
