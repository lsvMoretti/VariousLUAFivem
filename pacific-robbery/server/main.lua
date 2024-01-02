local QBCore = exports['qb-core']:GetCoreObject()
local CurrentCops = 0

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

RegisterNetEvent('winters:Server:Pacific:RemoveItem', function(itemName, itemAmount)
    TakeItem(source, itemName, itemAmount)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if(GetCurrentResourceName() ~= resourceName) then
        return
    end
    
    local trolleyModel = Config.TrolleyModel;
    -- Trollies
    for i, trolley in ipairs(Config.Trollies) do
        local object = CreateObjectNoOffset(trolleyModel, trolley.Coords.x, trolley.Coords.y, trolley.Coords.z, true, true, false)
        Config.Trollies[i].ServerObject = object
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if(GetCurrentResourceName() ~= resourceName) then
        return
    end
    -- Trollies
    for i, trolley in ipairs(Config.Trollies) do
        if DoesEntityExist(trolley.ServerObject) then
            DeleteEntity(trolley.ServerObject)
            Config.Trollies[i].ServerObject = ''
        end
    end
end)

QBCore.Functions.CreateCallback('Winters:Server:Pacific:CopCount', function(source, cb)
    
    local copsOnline = QBCore.Functions.GetDutyCount('police')
    cb(copsOnline)
end)