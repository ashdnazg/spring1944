--[[
  format:
  sortie_unitname = {
    plane_unitname,
    plane_unitname,
    ...
    
    delay = number, -- number of frames before sortie arrives
    cursor = string, (default "Attack"), --cursor when ordering sortie
  }
]]

local sortieDefs = {
  gbr_sortie_recon = {
    "gbrauster",
    
    delay = 15,
  },
  
  gbr_sortie_interceptor = {
    "gbrspitfiremkxiv",
    "gbrspitfiremkxiv",
    "gbrspitfiremkxiv",
    "gbrspitfiremkxiv",
    
    delay = 15,
  },
  
  gbr_sortie_fighter_bomber = {
    "gbrspitfiremkix",
    "gbrspitfiremkix",
    
    delay = 45,
  },
  
  gbr_sortie_attack = {
    "gbrtyphoon",
    "gbrtyphoon",
    
    delay = 45,
  },
  
  ger_sortie_recon = {
    "gerfi156",
    
    delay = 15,
  },
  
  ger_sortie_interceptor = {
    "gerbf109",
    "gerbf109",
    "gerbf109",
    "gerbf109",
    
    delay = 15,
  },
  
  ger_sortie_fighter = {
    "gerfw190",
    "gerfw190",
    "gerfw190",
    "gerfw190",
    
    delay = 30,
  },
  
  ger_sortie_fighter_bomber = {
    "gerfw190g",
    "gerfw190g",
    
    delay = 45,
  },
  
  ger_sortie_attack = {
    "gerju87g",
    "gerju87g",
    "gerju87g",
    
    delay = 45,
  },
  
  rus_sortie_recon = {
    "ruspo2",
    
    delay = 15,
  },
  
  rus_sortie_interceptor = {
    "rusyak3",
    "rusyak3",
    "rusyak3",
    "rusyak3",
    
    delay = 15,
  },
  
  rus_sortie_fighter = {
    "rusla5fn",
    "rusla5fn",
    "rusla5fn",
    "rusla5fn",
    
    delay = 30,
  },
  
  rus_sortie_attack = {
    "rusil2",
    "rusil2",
    
    delay = 45,
  },
  
  us_sortie_recon = {
    "usl4",
    
    delay = 15,
  },
  
  us_sortie_interceptor = {
    "usp51dmustang",
    "usp51dmustang",
    "usp51dmustang",
    "usp51dmustang",
    
    delay = 15,
  },
  
  us_sortie_fighter_bomber = {
    "usp47thunderbolt",
    "usp47thunderbolt",
    
    delay = 45,
  },
  
  us_sortie_attack = {
    "usp51dmustangga",
    "usp51dmustangga",
    
    delay = 45,
  },
}

return sortieDefs
