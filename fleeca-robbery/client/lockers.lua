local QBCore = exports['qb-core']:GetCoreObject()

function OpenLocker(bn, ln)
    local locker = Config.Banks[bn].Lockers[ln]

    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)

    TriggerServerEvent('Winters:Server:Fleeca:SetLockerBusyStatus', bn, ln, true)

    loadAnimDict("anim@heists@fleeca_bank@drilling")
    TaskPlayAnim(ped, 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle', 3.0, 3.0, -1, 1, 0, false, false, false)
    local DrillObject = CreateObject('hei_prop_heist_drill', pos.x, pos.y, pos.z, true, true, true)
    AttachEntityToEntity(DrillObject, ped, GetPedBoneIndex(ped, 57005), 0.14, 0, -0.01, 90.0, -90.0, 180.0, true, true, false, true, 1, true)
    IsDrilling = true

    TriggerEvent('Drilling:Start', function(success)
        if success then
            StopAnimTask(ped, "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
            DetachEntity(DrillObject, true, true)
            DeleteObject(DrillObject)

            TriggerServerEvent('Winters:Server:Fleeca:SetLockerBusyStatus', bn, ln, true)
            TriggerServerEvent('Winters:Server:Fleeca:SetLockerOpenStatus', bn, ln, true)

            QBCore.Functions.Notify("You've broken the lock", "success")
            SetTimeout(500, function()
                IsDrilling = false
            end)
        else 
            
            TriggerServerEvent('Winters:Server:Fleeca:SetLockerBusyStatus', bn, ln, false)
            TriggerServerEvent('Winters:Server:Fleeca:SetLockerOpenStatus', bn, ln, false)
            StopAnimTask(ped, "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
            QBCore.Functions.Notify("You've failed to drill the lock", "error")
            DetachEntity(DrillObject, true, true)
            DeleteObject(DrillObject)   
            SetTimeout(500, function()
                IsDrilling = false
            end)
        end
    end)
end