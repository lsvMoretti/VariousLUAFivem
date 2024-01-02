local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('Winters:Server:Pacific:CheckTrolleyState', function(_, cb, trolleyId)
    local busy = Config.Trollies[trolleyId].IsBusy
    cb(busy)
end)

RegisterNetEvent('Winters:Server:Pacific:StartTakeMoneyFromTrolley', function(trolleyNo)
    Config.Trollies[trolleyNo].IsBusy = true
end)

RegisterNetEvent('Winters:Server:Pacific:FinishTakeMoneyFromTrolley', function(trolleyNo)
    local trolley = Config.Trollies[trolleyNo]

    DeleteEntity(trolley.ServerObject)

    local trolleyModel = Config.EmptyTrolleyModel;
    local object = CreateObjectNoOffset(trolleyModel, trolley.Coords.x, trolley.Coords.y, trolley.Coords.z, true, true, false)
    Config.Trollies[trolleyNo].ServerObject = object

    GiveItem(source, trolley.RewardItem,trolley.RewardAmount, false, trolley.RewardInfo)
end)