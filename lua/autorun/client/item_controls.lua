-- Table with default chances.
local defaultChances = {
    box = {
        nothing = 10,
        item_ammo_ar2 = 25,
        item_ammo_pistol = 25,
        item_ammo_smg1 = 25,
        weapon_pistol = 5,
        weapon_frag = 1,
    },

    cabinet = {
        nothing = 10,
        item_ammo_ar2 = 25,
        item_ammo_pistol = 25,
        item_ammo_smg1 = 25,
        weapon_pistol = 10,
        npc_grenade_frag = 1,
    },

    drawer = {
        nothing = 10,
        item_ammo_ar2 = 25,
        item_ammo_pistol = 25,
        item_ammo_smg1 = 25,
        weapon_pistol = 10,
        weapon_frag = 1,
    },

    dresser = {
        nothing = 10,
        item_ammo_ar2 = 25,
        item_ammo_pistol = 25,
        item_ammo_smg1 = 25,
        weapon_pistol = 10,
        weapon_frag = 1,
    },

    fridge = {
        nothing = 10,
        item_healthkit = 10,
        item_healthvial = 50,
        item_battery = 20,
    },

    little_cabinet = {
        nothing = 10,
        item_ammo_ar2 = 25,
        item_ammo_pistol = 25,
        item_ammo_smg1 = 25,
        weapon_pistol = 5,
        weapon_slam = 1,
    },

    locker = {
        nothing = 10,
        item_ammo_ar2 = 25,
        item_ammo_pistol = 25,
        item_ammo_smg1 = 25,
        weapon_smg1 = 5,
        weapon_frag = 1,
    },
}

local LOOTING_CHANCES_FILE = 'looting_chances.txt'

local function chancesFileExists()
    return file.Exists(LOOTING_CHANCES_FILE, 'DATA')
end

local function loadChances()
    local serialized = file.Read(LOOTING_CHANCES_FILE)
    return util.JSONToTable(serialized)
end

local function saveChances(chancesTable)
    local serialized = util.TableToJSON(chancesTable)
    file.Write(LOOTING_CHANCES_FILE, serialized)
end

-- Global table with container settings tables.
-- Each container settings table contains lootable items as keys and chances to loot them in percents as values.
if chancesFileExists() then
    Looting_chances = loadChances()
else
    Looting_chances = defaultChances
end
