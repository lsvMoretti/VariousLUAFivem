local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('Winters:Server:Fleeca:CheckVaultState', function(_, cb, bn, dn)
    if Config.Debug then
        print('BN: ' .. bn .. ', DN: ' .. dn)
    end
    local disabled = Config.Banks[bn].Doors[dn].HackPanel.Disabled
    if Config.Debug then
        print('Disabled?: ' .. tostring(disabled))
    end
    cb(disabled)
end)

RegisterNetEvent('Winters:Server:Fleeca:SetDoorDisabled', function(bn, dn, disabled)
    Config.Banks[bn].Doors[dn].HackPanel.Disabled = disabled
end)

RegisterNetEvent('Winters:Server:Fleeca:SetDoorStatus', function(bn, dn, open)
    TriggerClientEvent('Winters:Client:Fleeca:SetDoorStatus', -1, bn, dn, open)
end)

RegisterNetEvent('Winters:Server:Fleeca:StartThermite', function(bn, dn)
    local door = Config.Banks[bn].Doors[dn]

    local bombModel = 'prop_bomb_01'
    local bombPos = door.ThermitePosition
    local bombRot = door.ThermiteRotation
    local bombObj = CreateObjectNoOffset(bombModel, bombPos.x, bombPos.y, bombPos.z, true, false, false)
    SetEntityRotation(bombObj, bombRot.x, bombRot.y, bombRot.z, 5)

    Citizen.Wait(3000)
    TriggerClientEvent('Winters:Client:Fleeca:StartThermite', -1, bn, dn)
    Citizen.Wait(50000)
    TriggerClientEvent('Winters:Client:Fleeca:EndThermite', -1, bn, dn)
    DeleteEntity(bombObj)

end)