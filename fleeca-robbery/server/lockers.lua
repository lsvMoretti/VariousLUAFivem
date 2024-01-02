local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('Winters:Server:Fleeca:SetLockerBusyStatus', function(bn, ln, status)
    
    Config.Banks[bn].Lockers[ln].IsBusy = status
end)

RegisterNetEvent('Winters:Server:Fleeca:SetLockerOpenStatus', function(bn, ln, status)
    Config.Banks[bn].Lockers[ln].IsOpened = status
    local locker = Config.Banks[bn].Lockers[ln]
    GiveItem(source, locker.RewardItem, locker.RewardAmount)
end)

QBCore.Functions.CreateCallback('Winters:Server:Fleeca:CheckLockerState', function(_, cb, bn, ln)
    local locker = Config.Banks[bn].Lockers[ln]
    local busy = locker.IsBusy or locker.IsOpened or locker.IsEmpty
    cb(busy)
end)
