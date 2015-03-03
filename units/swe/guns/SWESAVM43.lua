local SWESAVM43 = Tank:New(AssaultGun):New{
	name				= "SAV m/43",
	acceleration		= 0.051,
	brakeRate			= 0.15,
	buildCostMetal		= 1740,
	maxDamage			= 1200,
	maxReverseVelocity	= 1.665,
	maxVelocity			= 3.33,
	turnRate			= 160,
	trackOffset			= 3,
	trackWidth			= 19,

	weapons = {
		[1] = {
			name				= "Ansaldo75mmL34AP",
			maxAngleDif			= 30,
		},
		[2] = {
			name				= "Ansaldo75mmL34HE",
			maxAngleDif			= 30,
		},
		[3] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 55,
		armor_rear			= 15,
		armor_side			= 13,
		armor_top			= 13,
		maxammo				= 11,
		weaponcost			= 12,
	},
}

return lowerkeys({
	["SWESAVM43"] = SWESAVM43,
})
