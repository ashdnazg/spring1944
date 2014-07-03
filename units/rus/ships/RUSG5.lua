local RUS_G5 = BoatMother:New{
	name					= "G-5 torpedo boat with M-8 rocket launcher",
	description				= "Rocket artillery boat",
	acceleration			= 0.1,
	brakeRate				= 0.05,
	buildCostMetal			= 1700,
	buildTime				= 1700,
	collisionVolumeOffsets	= [[0.0 -9.0 0.0]],
	collisionVolumeScales	= [[24.0 24.0 110.0]],
	corpse					= "RUSG5_dead",
	mass					= 15000,
	maxDamage				= 15000,
	maxReverseVelocity		= 1.1,
	maxVelocity				= 5.3,
	movementClass			= "BOAT_LightPatrol",
	objectName				= "RUSG5.s3o",
	soundCategory			= "RUSBoat",
	transportCapacity		= 2, -- 2 x 1fpu turrets
	turnRate				= 300,	
	weapons = {	
		[1] = { -- give primary weapon for ranging
			name				= "m8rocket82mm",
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH AIR OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
	customparams = {
		children = {
			"RUS_G5_Turret_DshK", 
			"RUS_G5_Turret_M-8", 
		},
	},
}

local RUS_G5_Turret_M_8 = BoatChild:New{
	name					= "M-8 Turret",
	description				= "Rocket Launcher",
	objectName				= "RUSG5_Turret_M-8.s3o",
  	weapons = {	
		[1] = {
			name				= "m8rocket82mm",
			maxAngleDif			= 45,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH AIR OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
	},
	customparams = {
		defaultmove				= 1,
	    maxammo					= 1,
		weaponcost				= 175,
		weaponswithammo			= 1,
		turretturnspeed			= 15,
		elevationspeed			= 5,
    },
}

local RUS_G5_Turret_DshK = BoatChild:New{
	name					= "DshK Turret",
	description				= "Heavy Machinegun Turret",
	objectName				= "RUSG5_Turret_DshK.s3o",
	weapons = {	
		[1] = {
			name				= "dshk",
			onlyTargetCategory	= "INFANTRY SOFTVEH AIR OPENVEH TURRET",
			maxAngleDif			= 270,
		},
	},
	customparams = {
		--barrelrecoildist		= 1,
		--barrelrecoilspeed		= 10,
		turretturnspeed			= 60,
		elevationspeed			= 35,
	},
}

return lowerkeys({
	["RUSG5"] = RUS_G5,
	["RUS_G5_Turret_M-8"] = RUS_G5_Turret_M_8,
	["RUS_G5_Turret_DshK"] = RUS_G5_Turret_DshK,
})
