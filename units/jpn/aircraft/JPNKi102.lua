local JPN_Ki102 = Fighter:New(ArmouredPlane):New{
	name				= "Ki-102b (Type 4) Assault Plane",
	description			= "Anti-Tank Aircraft",
	buildCostMetal		= 985,
	maxDamage			= 495,
	cruiseAlt			= 1250,
	radarDistance		= 1200,
	maxFuel				= 160,
	iconType			= "bomber",
		
	maxAcc				= 0.702,
	maxAileron			= 0.00375,
	maxBank				= 0.9,
	maxElevator			= 0.0025,
	maxPitch			= 1,
	maxRudder			= 0.0025,
	maxVelocity			= 13.8,

	customParams = {
		enginesound			= "yakb-",
		enginesoundnr		= 20,
		maxammo				= 18,
	},

	weapons = {
		[1] = {
			name				= "Ho40157mm",
			maxAngleDif			= 15,
			mainDir				= [[0 -1 16]],
		},
		[2] = {
			name				= "Ho520mmAP",
			maxAngleDif			= 10,
			mainDir				= [[0 -1 16]],
			slaveTo				= 1, -- TODO: why?
		},	
		[3] = {
			name				= "Ho520mmAP",
			maxAngleDif			= 10,
			mainDir				= [[0 .5 -1]],
			slaveTo				= 1, -- TODO: why?
		},
		[4] = {
			name				= "Te4",
			maxAngleDif			= 50,
			mainDir				= [[0 1 -1]],
		},
	},
}


return lowerkeys({
	["JPNKi102"] = JPN_Ki102,
})
