local QBCore = exports["qb-core"]:GetCoreObject()

local IsDrilling = false

function BlockInventory(isBusy)
    LocalPlayer.state:set("inv_busy", isBusy, true)
end

function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(1)
    end
end

function PlayHotwireAnim()
    local ped = PlayerPedId()
    loadAnimDict("anim@gangops@facility@servers@")
    TaskPlayAnim(ped, 'anim@gangops@facility@servers@', 'hotwire', 3.0, 3.0, -1, 1, 0, false, false, false)
end

function StopHotwireAnim()
    local ped = PlayerPedId()
    StopAnimTask(ped, "anim@gangops@facility@servers@", "hotwire", 1.0)                     
end


local function createTargets()
    -- Loop through each bank
    for bn, bank in ipairs(Config.Banks) do

        -- Loop through each door
        for dn, door in ipairs(bank.Doors) do
            local hackPanel = door.HackPanel
            local targetName = 'fleeca_bank_'..bn..'_heistpanel_'..dn
            if Config.Debug then 
                print('Creating ' .. targetName)
            end

            exports['qb-target']:AddBoxZone(
                targetName, 
                hackPanel.Coords, 
                hackPanel.Height, 
                hackPanel.Width, 
                {
                    name = targetName,
                    heading = hackPanel.Rotation,
                    minZ = hackPanel.MinZ,
                    maxZ = hackPanel.MaxZ,
                    debugPoly = Config.DebugPoly
                }, 
                {
                    options = {
                        {
                            action = function()
                                QBCore.Functions.TriggerCallback('Winters:Server:Fleeca:CheckVaultState', function(isBusy)
                                    if not isBusy then
                                        BlockInventory(true)
                                        StartDoorHack(bn, dn)
                                        BlockInventory(false)
                                    else
                                        QBCore.Functions.Notify(Config.KeypadBlockedMsg, 'error', 5000)
                                    end
                                end, bn, dn)
                            end,
                            canInteract = function()
                                QBCore.Functions.TriggerCallback('Winters:Server:Fleeca:CopCount', function(CurrentCops)
                                    if CurrentCops < Config.MinimumPolice then
                                        QBCore.Functions.Notify('Not enough police On Duty', 'error', 5000)
                                        ableToDo = false
                                    end
                                end)
                            end,
                            icon = 'fa-solid fa-vault',
                            label = 'Hack',
                            item = hackPanel.RequiredItems
                        },
                    },
                    distance = 1.5
            })
        end

        -- Loop through each locker
        for ln, locker in ipairs(bank.Lockers) do
            local targetName = 'fleeca_bank_'..bn..'_locker_'..ln
            if Config.Debug then 
                print('Creating ' .. targetName)
            end

            exports['qb-target']:AddBoxZone(
                targetName, 
                locker.Coords, 
                locker.Height, 
                locker.Width, 
                {
                    name = targetName,
                    heading = locker.Rotation,
                    minZ = locker.MinZ,
                    maxZ = locker.MaxZ,
                    debugPoly = Config.DebugPoly
                }, 
                {
                    options = {
                        {
                            action = function()
                                QBCore.Functions.TriggerCallback('Winters:Server:Fleeca:CheckLockerState', function(isBusy)
                                    if not isBusy then
                                        BlockInventory(true)
                                        OpenLocker(bn, ln)
                                        BlockInventory(false)
                                    else
                                        QBCore.Functions.Notify(Config.LockerBlockedMsg, 'error', 5000)
                                    end
                                end, bn, ln)
                            end,
                            -- canInteract = function()
                                
                            -- end,
                            icon = 'fa-solid fa-vault',
                            label = 'Open Locker',
                            item = locker.RequiredItems
                        },
                    },
                    distance = 1.5
            })
        end
        
    end
    
end

function RemoveItem(itemName, itemAmount)
    TriggerServerEvent('Winters:Server:Fleeca:RemoveItem', itemName, itemAmount)
