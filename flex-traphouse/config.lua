Config = {}
Config.debug = false
Config.inventory = 'qb-inventory/html/images/' --Path of your inventory images

--TRAPHOUSE
Config.traphouselocs = {
    [1] = {
        enter = vector3(1017.62, -2529.39, 28.3),
        needpin = true,
    },
    [2] = {
        enter = vector3(1105.06, -3099.5, -39.0),
        needpin = false,
    },
}

Config.pincode = 1334
Config.newCodeOnStart = true

Config.smeltItems = {
    [1] = {
        smelttime = 5, --seconds
        input = {
            item = 'goldbar',
            amount = 1 
        },
        output = {
            item = 'money', -- if item = money then amount is cash reward
            amount = 4345
        },
    },
    [2] = {
        smelttime = 5, --seconds
        input = {
            item = '10kgoldchain',
            amount = 1 
        },
        output = {
            item = 'money', -- if item = money then amount is cash reward
            amount = 745
        },
    },
}

Config.stash = {
    name = 'Trappenhuis',
    weight = 250000,
    slots = 30,
}

function craft()
    TriggerEvent('QBCore:Notify', 'Hmmm, deze werkbank lijkt nog kapot te zijn..', 'error', 4000)
    TriggerEvent('QBCore:Notify', 'Kom later terug!', 'info', 4000)
end

function outfitmenu()
    TriggerEvent('qb-clothing:client:openOutfitMenu')
end

--ROBBING
Config.robTime = 5
Config.robDistance = 200
Config.successChance = 13 --Has to be lower than this
Config.cashReward = math.random(10, 50)
Config.RobTimeOut = math.random(15000, 40000)
Config.validRobWeapons = {
    "weapon_pistol",
    "weapon_snspistol",
    "weapon_snspistol_mk2",
    "weapon_pistol_mk2",
    "weapon_brick",
}