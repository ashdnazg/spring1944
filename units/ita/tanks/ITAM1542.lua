local ITAM1542 = LightTank:New{
	name				= "Carro Mediuo M15/42",
	buildCostMetal		= 1850,
	maxDamage			= 1550,
	trackOffset			= 5,
	trackWidth			= 18,

	weapons = {
		[1] = {
			name				= "CannoneDa47mml40AP",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "CannoneDa47mml40HE",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = { -- coax MG
			name				= "BredaM38",
			maxAngleDif			= 210,
		},
		[4] = { -- hull MG 1
			name				= "BredaM38",
		},
		[5] = { -- hull MG 2
			name				= "BredaM38",
			slaveTo				= 4,
		},
		[6] = {
			name				= ".50calproof",
		},
	},
	customParams = {
		armor_front			= 43,
		armor_rear			= 25,
		armor_side			= 25,
		armor_top			= 14,
		maxammo				= 25,
		weaponcost			= 8,
		maxvelocitykmh		= 40,
	},
}

return lowerkeys({
	["ITAM1542"] = ITAM1542,
})
