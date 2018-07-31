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

local function uptadeChancesToServer()
    net.Start('Loot_UpdateChances')
    net.WriteTable(Looting_chances)
    net.SendToServer()
end

local function saveChances(chancesTable)
    local serialized = util.TableToJSON(chancesTable)
    file.Write(LOOTING_CHANCES_FILE, serialized)
    uptadeChancesToServer()
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
uptadeChancesToServer()

-- CreateClientConVar('null', '0', false, false, '"No convar" placeholder for functions which need a convar.')

local function updateItemsList(list, container)
    list:Clear()

    local items = Looting_chances[container]
    for item, chance in pairs(items) do
        list:AddLine(item, chance)
    end
end

local function createItemAddEditDialog(itemsList, container, class, chance)
    MsgN(container, class, chance)
    local edit = class ~= nil and chance ~= nil
    local newItemModal = vgui.Create('DFrame')
    newItemModal:SetSize(400, 130)
    newItemModal:Center()
    if edit then
        newItemModal:SetTitle('Edit '..class..' at '..container)
    else
        newItemModal:SetTitle('Add new item to '..container)
    end
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
    if edit then
        itemArea:SetDisabled(true)
        itemArea:SetText(class)
    end

    local chanceSlider = vgui.Create('DNumSlider', newItemModal)
    chanceSlider:SetText('Chance, %')
    chanceSlider:SetMin(0)
    chanceSlider:SetMax(100)
    chanceSlider:SetPos(10, 60)
    chanceSlider:SetWidth(380)
    if edit then
        chanceSlider:SetValue(chance)
    end

    local createBtn = vgui.Create('DButton', newItemModal)
    if edit then
        createBtn:SetText('Edit')
    else
        createBtn:SetText('Create')
    end
    createBtn:SetPos(10, 100)
    createBtn:SetWidth(380)
    createBtn.DoClick = function()
        -- local _, container = containerComboBox:GetSelected()
        local class = itemArea:GetText()
        local chance = math.Round(chanceSlider:GetValue(), 2)
        Looting_chances[container][class] = chance
        saveChances(Looting_chances)
        updateItemsList(itemsList, container)
        newItemModal:Close()
    end

    newItemModal:MakePopup()
end

-- Shows a Yes/No dialog with specified message. Runs yesCallback when Yes is clicked, does nothing when No is clicked.
local function yesNoDialog(message, yesCallback)
    local dialog = vgui.Create('DFrame')
    dialog:SetTitle('')
    dialog:SetSize(400, 80)
    dialog:Center()
    dialog:SetDraggable(false)
    dialog:SetSizable(false)
    dialog:DoModal(true)

    local messageLbl = vgui.Create('DLabel', dialog)
    messageLbl:SetText(message)
    messageLbl:SetPos(20, 20)
    messageLbl:SetWidth(380)

    local yesBtn = vgui.Create('DButton', dialog)
    yesBtn:SetText('Yes')
    yesBtn:SetPos(40, 40)
    yesBtn.DoClick = function()
        dialog:Close()
        yesCallback()
    end

    local noBtn = vgui.Create('DButton', dialog)
    noBtn:SetText('No')
    noBtn:SetPos(300, 40)
    noBtn.DoClick = function()
        dialog:Close()
    end

    dialog:MakePopup()
end

hook.Add('PopulateToolMenu', 'Looting chances', function()
    spawnmenu.AddToolMenuOption("Utilities", "Looting", "looting_chances", "Items & Chances", "", "", function(panel)
        local containerToTweakLabel = vgui.Create('DLabel', panel)
        containerToTweakLabel:SetText('Container to tweak')
        containerToTweakLabel:SetTextColor(Color(0, 0, 0))

		local containerComboBox = vgui.Create('DComboBox', panel)
        containerComboBox:SetSize(150, 30)

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
            updateItemsList(itemsList, data)
        end

        containerComboBox:ChooseOptionID(1)

        local function getCurrentContainer()
            local _, container = containerComboBox:GetSelected()
            return container
        end

        local addItemBtn = vgui.Create('DButton')
        addItemBtn:SetText('Add item')
        addItemBtn.DoClick = function()
            local _, container = containerComboBox:GetSelected()
            createItemAddEditDialog(itemsList, container)
        end

        local function getSelectedItemData()
            local lines = itemsList:GetSelected()
            if #lines == 0 then return end
            local container = getCurrentContainer()
            local class = lines[1]:GetColumnText(1)
            local chance = Looting_chances[container][class]

            return container, class, chance
        end

        local editItemBtn = vgui.Create('DButton', panel)
        editItemBtn:SetText('Edit selected')
        function editItemBtn:IsVisible()
            return #itemsList:GetSelected() == 0
        end
        editItemBtn.DoClick = function()
            local container, class, chance = getSelectedItemData()
            MsgN(container, class, chance)
            if container == nil then return end
            createItemAddEditDialog(itemsList, container, class, chance)
        end

        local removeItemBtn = vgui.Create('DButton', panel)
        removeItemBtn:SetText('Remove selected')
        function removeItemBtn:IsVisible()
            return #itemsList:GetSelectedLine() == 0
        end
        removeItemBtn.DoClick = function()
            local container, class, chance = getSelectedItemData()
            if container == nil then return end
            Looting_chances[container][class] = nil
            saveChances(Looting_chances)
            updateItemsList(itemsList, container)
        end

        local resetBtn = vgui.Create('DButton', panel)
        resetBtn:SetText('Restore defaults of this container')
        resetBtn.DoClick = function()
            yesNoDialog('Do you really want to restore defaults of this container?', function()
                local container = getCurrentContainer()
                Looting_chances[container] = defaultChances[container]
                saveChances(Looting_chances)
                updateItemsList(itemsList, container)
            end)
        end

        local resetAllBtn = vgui.Create('DButton', panel)
        resetAllBtn:SetText('Restore defaults of all containers')
        resetAllBtn.DoClick = function()
            yesNoDialog('Do you really want to restore defaults of ALL containers?', function()
                Looting_chances = defaultChances
                local container = getCurrentContainer()
                saveChances(Looting_chances)
                updateItemsList(itemsList, container)
            end)
        end

        panel:AddItem(containerToTweakLabel, containerComboBox)
        panel:AddItem(itemsList)
        panel:AddItem(addItemBtn)
        panel:AddItem(editItemBtn)
        panel:AddItem(removeItemBtn)
        panel:AddItem(resetBtn)
        panel:AddItem(resetAllBtn)
	end)
end)
