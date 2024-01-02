local QBCore = exports["qb-core"]:GetCoreObject()

function TakeItem(source, itemName, itemAmount)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player then return end

    if not Config.Debug then
        if player.Functions.RemoveItem(itemName, tonumber(itemAmount)) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[itemName], 'remove', tonumber(itemAmount))
        end
    end
end

function GiveItem(source, itemName, itemAmount, slot, info)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player then return end
    print(json.encode(info))
    if player.Functions.AddItem(itemName, tonumber(itemAmount), slot, info) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[itemName], 'add', tonumber(itemAmount))
    end

end

RegisterNetEvent('Winters:Server:Fleeca:RemoveItem', function(itemName, itemAmount)
    TakeItem(source, itemName, itemAmount)
end)

QBCore.Functions.CreateCallback('Winters:Server:Fleeca:CopCount', function(source, cb)
    local copsOnline = QBCore.Functions.GetDutyCount('police')
    cb(copsOnline)
end)