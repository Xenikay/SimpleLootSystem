AddCSLuaFile()

ENT.Base 			= "looting_storage_base"
ENT.PrintName		= "Storage filing cabinet"
ENT.Category        = "Looting system"
ENT.Spawnable		= true

ENT.lootModel = "models/props_wasteland/controlroom_filecabinet002a.mdl"
ENT.lootPos = { forward = 25, up = 0, right = 0 }
ENT.timeToLoot = 2
ENT.cooldownTime = 50

ENT.lootList = {}
ENT.lootList["nothing"] = 10
ENT.lootList["item_ammo_ar2"] = 25
ENT.lootList["item_ammo_pistol"] = 25
ENT.lootList["item_ammo_smg1"] = 25
ENT.lootList["weapon_pistol"] = 10
ENT.lootList["npc_grenade_frag"] = 1
