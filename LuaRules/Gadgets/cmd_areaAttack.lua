function gadget:GetInfo()
	return {
		name = "Area Attack",
		desc = "Give area attack commands to ground units",
		author = "KDR_11k (D. Becker)",
		date = "20 January 2008",
		license = "Public Domain",
		layer = 10,
		enabled = true
	}
end



if (gadgetHandler:IsSyncedCode()) then
--SYNCED

local attackList={}
local closeList={}
local range={}


local CMD_AREAATTACK = GG.CustomCommands.GetCmdID("CMD_AREAATTACK")

local aadesc= {
	name = "Area Attack",
	action="areaattack",
	id=CMD_AREAATTACK,
	type=CMDTYPE.ICON_AREA,
	tooltip="Attack an area randomly",
	cursor="Attack",
}

function gadget:GameFrame(f)
	for i,o in pairs(attackList) do
		attackList[i] = nil
		local phase = math.random(200*math.pi)/100.0
		local amp = math.random(o.radius + 1) -- a 0 radius will crash, so add 1
		Spring.GiveOrderToUnit(o.unit, CMD.INSERT, {0, CMD.ATTACK, 0, o.x + math.cos(phase)*amp, o.y, o.z + math.sin(phase)*amp}, {"alt"})
	end
	for i,o in pairs(closeList) do
		closeList[i] = nil
		Spring.SetUnitMoveGoal(o.unit,o.x,o.y,o.z,o.radius)
	end
end

function gadget:CommandFallback(u,ud,team,cmd,param,opt)
	-- Note the command is given to ALL units in selection if ONE has the "area attack" button.
	if cmd == CMD_AREAATTACK and range[ud] then
		local x,_,z = Spring.GetUnitPosition(u)
		local dist = math.sqrt((x-param[1])*(x-param[1]) + (z-param[3])*(z-param[3]))
		if dist <= range[ud] - (param[4] or 1) then
			table.insert(attackList, {unit = u, x=param[1], y=param[2], z=param[3], radius=param[4]})
		else
			table.insert(closeList, {unit = u, x=param[1], y=param[2], z=param[3], radius=range[ud]-param[4]})
		end
		return true, false
	end
	return false
end

function gadget:UnitCreated(u, ud, team)
	if UnitDefs[ud].customParams.canareaattack=="1" then
		range[ud] = WeaponDefs[UnitDefs[ud].weapons[1].weaponDef].range
		Spring.InsertUnitCmdDesc(u,aadesc)
	end
end

function gadget:Initialize()
	-- Fake UnitCreated events for existing units. (for '/luarules reload')
	local allUnits = Spring.GetAllUnits()
	for i=1,#allUnits do
		local unitID = allUnits[i]
		gadget:UnitCreated(unitID, Spring.GetUnitDefID(unitID))
	end
end

else

-- UNSYNCED

function gadget:Initialize()
	Spring.SetCustomCommandDrawData(SYNCED.CustomCommandIDs["CMD_AREAATTACK"], CMDTYPE.ICON_AREA, {1,0,0,.8},true)
end

end
