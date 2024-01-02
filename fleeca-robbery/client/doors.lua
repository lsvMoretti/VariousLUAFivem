local function SetDoorDisabled(bn, dn, isDisabled)
    TriggerServerEvent('Winters:Server:Fleeca:SetDoorDisabled', bn, dn, isDisabled)
end

local function OpenDoor(bn, dn)
    -- Open the doors
    SetDoorOpenState(bn, dn, true)
end

local function OnDoorHackSuccess(bn, dn)

    local door = Config.Banks[bn].Doors[dn]
    local hackPanel = door.HackPanel

    if Config.Debug then
        print('Success')
    end

    -- Remove Items when succeeded
    for _, item in ipairs(hackPanel.RemoveItemsOnHackSuccess) do
        RemoveItem(item, 1)
    end

    if Config.Banks[bn].Doors[dn].Dispatch.NotifyOnSuccess then
        NotifyPoliceOnSuccess(bn, dn)
    end

    if door.UseThermite then
        TriggerServerEvent('Winters:Server:Fleeca:StartThermite', bn, dn)
    else
        OpenDoor(bn, dn)
    end
end

local function OnDoorHackFail(bn, dn)
    if Config.Debug then
        print('Fail')
    end

    -- Allow doors to be re-hacked
    SetDoorDisabled(bn, dn, false)

    if Config.Banks[bn].Doors[dn].Dispatch.NotifyOnFail then
        NotifyPoliceOnFail(bn, dn)
    end
end

function StartDoorHack(bn, dn)
    local door = Config.Banks[bn].Doors[dn]
    local hackPanel = door.HackPanel

    SetDoorDisabled(bn, dn, true)

    for _, item in ipairs(hackPanel.RemoveItems) do
        RemoveItem(item, 1)
    end

    local hackType = hackPanel.HackType

    if hackType == 0 then
        exports['ps-ui']:Thermite(function(success)
            if success then
                OnDoorHackSuccess(bn, dn, hackType)
            else
                OnDoorHackFail(bn, dn, hackType)  -- Corrected the variable name
            end
        end, hackPanel.HackTime, 5, 3) -- Time, Gridsize (5, 6, 7, 8, 9, 10), IncorrectBlocks
    end  -- End of the first if statement

    if hackType == 1 then
        TriggerEvent("mhacking:show")
        TriggerEvent("mhacking:start", math.random(6, 7), hackPanel.HackTime, function(success)
            TriggerEvent("mhacking:hide")
            if success then
                OnDoorHackSuccess(bn, dn, hackType)
            else
                OnDoorHackFail(bn, dn, hackType)  -- Corrected the variable name
            end
        end)
    end  -- End of the second if statement
end

RegisterNetEvent('Winters:Client:Fleeca:SetDoorStatus', function(bn, dn, open)
    local door = Config.Banks[bn].Doors[dn]
    if door.DoorModel ~= '' then
        local coords = door.DoorModelCoords
        local rotation = door.ClosedRotation
        if open then
            rotation = door.OpenRotation
        end
        local object = GetClosestObjectOfType(coords["x"], coords["y"], coords["z"], 5.0, door.DoorModel, false, false, false)
        if Config.Debug then
            print('Door Object: ' .. object)
        end

        if object ~= 0 then
            SetEntityHeading(object, rotation)
        end
    end
end)