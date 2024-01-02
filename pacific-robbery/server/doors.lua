RegisterNetEvent('Winters:Server:Door2Success', function() 
    
    TriggerEvent('qb-scoreboard:server:SetActivityBusy', 'pacific', true)
    local bombModel = 'prop_bomb_01'
    local bombPos = Config.Door2.ThermitePosition
    local bombRot = Config.Door2.ThermiteRotation
    local bombObj = CreateObjectNoOffset(bombModel, bombPos.x, bombPos.y, bombPos.z, true, false, false)
    SetEntityRotation(bombObj, bombRot.x, bombRot.y, bombRot.z, 5)
    Citizen.Wait(5000)
    TriggerClientEvent('Winters:Server:Pacific:Door2StartExplosion', -1)
    Citizen.Wait(50000)
    TriggerClientEvent('Winters:Server:Pacific:Door2EndExplosion', -1)
    DeleteEntity(bombObj)
end)

RegisterNetEvent('Winters:Server:Door4Success', function() 

    local bombModel = 'prop_bomb_01'
    local bombPos = Config.Door4.ThermitePosition
    local bombRot = Config.Door4.ThermiteRotation
    local bombObj = CreateObjectNoOffset(bombModel, bombPos.x, bombPos.y, bombPos.z, true, false, false)
    SetEntityRotation(bombObj, bombRot.x, bombRot.y, bombRot.z, 5)
    Citizen.Wait(5000)
    TriggerClientEvent('Winters:Server:Pacific:Door4StartExplosion', -1)
    Citizen.Wait(50000)
    TriggerClientEvent('Winters:Server:Pacific:Door4EndExplosion', -1)
    DeleteEntity(bombObj)
end)

RegisterNetEvent('Winters:Server:Pacific:OpenValutDoor', function(vaultNetId)
    TriggerClientEvent('Winters:Server:Pacific:OnOpenValutDoor', -1)
end)