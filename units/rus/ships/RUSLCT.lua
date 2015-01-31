local RUS_LCT = TankLandingCraft:New{
	name					= "LCT Mk. 6",
	acceleration			= 0.075,
	brakeRate				= 0.05,
	buildCostMetal			= 1600,
	collisionVolumeOffsets	= [[0.0 -30.0 0.0]],
	collisionVolumeScales	= [[60.0 50.0 220.0]],
	maxDamage				= 29100,
	maxReverseVelocity		= 0.35,
	maxVelocity				= 2,
	transportMass			= 15000,
	turnRate				= 170,	
	weapons = {	
		[1] = {
			name				= "Oerlikon20mmaa",
			maxAngleDif			= 240,
			mainDir				= [[1 0 0]],
		},
		[2] = {
			name				= "Oerlikon20mmaa",
			maxAngleDif			= 240,
			mainDir				= [[-1 0 0]],
		},
		[3] = {
			name				= "Oerlikon20mmhe",
			maxAngleDif			= 240,
			mainDir				= [[1 0 0]],
		},
		[4] = {
			name				= "Oerlikon20mmhe",
			maxAngleDif			= 240,
			mainDir				= [[-1 0 0]],
		},
		[5] = {
			name				= "Large_Tracer",
		},
	},
	customparams = {
		--[[ enable me later when using LUS
		deathanim = {
			["z"] = {angle = -30, speed = 10},
		},]]
	},
	sfxtypes = { -- remove once using LUS
		explosionGenerators = {
			[1] = "custom:SMOKEPUFF_GPL_FX",
			[8] = "custom:XSMALL_MUZZLEFLASH",
			[9] = "custom:XSMALL_MUZZLEDUST",
		},
	},
}


return lowerkeys({
	["RUSLCT"] = RUS_LCT,
})
