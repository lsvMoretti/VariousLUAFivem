local QBCore = exports["qb-core"]:GetCoreObject()

local IsDrilling = false

local function createTargets()
    -- Door 2
    exports["qb-target"]:AddTargetModel(
        Config.Door2.Model,
        {
            options = {
                {
                    num = 1,
                    type = "client",
                    event = "Winters:Client:Pacific:Door2Hack",
                    icon = "fas fa-bomb",
                    label = "Place Thermite",
                    item = Config.Door2.RequiredItems,
                }
            },
            distance = 2.5
        }
    )
    -- Door 3 Panel
    exports['qb-target']:AddBoxZone("fleeca-door3",vector3(252.87, 228.57, 101.68), 0.6, 0.2, {
        name = "fleeca_door3_panel",
        heading = 340.0,
        debugPoly = Config.DebugPoly,
        minZ = 101.78, 
        maxZ = 102.43, 
        }, {
            options = { 
                { 
                    num = 1,
                    type = "client",
                    event = "Winters:Client:Pacific:Door3Hack",
                    icon = "fas fa-laptop",
                    label = "Hack Panel",
                    item = Config.Door3.RequiredItems
                }
            },
        distance = 2.5,
    })
    -- Door 4
    exports['qb-target']:AddBoxZone("fleeca-door4",vector3(252.42, 220.76, 101.68), 0.4, 1.2, {
        name = "fleeca_door4_panel",
        heading = 340.0,
        debugPoly = Config.DebugPoly,
        minZ = 100.58,
        maxZ = 102.98, 
        }, {
            options = { 
                { 
                    num = 1,
                    type = "client",
                    event = "Winters:Client:Pacific:Door4Hack",
                    icon = "fas fa-bomb",
                    label = "Place Thermite",
                    item = Config.Door4.RequiredItems
                }
            },
        distance = 2.5,
    })
    -- Locker Points
    for i, locker in ipairs(Config.Lockers) do
        exports['qb-target']:AddBoxZone(
            'pacific_coords_locker_'..i, 
            locker.Coords, 
            locker.Height, 
            locker.Width, 
            {
                name = 'pacific_coords_locker_'..i,
                heading = locker.Rotation,
                minZ = locker.MinZ,
                maxZ = locker.MaxZ,
                debugPoly = Config.DebugPoly
            }, 
            {
                options = {
                    {
                        action = function()
                            QBCore.Functions.TriggerCallback('Winters:Server:Pacific:CheckLockerState', function(isBusy)
                                if not isBusy then
                                    BlockInventory(true)
                                    OpenLocker(i)
                                    BlockInventory(false)
                                else
                                    QBCore.Functions.Notify('This locker is being emptied or has been emptied!', 'error', 5000)
                                end
                            end, i)
                        end,
                        canInteract = function()
                            return not IsDrilling and not locker.IsOpened and not locker.IsBusy and not locker.IsEmpty
                        end,
                        icon = 'fa-solid fa-vault',
                        label = 'Drill Lockbox',
                        item = locker.RequiredItems
                    },
                },
                distance = 1.5
        })
    end

    local trolleyModel = GetHashKey(Config.TrolleyModel)
    local tolerance = 0.1 -- Define a tolerance value

    -- for _, obj in ipairs(GetGamePool('CObject')) do
    --     if DoesEntityExist(obj) and GetEntityModel(obj) == trolleyModel then
    --         local entityPos = GetEntityCoords(obj)
    --         for i, trolley in ipairs(Config.Trollies) do
    --             local pos = trolley.Coords

    --             local xDiff = math.abs(entityPos.x - pos.x)
    --             local yDiff = math.abs(entityPos.y - pos.y)
    --             local zDiff = math.abs(entityPos.z - pos.z)

    --             if xDiff <= tolerance and yDiff <= tolerance and zDiff <= tolerance then
    --                 Config.Trollies[i].LocalObject = obj
    --                 exports['qb-target']:AddTargetEntity(obj, {
    --                     options = { 
    --                     {
    --                         num = 1,
    --                         type = "client", 
    --                         action = function(entity)
    --                             TriggerEvent('Winters:Client:Pacific:TakeMoneyFromTrolley', i)
    --                         end,
    --                         icon = 'fas fa-money-bill',
    --                         label = 'Take Money', 
    --                     }
    --                     },
    --                     distance = 2.5, -- This is the distance for you to be at for the target to turn blue, this is in GTA units and has to be a float value
    --                 })
    --             end
    --         end
    --     end
    -- end
end

Citizen.CreateThread(createTargets)

function RemoveItem(itemName, itemAmount)
    TriggerServerEvent('winters:Server:Pacific:RemoveItem', itemName, itemAmount)
end

function UpdateDoorState(doorId, setLocked)
    TriggerServerEvent('qb-doorlock:server:updateState', doorId, setLocked, false, false, true, false, false)
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

function BlockInventory(isBusy)
    LocalPlayer.state:set("inv_busy", isBusy, true)
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

function NotifyPoliceOnSuccess()
    Citizen.SetTimeout(Config.CalloutDelay, function() 
        local currentPos = Config.CalloutPosition
        local locationInfo = getStreetandZone(currentPos)
        local gender = GetPedGender()

        local params = {
            dispatchcodename = "pacificbankrobbery",
            dispatchCode = "10-90",
            firstStreet = locationInfo,
            gender = gender,
            priorty = 1,
            origin = {
                x = currentPos.x,
                y = currentPos.y,
                z = currentPos.z
            },
            dispatchMessage = "Pacific Bank Robbery In Progress",
            job = {"police"}
        }
        TriggerServerEvent('dispatch:server:notify', params)
    end)
end

function NotifyPoliceOnFail()
    Citizen.SetTimeout(Config.CalloutDelay, function() 
        local currentPos = Config.CalloutPosition
        local locationInfo = getStreetandZone(currentPos)
        local gender = GetPedGender()
        local params = {
            dispatchcodename = "susactivity",
            dispatchCode = "10-66",
            firstStreet = locationInfo,
            gender = gender,
            priorty = 2,
            origin = {
                x = currentPos.x,
                y = currentPos.y,
                z = currentPos.z
            },
            dispatchMessage = "Suspicious Activity",
            job = {"police"}
        }
        TriggerServerEvent('dispatch:server:notify', params)
    end)
end

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    UpdateDoorState(Config.Door1.LockId, true)
    UpdateDoorState(Config.Door2.LockId, true)
    UpdateDoorState(Config.Door4.LockId, true)


    
    local object = GetClosestObjectOfType(Config.Door3.ModelCoords["x"], Config.Door3.ModelCoords["y"], Config.Door3.ModelCoords["z"], 5.0, Config.Door3.Model, false, false, false)
    if object ~= 0 then
        SetEntityHeading(object, Config.Door3.ModelClosed)
    end
end)

AddEventHandler('onResourceStop', function (resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    for i, trolley in ipairs(Config.Trollies) do
        exports['qb-target']:RemoveTargetEntity(trolley.LocalObject, 'Take Money')
    end
end)