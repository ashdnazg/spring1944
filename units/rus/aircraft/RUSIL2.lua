local RUS_IL2 = FighterBomber:New(ArmouredPlane):New{
	name				= "IL-2M Shturmovik",
	description			= "Attack Aircraft",
	buildCostMetal		= 3375,
	maxDamage			= 436,
	maxFuel				= 180,
		
	maxAcc				= 0.474,
	maxAileron			= 0.004,
	maxBank				= 0.75,
	maxElevator			= 0.0025,
	maxPitch			= 1,
	maxRudder			= 0.0019,
	maxVelocity			= 14,

	customParams = {
		enginesound			= "p51b-",
		enginesoundnr		= 16,
		maxammo				= 4,
	},

	weapons = {
		[1] = {
			name				= "RS82Rocket",
			maxAngleDif			= 30,
		},
		[2] = {
			name				= "RS82Rocket",
			maxAngleDif			= 30,
			slaveTo				= 1,
		},
		[3] = {
			name				= "bomb",
			mainDir				= [[0 -0.18 1]],
		},
		[4] = {
			name				= "bomb",
			mainDir				= [[0 -0.18 1]],
			slaveTo				= 3,
		},
		[5] = {
			name				= "VYa23mm",
			maxAngleDif			= 10,
		},
		[6] = {
			name				= "VYa23mm",
			maxAngleDif			= 10,
			slaveTo				= 5,
		},	
		[7] = {
			name				= "m2browningamg",
			maxAngleDif			= 10,
			slaveTo				= 5,
		},
		[8] = {
			name				= "m2browningamg",
			maxAngleDif			= 10,
			slaveTo				= 5,
		},
		[9] = {
			name				= "m2browningaa",
			maxAngleDif			= 90,
			mainDir				= [[0 .25 -1]],
		},
	},
}

local RUS_IL2PTAB = RUS_IL2:Clone("RUSIl2"):New{
	buildpic			= "RUSIL2PTAB.png", -- override clone
	weapons = {
		[1] = {
			name				= "NOWEAPON",
		},
		[2] = {
			name				= "PTAB",
			maxAngleDif			= 30,
		},
		[3] = {
			name				= "NOWEAPON",
		},
		[4] = {
			name				= "NOWEAPON",
		},
	},
}

return lowerkeys({
	["RUSIL2"] = RUS_IL2,
	["RUSIL2PTAB"] = RUS_IL2PTAB,
})
