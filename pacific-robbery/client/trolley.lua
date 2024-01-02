local QBCore = exports["qb-core"]:GetCoreObject()

local function TakeMoneyFromTrolley(trolley)
    local player = PlayerPedId()
    local grabcash = 'anim@heists@ornate_bank@grab_cash'
    local bag = 'hei_p_m_bag_var22_arm_s' 

    RequestAnimDict(grabcash)
    while not HasAnimDictLoaded(grabcash) do
        Wait(100)
    end

    -- Load models
    RequestModel(bag)

    while not HasModelLoaded(bag) do
        Wait(100)
    end

    local plyrcrd, plyrrot = GetEntityCoords(player), GetEntityRotation(player)
    local cartcrd, cartrot = GetEntityCoords(trolley), GetEntityRotation(trolley)

    local obj_bag = CreateObject(bag, plyrcrd.x, plyrcrd.y, plyrcrd.z, true, true, false)

    local heist_start = NetworkCreateSynchronisedScene(
        cartcrd.x, cartcrd.y, cartcrd.z,
        cartrot.x, cartrot.y, cartrot.z, 
        2, false, false, 1065353216, 300, 1.3)
	NetworkAddPedToSynchronisedScene(player, heist_start, grabcash, 'intro', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(obj_bag, heist_start, grabcash, 'bag_intro', 4.0, -8.0, 1)
    SetPedComponentVariation(player, 5, 0, 0, 0)
	NetworkStartSynchronisedScene(heist_start)
    Citizen.Wait(1500)
    -- mid scene
    local heist_mid = NetworkCreateSynchronisedScene(
        cartcrd.x, cartcrd.y, cartcrd.z, 
        cartrot.x, cartrot.y, cartrot.z, 
        2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(player, heist_mid, grabcash, 'grab', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(obj_bag, heist_mid, grabcash, 'bag_grab', 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(trolley, heist_mid, grabcash, 'cart_cash_dissapear', 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(heist_mid)
    Citizen.Wait(37000)
    -- end scene
    local heist_end = NetworkCreateSynchronisedScene(
        cartcrd.x, cartcrd.y, cartcrd.z, 
        cartrot.x, cartrot.y, cartrot.z, 
        2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(player, heist_end, grabcash, 'exit', 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(obj_bag, heist_end, grabcash, 'bag_exit', 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(heist_end)

    if DoesEntityExist(obj_bag) then
        DeleteEntity(obj_bag)
    end
end


RegisterNetEvent('Winters:Client:Pacific:TakeMoneyFromTrolley', function(trolleyNo)
    local trolley = Config.Trollies[trolleyNo]
    QBCore.Functions.TriggerCallback('Winters:Server:Pacific:CheckTrolleyState', function(isBusy)
        if not isBusy then
            BlockInventory(true)
            TriggerServerEvent('Winters:Server:Pacific:StartTakeMoneyFromTrolley', trolleyNo)
            TakeMoneyFromTrolley(trolley.LocalObject)
            TriggerServerEvent('Winters:Server:Pacific:FinishTakeMoneyFromTrolley', trolleyNo)
            BlockInventory(false)
        else
            QBCore.Functions.Notify('This trolley is being emptied or has been emptied!', 'error', 5000)
        end
    end, trolleyNo)
end)