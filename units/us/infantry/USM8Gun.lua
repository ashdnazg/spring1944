local USM8Gun = InfantryGun:New{
	name					= "75mm M8",
	corpse					= "usm8gun_destroyed",

	weapons = {
		[1] = { -- HE
			name				= "M875mmHE",
		},
	},
}


return lowerkeys({
	["USM8Gun"] = USM8Gun,
})
