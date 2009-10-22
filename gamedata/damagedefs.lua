--[[
  format:
  
  damagetype = {
    armortype = damageMod,
    ...
  }
  
  the damage mods are relative to the default damage given in the unit files
  you can change the default damage too, but other damage mods are based off the original
  damage mods other than default given explicitly in the unit files override these
  
  default usually corresponds to armouredvehicles
]]

local damagedefs = {
  default = {},
  none = {
    default = 0,
  },
  smallarm = {
    infantry = 1.25,
    guns = 1,
    unarmouredvehicles = 1/5,
    default = 1/6,
    lightbuildings = 1/16,
    bunkers = 0,
    tanks = 0,
    flag = 0,
    mines = 0,
  },
  explosive = {
    infantry = 9,
    unarmouredvehicles = 2,
    armouredvehicles = 1/2,
    lightbuildings = 2/3,
    guns = 3/4,
    tanks = 1/2,
    flag = 0,
  },
  kinetic = {
    unarmouredvehicles = 1/2,
    bunkers = 1/2,
    lightbuildings = 1/16,
    flag = 0,
    mines = 0,
  },
  shapedcharge = {
    lightbuildings = 1/4,
    flag = 0,
  },
  fire = {
    bunkers = 4,
    unarmouredvehicles = 2,
    tanks = 1/2,
    flag = 0,
  },
}

return damagedefs