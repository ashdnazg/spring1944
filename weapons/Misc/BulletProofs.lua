-- Misc - Bulletproofs

-- Implementations

-- .30cal proof
local Bounce30cal = BulletProofClass:New{
  shieldInterceptType = 8, -- 001000
  shieldRadius       = 35,
}

-- .50cal proof
local Bounce50cal = BulletProofClass:New{
  shieldInterceptType = 24, -- 011000
  shieldRadius       = 40,
}

-- Return only the full weapons
return lowerkeys({
  [".30calproof"] = Bounce30cal,
  [".50calproof"] = Bounce50cal,
})