end

function closeAllDoors()
    for bn, bank in ipairs(Config.Banks) do
        -- Loop through each door
        for dn, door in ipairs(bank.Doors) do
            SetDoorOpenState(bn, dn, false)
        end
        
    end
end

function UpdateQBDoorState(doorId, setLocked)
    TriggerServerEvent('qb-doorlock:server:updateState', doorId, setLocked, false, false, true, false, false)
end

function SetDoorOpenState(bn, dn, open)
    TriggerServerEvent('Winters:Server:Fleeca:SetDoorStatus', bn, dn, open)
    local door = Config.Banks[bn].Doors[dn]

    if door.LockId ~= '' then
        UpdateQBDoorState(door.LockId, not open)
    end
end

local function removeTargets()
    -- Loop through each bank
    for bn, bank in ipairs(Config.Banks) do
        -- Loop through each door
        for dn, door in ipairs(bank.Doors) do
            local hackPanel = door.HackPanel
            local targetName = 'fleeca_bank_'..bn..'_heistpanel_'..dn
            if Config.Debug then 
                print('Deleting ' .. targetName)
            end

            exports['qb-target']:RemoveZone(targetName)
        end
        
    end
end

function getStreetandZone(coords)
	local zone = GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z))
	local currentStreetHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
	currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
	playerStreetsLocation = currentStreetName .. ", " .. zone
	return playerStreetsLocation
end

function GetPedGender()
	local gender = "Male"
	if QBCore.Functions.GetPlayerData().charinfo.gender == 1 then gender = "Female" end
	return gender
end


function NotifyPoliceOnSuccess(bn, dn)
    local dispatch = Config.Banks[bn].Doors[bn].Dispatch
    Citizen.SetTimeout(Config.CalloutDelay, function() 
        local currentPos = Config.Banks[bn].CalloutPosition
        local locationInfo = getStreetandZone(currentPos)
        local gender = GetPedGender()

        local params = {
            dispatchcodename = dispatch.SuccessCodeName,
            dispatchCode = dispatch.SuccessCode,
            firstStreet = locationInfo,
            gender = gender,
            priorty = dispatch.SuccessPriorty,
            origin = {
                x = currentPos.x,
                y = currentPos.y,
                z = currentPos.z
            },
            dispatchMessage = dispatch.SuccessMessage,
            job = {"police"}
        }
        TriggerServerEvent('dispatch:server:notify', params)
    end)
end

function NotifyPoliceOnFail(bn, dn)
    local dispatch = Config.Banks[bn].Doors[bn].Dispatch
    Citizen.SetTimeout(Config.CalloutDelay, function() 
        local currentPos = Config.Banks[bn].CalloutPosition
        local locationInfo = getStreetandZone(currentPos)
        local gender = GetPedGender()
        local params = {
            dispatchcodename = dispatch.FailCodeName,
            dispatchCode = dispatch.FailCode,
            firstStreet = locationInfo,
            gender = gender,
            priorty = dispatch.FailPriorty,
            origin = {
                x = currentPos.x,
                y = currentPos.y,
                z = currentPos.z
            },
            dispatchMessage = dispatch.FailMessage,
            job = {"police"}
        }
        TriggerServerEvent('dispatch:server:notify', params)
    end)
end

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    createTargets()
    closeAllDoors()
end)

AddEventHandler('onClientResourceStop', function (resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    removeTargets()
end)

RegisterNetEvent('Winters:Client:Fleeca:StartThermite', function (bn, dn)
    local bombPos = Config.Banks[bn].Doors[dn].ThermitePosition
    AddExplosion(bombPos.x, bombPos.y, bombPos.z, 22, 1.0, true, false, true)
end)

RegisterNetEvent('Winters:Client:Fleeca:EndThermite', function (bn, dn)
    SetDoorOpenState(bn, dn, true)
end)