AddCSLuaFile()

ENT.Base 			= "looting_storage_base"
ENT.PrintName		= "Storage box"
ENT.Category        = "Looting system"
ENT.Spawnable		= true

ENT.lootModel = "models/props_junk/wood_crate001a.mdl"
ENT.lootPos = { forward = 0, up = 35, right = 0 }
ENT.timeToLoot = 3
ENT.cooldownTime = 50

-- ENT.lootList = {}
-- ENT.lootList["nothing"] = 10
-- ENT.lootList["item_ammo_ar2"] = 25
-- ENT.lootList["item_ammo_pistol"] = 25
-- ENT.lootList["item_ammo_smg1"] = 25
-- ENT.lootList["weapon_pistol"] = 5
-- ENT.lootList["weapon_frag"] = 1
ENT.containerName = 'box'
