local JPNHoNiII = SPArty:New{
	name				= "Type 2 Ho-Ni II",
	acceleration		= 0.041,
	brakeRate			= 0.15,
	buildCostMetal		= 3150,
	maxDamage			= 1630,
	maxReverseVelocity	= 1.5,
	maxVelocity			= 3,
	trackOffset			= 5,
	trackWidth			= 14,

	weapons = {
		[1] = {
			name				= "Type91105mmL24HE",
			maxAngleDif			= 20,
		},
		[2] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 30,
		armor_rear			= 25,
		armor_side			= 25,
		armor_top			= 0,
		maxammo				= 4,
		weaponcost			= 25,
	},
}

return lowerkeys({
	["JPNHoNiII"] = JPNHoNiII,
})
