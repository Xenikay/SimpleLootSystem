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

-- Transforms "snake_case" to "Snake case"
local function snakeCaseToNormal(str)
    str = string.Replace(str, '_', ' ')  -- Replace underscore with spaces
    str = string.upper(str[1]) .. string.sub(str, 2)  -- Make first letter uppercase
    return str
end

-- Global table with container settings tables.
-- Each container settings table contains lootable items as keys and chances to loot them in percents as values.
if chancesFileExists() then
    Looting_chances = loadChances()
else
    Looting_chances = defaultChances
end

-- CreateClientConVar('null', '0', false, false, '"No convar" placeholder for functions which need a convar.')

hook.Add('PopulateToolMenu', 'Looting chances', function()
    spawnmenu.AddToolMenuOption("Utilities", "Looting", "looting_chances", "Items & Chances", "", "", function(panel)
        local containerToTweakLabel = vgui.Create('DLabel', panel)
        containerToTweakLabel:SetText('Container to tweak')

		local containerComboBox = vgui.Create('DComboBox', panel)

        -- Add containers from Looting_chances in a loop
        for container, _ in pairs(Looting_chances) do
            containerComboBox:AddChoice(snakeCaseToNormal(container), container)
        end

        local itemsList = vgui.Create("DListView", panel)
        itemsList:SetHeight(200)
        itemsList:SetMultiSelect(false)
        itemsList:AddColumn("Item")
        itemsList:AddColumn("Chance, %")

        -- itemsList:AddLine( "PesterChum", "2mb" )
        -- itemsList:AddLine( "Lumitorch", "512kb" )
        -- itemsList:AddLine( "Troj-on", "661kb" )

        -- itemsList.OnRowSelected = function(lst, index, pnl)
	    --     print( "Selected " .. pnl:GetColumnText( 1 ) .. " ( " .. pnl:GetColumnText( 2 ) .. " ) at index " .. index )
        -- end

        function containerComboBox:OnSelect(index, value, data)
            -- TODO
            itemsList:Clear()

            local items = Looting_chances[data]
            for item, chance in pairs(items) do
                itemsList:AddLine(item, chance)
            end
        end

        containerComboBox:ChooseOption('Box', 1)

        local addItemBtn = vgui.Create('DButton')
        addItemBtn:SetText('Add item')
        addItemBtn.DoClick = function()
            local newItemModal = vgui.Create('DFrame')
            newItemModal:SetSize(400, 130)
            newItemModal:Center()
            newItemModal:SetTitle('New item')
            newItemModal:SetDraggable(false)
            newItemModal:SetSizable(false)
            newItemModal:DoModal(true)

            local itemLabel = vgui.Create('DLabel', newItemModal)
            itemLabel:SetText('Item class (i. e. item_healthkit)')
            itemLabel:SetPos(10, 30)
            itemLabel:SetWidth(200)

            -- local chanceLabel = vgui.Create('DLabel', newItemModal)
            -- chanceLabel:SetText()

            local itemArea = vgui.Create('DTextEntry', newItemModal)
            itemArea:SetPos(180, 30)
            itemArea:SetWidth(200)

            local chanceSlider = vgui.Create('DNumSlider', newItemModal)
            chanceSlider:SetText('Chance, %')
            chanceSlider:SetMin(0)
            chanceSlider:SetMax(100)
            chanceSlider:SetPos(10, 60)
            chanceSlider:SetWidth(380)

            local createBtn = vgui.Create('DButton', newItemModal)
            createBtn:SetText('Create')
            createBtn:SetPos(10, 100)
            createBtn:SetWidth(380)
            createBtn.DoClick = function()
                local _, container = containerComboBox:GetSelected()
                local class = itemArea:GetText()
                local chance = chanceSlider:GetValue()
                Looting_chances[container][class] = chance
                saveChances(Looting_chances)
                newItemModal:Close()
            end

            newItemModal:MakePopup()
        end

        local editItemBtn = vgui.Create('DButton', panel)
        editItemBtn:SetText('Edit selected')
        function editItemBtn:IsVisible()
            return #itemsList:GetSelectedLine() == 0
        end
        editItemBtn.DoClick = function()
            -- TODO
        end

        local removeItemBtn = vgui.Create('DButton', panel)
        removeItemBtn:SetText('Remove selected')
        function removeItemBtn:IsVisible()
            return #itemsList:GetSelectedLine() == 0
        end
        removeItemBtn.DoClick = function()
            -- TODO
        end

        panel:AddItem(containerToTweakLabel, containerComboBox)
        panel:AddItem(itemsList)
        panel:AddItem(addItemBtn)
        panel:AddItem(editItemBtn)
        panel:AddItem(removeItemBtn)
	end)
end)
