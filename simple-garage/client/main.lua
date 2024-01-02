local QBCore = exports["qb-core"]:GetCoreObject()
local PlayerJob = {}
local NpcIds = {}
local vehicle

CreateThread(function()
    for _, spawn in pairs(Config.Spawns) do
        RequestModel(GetHashKey(spawn.Model))
        while not HasModelLoaded(GetHashKey(spawn.Model)) do
            Wait(1)
        end

        local npc = CreatePed(5, GetHashKey(spawn.Model), spawn.PosX, spawn.PosY, spawn.PosZ, spawn.Heading, false, false)
        print('Creating NPC')
        FreezeEntityPosition(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
        SetEntityInvincible(npc, true)
        table.insert(NpcIds, npc)
        exports["qb-target"]:AddTargetEntity(
            npc,
            {
                options = {
                    {
                        num = 1,
                        type = "client",
                        action = function(entity)
                            TriggerEvent('winters:garage:showmenu', spawn)
                        end,
                        icon = "fas fa-car",
                        label = "Get Vehicle",
                        job = spawn.Job,
                        canInteract = function(entity, distance, data)
                            if(vehicle == nil) then
                                return true
                            end
                            return false
                        end,
                    },
                    {
                        num = 2,
                        type = "client",
                        event = "winters:garage:despawnvehicle",
                        icon = "fas fa-car",
                        label = "Despawn Vehicle",
                        job = spawn.Job,
                        canInteract = function(entity, distance, data)
                            if(vehicle == nil) then
                                return false
                            end
                            return true
                        end,
                    }
                },
                distance = 2.5,
            })
    end
end)

RegisterNetEvent('winters:garage:despawnvehicle', function ()
    
    if(vehicle ~= nil) then
        QBCore.Functions.DeleteVehicle(vehicle)
        QBCore.Functions.Notify("You returned the vehicle.", "success")
        vehicle = nil
    end

end)

RegisterNetEvent('winters:garage:showmenu')
AddEventHandler('winters:garage:showmenu', function(data)
    local spawnData = data
    local menuItems = {
        {
            header = "Vehicle Garage",
            txt = "Select a vehicle to spawn",
            isMenuHeader = true
        }
    }

    for _, vehicle in ipairs(Config.Vehicles) do
        if(vehicle.Job == spawnData.Job) then
            table.insert(menuItems, {
                header = vehicle.Name,
                txt = vehicle.Description,
                params = {
                    event = "winters:garage:spawnvehicle",
                    args = {
                        model = vehicle.Model,
                        texture = vehicle.Texture,
                        spawnData = spawnData
                    }
                }
            })
        end
    end

    exports['qb-menu']:openMenu(menuItems)
end)

RegisterNetEvent('winters:garage:spawnvehicle', function(data)
    local vehModel = data.model
    local texture = data.texture
    local spawnData = data.spawnData
    if not texture then
        texture = 0
    end

    QBCore.Functions.SpawnVehicle(vehModel, function(veh)
        local rndNum = math.random(10, 100)
        SetVehicleNumberPlateText(veh, '' .. rndNum)
        SetEntityHeading(veh, spawnData.VehicleRot)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
        --SetVehicleEngineOn(veh, true, true)
        SetVehicleLivery(veh, texture)
        SetVehicleFuelLevel(veh, 100)
        QBCore.Functions.Notify("You've taken out a vehicle", "success")
        DecorSetFloat(veh, "pd_vehicle", 1)
        vehicle = veh 
    end, vector3(spawnData.VehicleX, spawnData.VehicleY, spawnData.VehicleZ), true)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    
    for _, npcId in pairs(NpcIds) do
        if(DoesEntityExist(npcId)) then
            DeleteEntity(npcId)
        end
    end

    NpcIds = {}
  end)
