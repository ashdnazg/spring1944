local SWE_PvKanM43_Truck = ATGunTractor:New{
	name					= "Towed 5.7cm PvKan m/43",
	buildCostMetal			= 450,
	corpse					= "SWEScaniaVabisF11_Destroyed",
	trackOffset				= 5,
	trackWidth				= 12,
}

local SWE_PvKanM43_Stationary = LightATGun:New{
	name					= "Deployed 5.7cm PvKan m/43",
	corpse					= "ruszis2_destroyed", -- TODO: change

	weapons = {
		[1] = { -- AP
			name				= "zis257mmap", -- TODO: change
		},
	},
}

return lowerkeys({
	["SWEPvKanM43_Truck"] = SWE_PvKanM43_Truck,
	["SWEPvKanM43_Stationary"] = SWE_PvKanM43_Stationary,
})
