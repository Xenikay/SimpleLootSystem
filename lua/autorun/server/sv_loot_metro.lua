util.AddNetworkString("Loot_EnableProgress")
util.AddNetworkString('Loot_UpdateChances')

net.Receive('Loot_UpdateChances', function()
    Looting_chances = net.ReadTable()
end)
