local armorDefs = {
	infantry	=	{
		--**Germany**--
		"GERAirEngineer",
		"GERObserv",
		"GEREngineer",
		"GERGrW34",
		"GERHQEngineer",
		"GERLabourer",
		"GERMG42",
		"GERMP40",
		"GERPanzerfaust",
		"GERPanzerschrek",
		"GERRifle",
		"GERSniper",

		--US--
		"USAirEngineer",
		"USEngineer",
		"USGIBAR",
		"USGIBazooka",
		"USGIFlamethrower",
		"USGIMG",
		"USGIRifle",
		"USGISniper",
		"USGIThompson",
		"USHQEngineer",
		"USM1Mortar",
		"USObserv",

		--USSR--
		"RUSCommander",
		"AI_RUSCommander",
		"RUSEngineer",
		"RUSRifle",
		"RUSPPsh",
		"RUSDP",
		"RUSPTRD",
		"RUSMaxim",
		"RUSRPG43",
		"RUSObserv",
		"RUSMortar",
		"RUSMaxim",
		"RUSSniper",
		"RUSPartisanRifle",
		"RUSCommissar",
		"AI_RUSCommissar",

		--Britain--
		"GBRHQEngineer",
		"GBREngineer",
		"GBRRifle",
		"GBRSTEN",
		"GBRBren",
		"GBRVickers",
		"GBRObserv",
		"GBRSniper",
		"GBR3inMortar",
		"GBRPIAT",
		"GBRCommandoC",
		"GBRCommando",
	},
	
	guns	=	{
		--**Germany**--
		"GERleIG18_bax",
		"GERleIG18_gunyard",
		"GERFlaK38",
		"GERPaK40",
		"GERleFH18",
		"GERleFH18_Stationary",
		"GERSandbagMG",
		"GERPaK40_Stationary",
		"GERFlak38_Stationary",
		"GERNebelwerfer",
		"GERNebelwerfer_Stationary",

		--US--
		"USM8Gun_bax",
		"USM8Gun_gunyard",
		"USM2Gun",
		"USM2Gun_Stationary",
		"USM5Gun",
		"USSandbagMG",
		"USM5Gun_Stationary",

		--USSR--
		"RUS61K",
		"RUSZiS2",
		"RUSZiS2_Stationary",
		"RUSZiS3",
		"RUSZiS3_Stationary",
		"RUSSandbagMG",
		"RUSM30",
		"RUSM30_Stationary",
		"RUS61K_Stationary",

		--Britain--
		"GBR25Pdr",
		"GBR25Pdr_Stationary",
		"GBR17Pdr",
		"GBRSandbagMG",
		"GBR17Pdr_Stationary",
	},

	lightBuildings	=	{
		--Germany--
		"GERBarracks",
		"GERVehicleYard",
		"GERResource",
		"GERStorage",
		"GERGunYard",
		"GERTankYard",
		"GERSupplyDepot",
		"GERTruckSupplies",
		"GERSPYard",

		--US--
		"USHQ",
		"AI_USHQ",
		"USCP",
		"USBarracks",
		"USVehicleYard",
		"USResource",
		"USStorage",
		"USGunYard",
		"USSupplyDepot",
		"USTruckSupplies",
		"USSPYard",

		--USSR--
		"RUSBarracks",
		"RUSVehicleYard",
		"RUSResource",
		"RUSStorage",
		"RUSGunYard",
		"RUSShack",
		"RUSPResource",
		"RUSSupplyDepot",
		"RUSTruckSupplies",
		"RUSSPYard",

		--Britain--
		"GBRResource",
		"GBRStorage",
		"GBRGunYard",
		"GBRVehicleYard",
		"GBRBarracks",
		"GBRLZ",
		"GBRHQ",
		"AI_GBRHQ",
		"GBRSupplyDepot",
		"GBRTruckSupplies",
		"GBRSPYard",
	},

	bunkers	=	{
		--**Germany**--
		"GERHQBunker",
		"AI_GERHQBunker",
	
		--US--

		--USSR--

		--Britain--
	
	},

	sandbags	=	{
			"Sandbags",
	},

	mines	=	{
		"APMine",
		"ATMine",
	},

	flag	=	{
		"GERflag",
		"USFlag",
		"RUSFlag",
		"GBRFlag",
		"flag",
	},

	tanks	=	{
		--**Germany**--
		"GERPanzerIII",
		"GERStuGIII",
		"GERPanzerIV",
		"GERPanther",
		"GERTiger",
		"GERTigerII",
		"GERJagdpanzerIV",

		--US--
		"USM4A4Sherman",
		"USM4A376Sherman",
		"USM4A3105Sherman",
		"USM5Stuart",

		--USSR--
		"RUSISU152",
		"RUST60",
		"RUST70",
		"RUST3485",
		"RUST3476",
		"RUSISU122",
		"RUSISU152",
		"RUSKV1",
		"RUSIS2",
		"RUSSU85",
		"RUSSU100",
		"RUSSU122",

		--Britain--

		"GBRShermanFirefly",
		"GBRCromwell",
		"GBRCromwellMkVI",
		"GBRChurchillMkVII",
		"GBRKangaroo",
	},

	armouredVehicles	=	{
		--**Germany**--
		"GERSdKfz250",
		"GERSdKfz251",
		"GERSdkfz9",
		"GERMarder",
		"GERWespe",

		--US--
		"USM8Greyhound",
		"USM3Halftrack",
		"USM7Priest",

		--USSR--
		"RUSBA64",
		"RUSM5Halftrack",
		"RUSSU76",

		--Britain--
		"GBRDaimler",
		"GBRM5Halftrack",
		"GBRAECMkIII",
		"GBRSexton",
	},

	unarmouredVehicles	=	{
		--**Germany**--
		"GEROpelBlitz",
		"GEROpelBlitz_Eng",
		"GERSupplyTruck",

		--US--
		"USGMCTruck",
		"USGMCTruck_Eng",
		"USGMCEngVehicle",
		"USSupplyTruck",

		--USSR--
		"RUSZiS5",
		"RUSZiS5_Eng",
		"RUSGAZAAA",
		"RUSBM13N",
		"RUSSupplyTruck",

		--Britain--
		"GBRBedfordTruck",
		"GBRBedfordTruck_Eng",
		"GBRMatadorEngVehicle",
		"RUSSupplyTruck",

		--All--
		"RubberDingy",
		"PontoonRaft",
	},

	lightPlanes	=	{
		--**Germany**--
		"GERFi156",
		"GERBf109",
		"GERFw190",
		"GERJu87G",
	
		--US--
		"USL4",
		"USP51DMustang",
		"USP51DMustangGA",

		--USSR--
		"RUSPo2",
		"RUSYak3",
		"RUSIL2",

		--Britain--
		"GBRSpitfireMkXIV",
		"GBRTyphoon",
	},

	heavyPlanes	=	{
		--**Germany**--
	
		--US--

		--USSR--

		--Britain--

	},
}

-- convert to named maps  (trepan is a noob)
for categoryName, categoryTable in pairs(armorDefs) do
	local t = {}
	for _, unitName in pairs(categoryTable) do
		t[unitName] = 1
	end
	armorDefs[categoryName] = t
end

local system = VFS.Include('gamedata/system.lua')	

return system.lowerkeys(armorDefs)

--	Infantry=;
--	Guns=;
--	LightBuildings=;
--	Bunkers=;
--	Sandbags=;
--	Mines=;
--	Flags=;
--	Tanks=;
--	ArmouredVehicles=;
--	UnarmouredVehicles=; 
