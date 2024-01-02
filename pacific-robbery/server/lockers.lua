local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('Winters:Server:Pacific:SetLockerBusyStatus', function(lockerNo, status)
    Config.Lockers[lockerNo].IsBusy = status
end)

RegisterNetEvent('Winters:Server:Pacific:SetLockerOpenStatus', function(lockerNo, status)
    Config.Lockers[lockerNo].IsOpened = status
    local locker = Config.Lockers[lockerNo]
    GiveItem(source, locker.RewardItem, locker.RewardAmount)
end)

QBCore.Functions.CreateCallback('Winters:Server:Pacific:CheckLockerState', function(_, cb, lockerId)
    local busy = Config.Lockers[lockerId].IsBusy or Config.Lockers[lockerId].IsOpened or Config.Lockers[lockerId].IsEmpty
    cb(busy)
end)