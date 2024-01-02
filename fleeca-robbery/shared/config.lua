Config = {
    Debug = false,
    DebugPoly = false,
    MinimumPolice = 3,
    KeypadBlockedMsg = 'You are unable to do this at this moment!',
    LockerBlockedMsg = 'You are unable to do this at this moment!',
    CalloutDelay = 5000,
    Banks = {
        [1] = {
            Id = 'legion-square',
            Name = 'Legion',
            CalloutPosition = vector3(152.09, -1035.71, 29.34),
            Doors = {
                [1] = {
                    HackPanel = {
                        Coords = vector3(147.22, -1046.24, 29.38),
                        Height = 0.5,
                        Width = 0.2,
                        MinZ = 29.28,
                        MaxZ = 29.88,
                        Rotation = 341,
                        RequiredItems = {"thermite"},
                        RemoveItems = {"thermite"},
                        RemoveItemsOnHackSuccess = {''},
                        HackType = 0, -- 0 = PS-UI Thermite, 1 = mhacking
                        HackTime = 30,
                        Disabled = false, -- Used by script only
                    },
                    DoorModel = 'v_ilev_gb_vauldr',
                    DoorModelCoords = vector3(148.03, -1044.36, 29.51),
                    LockId = '',
                    ClosedRotation = 250.0,
                    OpenRotation = 160.0,
                    UseThermite = true,
                    ThermitePosition = vector3(147.56945800781, -1045.4387207031, 29.527824401855),
                    ThermiteRotation = vector3(-174.99989318848, -86.000259399414, 109.99970245361),
                    Dispatch = {
                        NotifyOnSuccess = true,
                        SuccessCodeName = 'bankrobbery',
                        SuccessCode = '10-90',
                        SuccessPriorty = 1,
                        SuccessMessage = 'Bank Robbery In Progress',
                        NotifyOnFail = true,
                        FailCodeName = 'bankrobbery',
                        FailCode = '10-90',
                        FailPriorty = 1,
                        FailMessage = 'Bank Robbery In Progress',
                    }
                },
                [2] = {
                    HackPanel = {
                        Coords = vector3(148.51, -1046.63, 29.35),
                        Height = 0.5,
                        Width = 0.2,
                        MinZ = 29.25,
                        MaxZ = 29.9,
                        Rotation = 250,
                        RequiredItems = {"thermite"},
                        RemoveItems = {"thermite"},
                        RemoveItemsOnHackSuccess = {''},
                        HackType = 1, -- 0 = PS-UI Thermite, 1 = mhacking
                        HackTime = 30,
                        Disabled = false, -- Used by script only
                    },
                    DoorModel = '',
                    DoorModelCoords = vector3(0,0,0),
                    LockId = 'legion-fleeca-internal-vault',
                    ClosedRotation = 0,
                    OpenRotation = 0,
                    UseThermite = true,
                    ThermitePosition = vector3(148.94714355469, -1047.0777587891, 29.696281433105),
                    ThermiteRotation = vector3(-90.000038146973, 43.31031036377, 121.00000762939),
                    Dispatch = {
                        NotifyOnSuccess = false,
                        NotifyOnFail = false
                    }
                }
            },
            Lockers = {
                [1] = {
                    Coords = vector3(147.56, -1050.93, 29.35),
                    Height = 0.2,
                    Width = 0.4,
                    MinZ = 29.7,
                    MaxZ = 29.9,
                    Rotation = 341,
                    IsBusy = false,
                    IsOpened = false,
                    IsEmpty = false,
                    RequiredItems = {"drill"},
                    RewardItem = 'goldbar',
                    RewardAmount = 1
                }
            }
        }
    }
}