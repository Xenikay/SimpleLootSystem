AddCSLuaFile()

ENT.Base 			= "looting_storage_base"
ENT.PrintName		= "Storage drawer"
ENT.Category        = "Looting system"
ENT.Spawnable		= true

ENT.lootModel = "models/props_c17/FurnitureDrawer001a.mdl"
ENT.lootPos = { forward = 25, up = 0, right = 0 }
ENT.timeToLoot = 3
ENT.cooldownTime = 50

ENT.lootList = {}
ENT.lootList["nothing"] = 10
ENT.lootList["item_ammo_ar2"] = 25
ENT.lootList["item_ammo_pistol"] = 25
ENT.lootList["item_ammo_smg1"] = 25
ENT.lootList["weapon_pistol"] = 10
ENT.lootList["weapon_frag"] = 1
