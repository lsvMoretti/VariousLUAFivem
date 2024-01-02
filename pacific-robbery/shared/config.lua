Config = {

    Debug = false,
    DebugPoly = false,
    MinimumPolice = 5,
    PlantSuccessMessage = 'You have planted the thermite',
    PlantFailMessage = 'You have failed planting the thermite',
    CalloutPosition = vector3(228.81, 212.37, 105.51),
    CalloutDelay = 60000, --MS
    Door1 = {
        LockId = 'pacific-door1',
    },
    Door2 = {
        Time = 10,
        Gridsize = 5,
        IncorrectBlocks = 5,
        Model = 'hei_v_ilev_bk_gate2_pris',
        LockId = 'pacific-door2',
        RequiredItems = {"security_card_01","thermite"},
        RemoveItems = {"thermite"},
        RemoveItemsOnHackSuccess = {'security_card_01'},
        ThermitePosition = vector3(261.76583862305,  221.39677429199, 106.38439941406),
        ThermiteRotation = vector3(-180.0, -85.000007629395, 93.000152587891)
    },
    Door3 = {
        HackTimeLimit = 20,
        RequiredItems = {"trojan_usb"},
        RemoveItems = {},
        RemoveItemsOnHackSuccess = {'trojan_usb'},
        Model = 961976194,
        ModelCoords = vector3(253.25, 228.44, 101.68),
        ModelClosed = 160.00001,
        ModelOpened = 70.00001,
    },
    Door4 = {
        Time = 10,
        Gridsize = 5,
        IncorrectBlocks = 5,
        Model = 'hei_v_ilev_bk_safegate_pris',
        LockId = 'pacific-door4',
        RequiredItems = {"thermite"},
        RemoveItems = {"thermite"},
        RemoveItemsOnHackSuccess = {},
        ThermitePosition = vector3(253.00714111328, 220.65846252441, 101.78385925293),
        ThermiteRotation = vector3(-90.609527587891, 17.99998664856, 1.0100014209747)
    },
    Lockers = {
        [1] = {
            Coords = vector3(260.0, 218.25, 101.68),
            Height = 0.2,
            Width = 0.4,
            MinZ = 101.98,
            MaxZ = 102.18,
            Rotation = 342,
            IsBusy = false,
            IsOpened = false,
            IsEmpty = false,
            RequiredItems = {"drill"},
            RewardItem = 'goldbar',
            RewardAmount = 1
        }
    },
    TrolleyModel = 'hei_prop_hei_cash_trolly_01',
    EmptyTrolleyModel = 'hei_prop_hei_cash_trolly_03',
    Trollies = {
        [1] = {
            Coords = vec3(259.68, 216.18, 101.18),
            ServerObject = '', -- Leave blank
            LocalObject = '', -- Leave blank
            IsBusy = false,
            RewardItem = 'markedbills',
            RewardAmount = 1,
            RewardInfo = {
                worth = math.random(2300, 3200)
            }
        },
        [2] = {
            Coords = vec3(256.02, 217.08, 101.18),
            ServerObject = '', -- Leave blank
            LocalObject = '', -- Leave blank
            IsBusy = false,
            RewardItem = 'markedbills',
            RewardAmount = 1,
            RewardInfo = {
                worth = math.random(2300, 3200)
            }
        },
    }
};