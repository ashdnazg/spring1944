local JPNHoNiI = OpenAssaultGun:New{
	name				= "Type 1 Ho-Ni I",
	acceleration		= 0.030,
	brakeRate			= 0.15,
	buildCostMetal		= 2050,
	maxDamage			= 1542,
	maxReverseVelocity	= 1.5,
	maxVelocity			= 2.7,
	trackOffset			= 5,
	trackWidth			= 14,

	weapons = {
		[1] = {
			name				= "Type9075mmAP",
			maxAngleDif			= 20,
		},
		[2] = {
			name				= "Type9075mmHE",
			maxAngleDif			= 20,
		},
		[3] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 50,
		armor_rear			= 25,
		armor_side			= 40,
		armor_top			= 0,
		maxammo				= 14,
		weaponcost			= 12,
	},
}

return lowerkeys({
	["JPNHoNiI"] = JPNHoNiI,
})
