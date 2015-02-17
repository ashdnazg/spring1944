local GBRDaimler = ArmouredCar:New{
	name				= "Daimler Armoured Car Mk.II",
	acceleration		= 0.047,
	brakeRate			= 0.09,
	buildCostMetal		= 1350,
	maxDamage			= 680,
	maxReverseVelocity	= 2.965,
	maxVelocity			= 5.93,
	trackOffset			= 10,
	trackWidth			= 13,
	turnRate			= 405,

	weapons = {
		[1] = {
			name				= "qf2pdr40mmap",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[2] = {
			name				= "qf2pdr40mmhe",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[3] = {
			name				= "BESA",
			mainDir				= [[0 16 1]],
			maxAngleDif			= 210,
		},
		[4] = {
			name				= ".30calproof",
		},
	},
	customParams = {
		armor_front			= 15,
		armor_rear			= 14,
		armor_side			= 11,
		armor_top			= 8,
		maxammo				= 13,
		weaponcost			= 8,
		weaponswithammo		= 2,
	}
}

return lowerkeys({
	["GBRDaimler"] = GBRDaimler,
})
