local SWEInf = {
	maxDamageMul		= 1.4,
}

local SWE_HQEngineer = EngineerInf:New(SWEInf):New{
	name				= "Ingenj�rer",
}

local SWE_Rifle = RifleInf:New(SWEInf):New{
	name				= "6,5 mm Gev�r m/38",
	weapons = {
		[1] = { -- Rifle
			name				= "Enfield",
		},
		[2] = { -- Grenade
			name				= "Model24",
		},
	},
}

local SWE_AgM42 = RifleInf:New(SWEInf):New{
	name				= "6,5 mm Automatgev�r m/42",
	weapons = {
		[1] = { -- Rifle
			name				= "M1Garand",
		},
		[2] = { -- Grenade
			name				= "Model24",
		},
	},
}

local SWE_KPistM3739 = SMGInf:New(SWEInf):New{
	name				= "9mm Kulsprutepistol m/37-39",
	weapons = {
		[1] = { -- SMG
			name				= "STEN",
		},
		[2] = { -- Grenade
			name				= "Model24",
		},
	},
}

local SWE_KgM37 = RifleInf:New(SWEInf):New{
	name				= "Kulsprutegev�r m/37 Light Machinegun",
	description			= "Long Range Assault/Light Fire Support Unit",
	script				= "usbar.cob",
	weapons = {
		[1] = { -- LMG
			name				= "BAR",
		},
		[2] = { -- Grenade
			name				= "Model24",
		},		
	},
}

local SWE_MG = HMGInf:New(SWEInf):New{
	name				= "Kulsprutegev�r m/36 Heavy Machinegun",
}

local SWE_MG_Sandbag = SandbagMG:New{
	name				= "Deployed Kulsprutegev�r m/36 Heavy Machinegun",
	weapons = {
		[1] = { -- HMG
			name				= "m1919a4browning_deployed",
		},
	},
}

local SWE_Sniper = SniperInf:New(SWEInf):New{
	name				= "6,5 mm Gev�r m/41 Sniper",
	weapons = {
		[1] = { -- Sniper Rifle
			name				= "Enfield_T",
		},
	},
}

local SWE_PSkottM45 = ATLauncherInf:New(SWEInf):New{
	name				= "Pansarskott m/45",
	script				= "GERPanzerFaust.cob",
	weapons = {
		[1] = { -- AT Launcher
			name				= "PanzerFaust",
		},
	},
}

local SWE_PvGM42 = ATRifleInf:New(SWEInf):New{
	name				= "Pansarv�rnsgev�r m/42",
	script				= "gerpanzerschrek.cob",
	weapons = {
		[1] = { -- AT Rifle
			name				= "Solothurn",
		},
	},
}

local SWE_Mortar = MedMortarInf:New(SWEInf):New{
	name				= "8 cm Granatkastare m/29-34",
	weapons = {
		[1] = { -- HE
			name				= "ML3inMortar",
		},
		[2] = { -- Smoke
			name				= "ML3inMortarSmoke",
		},
	},
}

local SWE_Observ = ObservInf:New(SWEInf):New{
	weapons = {
		[2] = { -- Pistol
			name				= "WaltherP38",
		},
	},
}


return lowerkeys({
	-- Regular Inf
	["SWEEngineer"] = SWE_Engineer,
	["SWERifle"] = SWE_Rifle,
	["SWEAgM42"] = SWE_AgM42,
	["SWEKPistM3739"] = SWE_KPistM3739,
	["SWEKgM37"] = SWE_KgM37,
	["SWEMG_Sandbag"] = SWE_MG_Sandbag,
	["SWEMG"] = SWE_MG,
	["SWESniper"] = SWE_Sniper,
	["SWEPvGM42"] = SWE_PvGM42,
	["SWEPSkottM45"] = SWE_PSkottM45,
	["SWEMortar"] = SWE_Mortar,
	["SWEObserv"] = SWE_Observ,
})
