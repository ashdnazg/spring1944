local damagedefs = {
  default = {},
  none = {},
  smallarm = {
    infantry = 1,
    guns = 1,
    planes = 1,
    unarmouredvehicles = 0.375,
    lightbuildings = 0.25,
    default = 0.125,
    bunkers = 0,
    tanks = 0,
    flag = 0,
    mines = 0,
  },
  explosive = {
    unarmouredvehicles = 2,
    guns = 0.5,
    bunkers = 0.25,
    tanks = 0.25,
    flag = 0,
  },
  kinetic = {
    lightbuildings = 0.125,
    bunkers = 0.125,
    flag = 0,
    mines = 0,
  },
  shapedcharge = {
    bunkers = 2,
    flag = 0,
  },
  fire = {
    bunkers = 4,
    unarmouredvehicles = 2,
    tanks = 0.5,
    flag = 0,
  },
}

return damagedefs