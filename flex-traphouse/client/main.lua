local QBCore = exports['qb-core']:GetCoreObject()
local isInsideTrap = false
local shell, shellloc = nil, nil
local props, furnance, targets = {}, {}, {}
local canUseFornacne = true
local currenttrap = 1
local sleep = 1

--ROBBING
local CanRob = true
local IsRobbingNPC = false

function loadModel(model)
    RequestModel(model)
    local requests = 1
    while not HasModelLoaded(model) and requests < 8 do
        Citizen.Wait(0)
        requests = requests + 1
    end
end

function loadAnimDict(dict)
    if not HasAnimDictLoaded(dict) then
		RequestAnimDict(dict)
		while not HasAnimDictLoaded(dict) do
			Citizen.Wait(1)
		end
	end
end

function doorAnim()
    local ped = PlayerPedId()
    loadAnimDict("anim@heists@keycard@")
    TaskPlayAnim(ped, "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
    Wait(400)
    ClearPedTasks(ped)
end

function teleport(x, y, z, h)
    CreateThread(function()
        Wait(200)
        local ped = PlayerPedId()
        SetEntityCoords(ped, x, y, z, 0, 0, 0, false)
        SetEntityHeading(ped, h)
        PlaceObjectOnGroundProperly(ped)
        Wait(100)
        DoScreenFadeIn(1000)
    end)
end

function enterTrapHouse()
    if not isInsideTrap then
        doorAnim()
        DoScreenFadeOut(500)
        shellloc = vec3(Config.traphouselocs[currenttrap].enter.x, Config.traphouselocs[currenttrap].enter.y, Config.traphouselocs[currenttrap].enter.z-15)
        while not IsScreenFadedOut() do
            Wait(10)
        end
        loadModel('shell_warehouse3')
        shell = CreateObject('shell_warehouse3', shellloc.x, shellloc.y, shellloc.z, false, false, false)
        FreezeEntityPosition(shell, true)
        isInsideTrap = true
        registerZones()
        loadprops()
        teleport(shellloc.x+1, shellloc.y-1.7, shellloc.z+1, 0.0)
    end
end

function entercode()
    if Config.traphouselocs[currenttrap].needpin then
        SendNUIMessage({
            action = "open"
        })
        SetNuiFocus(true, true)
    else
        enterTrapHouse()
    end
end

function loadprops()
    loadModel('gr_prop_gr_bench_03b')
    loadModel('v_res_tre_sofa_mess_c')
    loadModel('v_res_j_coffeetable')
    loadModel('prop_ff_sink_02')
    loadModel('v_med_cor_largecupboard')
    if math.random(1,100) <= 1 then
        loadModel('ch_prop_nmc_furnance')
        furnance[#furnance + 1] = CreateObjectNoOffset('ch_prop_nmc_furnance', shellloc.x-2.6, shellloc.y-5, shellloc.z+0.3, 1, 0, 1)
        SetEntityRotation(furnance[1], 0.0, 0.0, -90.0, false, false)
        furnance[#furnance + 1] = CreateObjectNoOffset('ch_prop_nmc_furnance', shellloc.x-2.6, shellloc.y-4, shellloc.z+0.3, 1, 0, 1)
        SetEntityRotation(furnance[2], 0.0, 0.0, -90.0, false, false)
        furnance[#furnance + 1] = CreateObjectNoOffset('ch_prop_nmc_furnance', shellloc.x-2.6, shellloc.y-3, shellloc.z+0.3, 1, 0, 1)
        SetEntityRotation(furnance[3], 0.0, 0.0, -90.0, false, false)
    else
        loadModel('prop_cooker_03')
        furnance[#furnance + 1] = CreateObjectNoOffset('prop_cooker_03', shellloc.x-2.6, shellloc.y-4.3, shellloc.z, 1, 0, 1)
        SetEntityRotation(furnance[1], 0.0, 0.0, 90.0, false, false)
        furnance[#furnance + 1] = CreateObjectNoOffset('prop_cooker_03', shellloc.x-2.6, shellloc.y-2.5, shellloc.z, 1, 0, 1)
        SetEntityRotation(furnance[2], 0.0, 0.0, 90.0, false, false)
    end
    props[#props + 1] = CreateObjectNoOffset('gr_prop_gr_bench_03b', shellloc.x+2.1, shellloc.y+2.2, shellloc.z+0.16, 1, 0, 1)
    SetEntityRotation(props[1], 0.0, 0.0, -90.0, false, false)
    props[#props + 1] = CreateObjectNoOffset('v_res_tre_sofa_mess_c', shellloc.x-2.6, shellloc.y+3.4, shellloc.z, 1, 0, 1)
    SetEntityRotation(props[2], 0.0, 0.0, 90.0, false, false)
    props[#props + 1] = CreateObjectNoOffset('v_res_tre_sofa_mess_c', shellloc.x-1, shellloc.y+5.2, shellloc.z, 1, 0, 1)
    props[#props + 1] = CreateObjectNoOffset('v_res_j_coffeetable', shellloc.x-1, shellloc.y+3.5, shellloc.z, 1, 0, 1)
    SetEntityRotation(props[4], 0.0, 0.0, 90.0, false, false)
    props[#props + 1] = CreateObjectNoOffset('v_res_tt_fridge', shellloc.x+2.1, shellloc.y-3, shellloc.z+1, 1, 0, 1)
    SetEntityRotation(props[5], 0.0, 0.0, -90.0, false, false)
    props[#props + 1] = CreateObjectNoOffset('prop_ff_sink_02', shellloc.x+2.1, shellloc.y-4.5, shellloc.z, 1, 0, 1)
    SetEntityRotation(props[6], 0.0, 0.0, -90.0, false, false)
    props[#props + 1] = CreateObjectNoOffset('v_med_cor_largecupboard', shellloc.x-3.1, shellloc.y, shellloc.z+1.4, 1, 0, 1)
    SetEntityRotation(props[7], 0.0, 0.0, 90.0, false, false)
    for k, v in pairs(furnance) do
        local proppos = GetEntityCoords(v)
        local prophead = GetEntityHeading(v)
        targets['trapfurnance'..k] = exports['qb-target']:AddBoxZone("trapfurnance"..k, vec3(proppos.x, proppos.y, proppos.z), 0.9, 1.5, {
        name = "trapfurnance"..k, heading = prophead, debugPoly = Config.debug, minZ = proppos.z-0.4, maxZ = proppos.z+1.2,
        }, { options = {{ type = "client", event = "flex-traphouse:client:furnacne", icon = "fa fa-fire", label = Lang:t('info.furnance'),canInteract = function() return canUseFornacne end,}},
        distance = 1.5})
    end
    targets['trapcraft'] = exports['qb-target']:AddBoxZone("trapcraft", vec3(shellloc.x+2.1, shellloc.y+2.2, shellloc.z+0.16), 0.9, 3.6, {
    name = "trapcraft", heading = 90.0, debugPoly = Config.debug, minZ = shellloc.z-0.2, maxZ = shellloc.z+1.4,
    }, { options = {{ type = "client", event = "flex-traphouse:client:craft", icon = "fa fa-wrench", label = Lang:t('info.crafting'),}},
    distance = 1.5})
    targets['trapstorage'] = exports['qb-target']:AddBoxZone("trapstorage", vec3(shellloc.x-2.7, shellloc.y, shellloc.z+1.4), 0.9, 2.6, {
        name = "trapstorage", heading = 90.0, debugPoly = Config.debug, minZ = shellloc.z-0.2, maxZ = shellloc.z+2.2,
        }, { options = {
            { type = "client", event = "flex-traphouse:client:clothing", icon = "fas fa-tshirt", label = Lang:t('info.chanceclothing')},
            { type = "client", event = "flex-traphouse:client:stash", icon = "fas fa-box-open", label = Lang:t('info.stash')}},
        distance = 1.5})
    for k, v in pairs(props) do
        FreezeEntityPosition(v, true)
    end
    for k, v in pairs(furnance) do
        FreezeEntityPosition(v, true)
    end
end

CreateThread(function()
    while true do
        Citizen.Wait(sleep)
        if not isInsideTrap then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            for k, v in pairs(Config.traphouselocs) do
                local enter = #(v.enter - pos)
                if enter < 3 then
                    sleep = 1
                    QBCore.Functions.DrawText3D(v.enter.x, v.enter.y, v.enter.z, '[~o~E~w~] '..Lang:t("info.enter"))
                    if enter < 2 then
                        if IsControlJustPressed(0, 38) then
                            currenttrap = k
                            entercode()
                        end
                    end
                -- else
                --     sleep = 1000
                end
            end
        end
    end
end)

function registerZones()
    local leavepos = vec3(shellloc.x+2.5, shellloc.y-1.7, shellloc.z)
    CreateThread(function()
        while true do
            Citizen.Wait(1)
            if isInsideTrap then
                local ped = PlayerPedId()
                local pos = GetEntityCoords(ped)
                local leavedist = #(leavepos - pos)
                if leavedist < 3 then
                    QBCore.Functions.DrawText3D(leavepos.x, leavepos.y, leavepos.z+1, '[~o~E~w~] '..Lang:t("info.leave"))
                    if leavedist < 2 then
                        if IsControlJustPressed(0, 38) then
                            TriggerEvent('flex-traphouse:client:leavemenu')
                        end
                    end
                end
            else
                break
            end
        end
    end)
end

RegisterNetEvent('flex-traphouse:client:furnacne', function()
    local columns = {
        {
            header = Lang:t('info.furnance'),
            isMenuHeader = true,
        },
    }
    for k, v in pairs(Config.smeltItems) do
        local item = {}
        item.header = "<img src=nui://"..Config.inventory..QBCore.Shared.Items[v.input.item].image.." width=35px style='margin-right: 10px'> " .. QBCore.Shared.Items[v.input.item].label
        local text = Lang:t('info.input')..": " .. v.input.item .. " > " .. v.input.amount .. "x".. "<br>"..Lang:t('info.output')..": " .. v.output.item .. " > " .. v.output.amount .. "x"
        if v.output.item:lower() == 'cash' then
            text = Lang:t('info.input')..": " .. v.input.item .. " > " .. v.input.amount .. "x".. "<br>"..Lang:t('info.output')..": €" .. v.output.amount
        end
        item.text = text
        item.params = {
            event = 'flex-traphouse:client:smeltamount',
            args = {
                id = k,
                item = v.input.item,
                itemamount = v.input.amount,
                time = v.smelttime,
            }
        }
        table.insert(columns, item)
    end

    exports['qb-menu']:openMenu(columns)
end)

function smelt(id, item, itemamount, amount, time)
    canUseFornacne = false
    local ped = PlayerPedId()
    QBCore.Functions.Progressbar('smelt_item', QBCore.Shared.Items[item].label..' '..Lang:t("info.smelting"), 3000, false, false, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "mini@repair",
        anim = "fixing_a_ped",
        }, {}, {}, function() -- Success
        QBCore.Functions.Notify(Lang:t("success.smelted",{value = QBCore.Shared.Items[item].label, value2 = time}), 'success')
        TriggerServerEvent('flex-warehouse:server:removeItem', item, amount)
        ClearPedTasks(ped)
        SetTimeout(time * 1000, function()
            QBCore.Functions.Notify(Lang:t("success.donesmelt"), 'success')
            TriggerServerEvent('flex-warehouse:server:giveItem', Config.smeltItems[id].output.item, Config.smeltItems[id].output.amount*amount)
            canUseFornacne = true
        end)
    end, function() -- Cancel
        ClearPedTasks(ped)
        QBCore.Functions.Notify(Lang:t("error.stoppedsmelt"), 'error', 5000)
    end)
end

RegisterNetEvent('flex-traphouse:client:smeltamount', function(data)
    local input = exports['qb-input']:ShowInput({
        header = "Hoeveel wil je er smelten?",
        submitText = "Bevestig",
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'amount',
                text = 'Hoeveelheid'
            }
        }
    })
    if input then
        TriggerEvent('flex-traphouse:client:smelt', data.id, data.item, data.itemamount, input.amount, data.time)
    end
end)

RegisterNetEvent('flex-traphouse:client:smelt', function(id, item, itemamount, amount, time)
    QBCore.Functions.TriggerCallback("flex-warehouse:server:hasitem", function(hasMaterials)
        if (hasMaterials) then
            smelt(id, item, itemamount, amount, time)
        else
            QBCore.Functions.Notify(Lang:t("error.donthaveitem"), "error", 5000)
            return
        end
    end, item, itemamount*amount)
end)

RegisterNetEvent('flex-traphouse:client:craft', function()
    craft()
end)

RegisterNetEvent('flex-traphouse:client:clothing', function()
    outfitmenu()
end)

RegisterNetEvent('flex-traphouse:client:stash', function()
    TriggerServerEvent("inventory:server:OpenInventory", "stash", Config.stash.name, {
        maxweight = Config.stash.weight,
        slots = Config.stash.slots,
    })
end)

RegisterNetEvent('flex-traphouse:client:leavemenu', function()
    local leavemenu = {}
    leavemenu[#leavemenu+1] = {
        header = Lang:t('info.leave'),
        txt = "",
        params = {
            event = "flex-traphouse:client:leave",
            args = {}
        }
    }
    leavemenu[#leavemenu+1] = {
        header = Lang:t('info.letintrap'),
        txt = "",
        params = {
            event = "flex-traphouse:client:letin",
            args = {}
        }
    }
    leavemenu[#leavemenu+1] = {
        header = Lang:t('info.close'),
        txt = "",
        params = {
            event = "qb-menu:closeMenu",
            args = {}
        }
    }
    exports['qb-menu']:openMenu(leavemenu)
end)

RegisterNetEvent('flex-traphouse:client:leave', function()
    if isInsideTrap then
        doorAnim()
        DoScreenFadeOut(500)
        while not IsScreenFadedOut() do
            Wait(10)
        end
        if DoesEntityExist(shell) then
            DeleteEntity(shell)
        end
        for k, v in pairs(props) do
            if DoesEntityExist(props[k]) then
                DeleteEntity(props[k])
            end
        end
        for k, v in pairs(furnance) do
            if DoesEntityExist(furnance[k]) then
                DeleteEntity(furnance[k])
            end
        end
        for k, v in pairs(targets) do
            exports['qb-target']:RemoveZone(k)
        end
        teleport(shellloc.x, shellloc.y, shellloc.z+15, 0.0)
        isInsideTrap = false
    end
end)

--ROBBING
local function RobTimeout(timeout)
    SetTimeout(timeout, function()
        CanRob = true
    end)
end

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        for k, v in pairs(Config.traphouselocs) do
            local dist = #(pos - v.enter)
            if dist < Config.robDistance then
                local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId(-1))
                if targetPed ~= 0 and not IsPedAPlayer(targetPed) then
                    if aiming then
                        if validWeapon() then
                            local pcoords = GetEntityCoords(targetPed)
                            local peddist = #(pos - pcoords)
                            local InDistance = false
                            if peddist < 4 then
                                InDistance = true
                                if not IsRobbingNPC and CanRob then
                                    if IsPedInAnyVehicle(targetPed) then
                                        TaskLeaveVehicle(targetPed, GetVehiclePedIsIn(targetPed), 1)
                                    end
                                    Wait(500)
                                    InDistance = true

                                    local dict = 'random@mugging3'
                                    RequestAnimDict(dict)
                                    while not HasAnimDictLoaded(dict) do
                                        Wait(10)
                                    end

                                    SetEveryoneIgnorePlayer(PlayerId(), true)
                                    TaskStandStill(targetPed, Config.robTime * 1000)
                                    FreezeEntityPosition(targetPed, true)
                                    SetBlockingOfNonTemporaryEvents(targetPed, true)
                                    TaskPlayAnim(targetPed, dict, 'handsup_standing_base', 2.0, -2, 15.0, 1, 0, 0, 0, 0)
                                    for _ = 1, Config.robTime / 2, 1 do
                                        PlayPedAmbientSpeechNative(targetPed, "GUN_BEG", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR")
                                        Wait(2000)
                                    end
                                    FreezeEntityPosition(targetPed, true)
                                    IsRobbingNPC = true
                                    SetTimeout(Config.robTime, function()
                                        IsRobbingNPC = false
                                        RobTimeout(Config.RobTimeOut)
                                        if not IsEntityDead(targetPed) then
                                            if CanRob then
                                                if InDistance then
                                                    SetEveryoneIgnorePlayer(PlayerId(), false)
                                                    SetBlockingOfNonTemporaryEvents(targetPed, false)
                                                    FreezeEntityPosition(targetPed, false)
                                                    ClearPedTasks(targetPed)
                                                    AddShockingEventAtPosition(99, GetEntityCoords(targetPed), 0.5)
                                                    TriggerServerEvent('flex-traphouse:server:rob', ClosestTraphouse)
                                                    CanRob = false
                                                end
                                            end
                                        end
                                    end)
                                end
                            else
                                if InDistance then
                                    InDistance = false
                                end
                            end
                        end
                    end
                -- else
                --     Wait(1000)
                end
            end
        end
        Wait(3)
    end
end)

-- NUI

RegisterNUICallback('PinpadClose', function(_, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('ErrorMessage', function(data, cb)
    QBCore.Functions.Notify(data.message, 'error')
    cb('ok')
end)

RegisterNUICallback('EnterPincode', function(d, cb)
    QBCore.Functions.TriggerCallback('flex-traphouse:server:getcode', function(code)
        if tonumber(d.pin) == code then
            enterTrapHouse()
            TriggerServerEvent('flex-traphouse:server:resetcode')
        else
            QBCore.Functions.Notify(Lang:t("error.incorrect_code"), 'error')
        end
        cb('ok')
    end)
end)

RegisterNetEvent('flex-traphouse:client:letin', function()
    local who = exports['qb-input']:ShowInput({
        header = Lang:t('info.letintrap'),
        submitText = Lang:t('info.confirmletin'),
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'id',
                text = Lang:t('info.wholetin')
            }
        }
    })
    if who then
        TriggerServerEvent('flex-traphouse:server:letin', who.id, currenttrap)
    end
end)

RegisterNetEvent('flex-traphouse:client:letinplayer', function(k)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local enter = #(Config.traphouselocs[k].enter - pos)
    if enter < 5 then
        enterTrapHouse()
    end
end)

function validWeapon()
    local ped = PlayerPedId()
    local pedWeapon = GetSelectedPedWeapon(ped)

    for k, v in pairs(Config.validRobWeapons) do
        if pedWeapon == GetHashKey(v) then
            return true
        end
    end
    return false
end

RegisterNetEvent('flex-traphouse:client:resetcode', function(code)
    Config.pincode = code
end)