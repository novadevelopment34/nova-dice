local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('s1-dice:server:rollDice', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    local result = math.random(1, 6)
    local name = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
    TriggerClientEvent('s1-dice:client:startAnimation', -1, src, result, name)
end)