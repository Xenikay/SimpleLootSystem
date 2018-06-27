AddCSLuaFile()

ENT.Base 			= "looting_storage_base"
ENT.PrintName		= "Storage fridge"
ENT.Category        = "Looting system"
ENT.Spawnable		= true

ENT.lootModel = "models/props_wasteland/kitchen_fridge001a.mdl"
ENT.lootPos = { forward = 35, up = 35, right = 0 }
ENT.timeToLoot = 5
ENT.cooldownTime = 50

ENT.lootList = {}
ENT.lootList["nothing"] = 10
ENT.lootList["item_healthkit"] = 10
ENT.lootList["item_healthvial"] = 50
ENT.lootList["item_battery"] = 20
