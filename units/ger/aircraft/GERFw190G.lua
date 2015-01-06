local GER_Fw190G = FighterBomber:New{
	name				= "Fw 190F-8",
	buildCostMetal		= 3375,
	maxDamage			= 320,
		
	maxAcc				= 0.685,
	maxAileron			= 0.0054,
	maxBank				= 0.9,
	maxElevator			= 0.0042,
	maxPitch			= 1,
	maxRudder			= 0.003,
	maxVelocity			= 17.5,

	customParams = {
		enginesound			= "fw190b-",
		enginesoundnr		= 12,
	},

	weapons = {
		[2] = {
			name				= "mg15115mm",
			maxAngleDif			= 10,
			onlyTargetCategory	= "BUILDING INFANTRY SOFTVEH AIR OPENVEH HARDVEH SHIP LARGESHIP DEPLOYED",
		},
		[3] = {
			name				= "mg15115mm",
			maxAngleDif			= 10,
			slaveTo				= 2,
		},	
		[4] = {
			name				= "MG15120mm",
			maxAngleDif			= 10,
			slaveTo				= 2,
		},
		[5] = {
			name				= "MG15120mm",
			maxAngleDif			= 10,
			slaveTo				= 2,
		},
		[6] = {
			name 				= "Medium_Tracer",
		},
		[7] = {
			name				= "Large_Tracer",
		},
	},
}


return lowerkeys({
	["GERFw190G"] = GER_Fw190G,
})
