local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('flex-warehouse:server:hasitem', function(source, cb, item, amount)
    local src = source
    local player = QBCore.Functions.GetPlayer(source)
    if player.Functions.GetItemByName(item) and player.Functions.GetItemByName(item).amount >= amount then
        cb(true)
    else
        cb(false)
        return
    end
end)

RegisterNetEvent('flex-warehouse:server:removeItem', function(item, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove", amount)
    Player.Functions.RemoveItem(item, amount)
end)

RegisterNetEvent('flex-warehouse:server:giveItem', function(item, itemamount)
    print(item)
    print(itemamount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if item:lower() ~= 'money' then
        Player.Functions.AddItem(item, itemamount, false)
        TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], "add")
    else
        Player.Functions.AddMoney('cash', itemamount)
    end
end)

RegisterServerEvent('flex-traphouse:server:rob', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if math.random(1, 100) <= Config.successChance then
        local info = {
            label = Lang:t('info.pincode', {value = Config.pincode})
        }
        Player.Functions.AddItem("stickynote", 1, false, info)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["stickynote"], "add")
    else
        Player.Functions.AddMoney('cash', Config.cashReward)
    end
end)

QBCore.Functions.CreateCallback('flex-traphouse:server:getcode', function(source, cb)
    cb(Config.pincode)
end)

RegisterServerEvent('flex-traphouse:server:resetcode', function()
    local code = math.random(1000,9999)
    Config.pincode = code
    TriggerClientEvent('flex-traphouse:client:resetcode', -1, code)
    --print('New traphouse code:'..Config.pincode)
    TriggerEvent('qb-log:server:CreateLog', 'traphouse', 'Nieuwe trappenhuis code', 'red', 'Niewe code voor trappenhuis is: '..Config.pincode, false)
    sendToDiscord(16711680, "Trappenhuis", 'Traphuiscode: '..Config.pincode, "flex-traphouse")
end)

RegisterServerEvent('flex-traphouse:server:letin', function(who, k)
    local src = source
    if who then
        TriggerClientEvent('flex-traphouse:client:letinplayer', who, k)
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.notonline'), 'error')
        return
    end
end)

DiscordWebhook = ''
function sendToDiscord(color, name, message, footer)
    local embed = {
          {
              color = color,
              title = "**".. name .."**",
              description = message,
              footer = {
                  text = footer,
              },
          }
      }
  
    PerformHttpRequest(DiscordWebhook, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

AddEventHandler('onServerResourceStart', function(resName)
    if resName == GetCurrentResourceName() then
        if Config.newCodeOnStart then
            Config.pincode = math.random(1000,9999)
            --print('New traphouse code:'..Config.pincode)
            TriggerEvent('qb-log:server:CreateLog', 'traphouse', 'Nieuwe trappenhuis code', 'red', 'Niewe code voor trappenhuis is: '..Config.pincode, false)
            sendToDiscord(16711680, "Trappenhuis", 'Traphuiscode: '..Config.pincode, "flex-traphouse")
        end
    end
end)
