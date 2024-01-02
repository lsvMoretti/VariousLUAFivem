local QBCore = exports["qb-core"]:GetCoreObject()

--[[ Script to handle the process of setting up & going through the doors ]]
local function DoorTwoThermitePlantSuccess()
    TriggerServerEvent('Winters:Server:Door2Success')
    if not Config.Debug then
        for _, item in ipairs(Config.Door2.RemoveItemsOnHackSuccess) do
            RemoveItem(item, 1)
        end
    end
    TriggerServerEvent('hud:server:GainStress', math.random(4, 8))
    QBCore.Functions.Notify(Config.PlantSuccessMessage, 'success', 5000)
    
    NotifyPoliceOnSuccess()
end

local function DoorTwoThermitePlantFail()
    QBCore.Functions.Notify(Config.PlantFailMessage, 'error', 5000)
    NotifyPoliceOnFail()
end

RegisterNetEvent("Winters:Client:Pacific:Door2Hack",function()
    local ableToDo = true
    QBCore.Functions.TriggerCallback('Winters:Server:Pacific:CopCount', function(CurrentCops)
        if CurrentCops < Config.MinimumPolice then
            QBCore.Functions.Notify('Not enough police On Duty', 'error', 5000)
            ableToDo = false
        end
    end)

    if(ableToDo == false) then return end

    for _, item in ipairs(Config.Door2.RemoveItems) do
        RemoveItem(item, 1)
    end
    PlayHotwireAnim()

    exports["ps-ui"]:Thermite(
        function(success)
            StopHotwireAnim()
            if success then
                DoorTwoThermitePlantSuccess()
            else
                DoorTwoThermitePlantFail()
            end
    end, Config.Door2.Time, Config.Door2.Gridsize, Config.Door2.IncorrectBlocks)
end)

RegisterNetEvent('Winters:Server:Pacific:Door2StartExplosion', function() 
    
    local bombPos = Config.Door2.ThermitePosition
    AddExplosion(bombPos.x, bombPos.y, bombPos.z, 22, 1.0, true, false, true)
end)

RegisterNetEvent('Winters:Server:Pacific:Door2EndExplosion', function() 
    UpdateDoorState(Config.Door2.LockId, false)
end)

local function OpenPacificVault()
    local object = GetClosestObjectOfType(Config.Door3.ModelCoords["x"], Config.Door3.ModelCoords["y"], Config.Door3.ModelCoords["z"], 5.0, Config.Door3.Model, false, false, false)
    if object ~= 0 then
        local netId = ObjToNet(object)
        TriggerServerEvent('Winters:Server:Pacific:OpenValutDoor', netId)
    end
end

local function DoorThreeHackSuccess()
    if not Config.Debug then
        for _, item in ipairs(Config.Door3.RemoveItemsOnHackSuccess) do
            RemoveItem(item, 1)
        end
    end
    
    TriggerServerEvent('hud:server:GainStress', math.random(4, 8))
    QBCore.Functions.Notify("You've hacked the panel", 'success', 5000)
    OpenPacificVault()
end

local function DoorThreeHackFail()
    QBCore.Functions.Notify("You've failed to hack the panel", 'error', 5000)
end

RegisterNetEvent('Winters:Client:Pacific:Door3Hack', function()
    for _, item in ipairs(Config.Door3.RemoveItems) do
        RemoveItem(item, 1)
    end

    PlayHotwireAnim()
    exports['ps-ui']:Maze(function(success)
        StopHotwireAnim()
        if success then
            DoorThreeHackSuccess()
        else
            DoorThreeHackFail()
        end
    end, Config.Door3.HackTimeLimit) -- Hack Time Limit
end)

RegisterNetEvent('Winters:Server:Pacific:OnOpenValutDoor', function() 
    local object = GetClosestObjectOfType(Config.Door3.ModelCoords["x"], Config.Door3.ModelCoords["y"], Config.Door3.ModelCoords["z"], 5.0, Config.Door3.Model, false, false, false)
    if object ~= 0 then
        SetEntityHeading(object, Config.Door3.ModelOpened)
    end
    exports['qb-target']:RemoveZone("fleeca-door3")
end)

local function DoorFourThermitePlantSuccess()
    TriggerServerEvent('Winters:Server:Door4Success')
    if not Config.Debug then
        for _, item in ipairs(Config.Door4.RemoveItemsOnHackSuccess) do
            RemoveItem(item, 1)
        end
    end
    TriggerServerEvent('hud:server:GainStress', math.random(4, 8))
    exports['qb-target']:RemoveZone("fleeca-door4")
    QBCore.Functions.Notify(Config.PlantSuccessMessage, 'success', 5000)
end

function DoorFourThermitePlantFail()
    QBCore.Functions.Notify(Config.PlantFailMessage, 'error', 5000)
end

RegisterNetEvent("Winters:Client:Pacific:Door4Hack",function()
    PlayHotwireAnim()
    for _, item in ipairs(Config.Door4.RemoveItems) do
        RemoveItem(item, 1)
    end
    exports["ps-ui"]:Thermite(
        function(success)
            StopHotwireAnim()
            if success then
                DoorFourThermitePlantSuccess()
            else
                DoorFourThermitePlantFail()
            end
    end, Config.Door4.Time, Config.Door4.Gridsize, Config.Door4.IncorrectBlocks) -- Time, Gridsize (5, 6, 7, 8, 9, 10), IncorrectBlocks
end)

RegisterNetEvent('Winters:Server:Pacific:Door4StartExplosion', function() 
    
    local bombPos = Config.Door4.ThermitePosition
    print(json.encode(bombPos))
    AddExplosion(bombPos.x, bombPos.y, bombPos.z, 22, 1.0, true, false, true)
end)

RegisterNetEvent('Winters:Server:Pacific:Door4EndExplosion', function() 
    UpdateDoorState(Config.Door4.LockId, false)
end)