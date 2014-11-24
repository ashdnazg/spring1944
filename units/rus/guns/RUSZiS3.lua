local RUS_ZiS3_Truck = FGGunTractor:New{
	name					= "Towed 76mm ZiS-3",
	corpse					= "RUSZiS5_Destroyed",
	trackOffset				= 5,
	trackWidth				= 12,
}

local RUS_ZiS3_Stationary = FGGun:New{
	name					= "Deployed 76mm ZiS-3",
	corpse					= "RUSZiS-3_Destroyed",
	customParams = {
		weaponscost			= 12,
	},
	weapons = {
		[1] = { -- HE
			name	= "ZiS376mmHE",
		},
		[2] = { -- AP
			name	= "ZiS376mmAP",
		},
	},	
}

return lowerkeys({
	["RUSZiS3_Truck"] = RUS_ZiS3_Truck,
	["RUSZiS3_Stationary"] = RUS_ZiS3_Stationary,
})
