local QBCore = exports['qb-core']:GetCoreObject()
local isRolling = false

local function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

RegisterCommand('zarat', function()
    if isRolling then return end
    isRolling = true
    SetNuiFocus(true, true) 
    SendNUIMessage({ action = "openPlaceholder" })
end)

RegisterNUICallback('startRoll', function(_, cb)
    SetNuiFocus(false, false) 
    TriggerServerEvent('s1-dice:server:rollDice')
    cb('ok')
end)

RegisterNetEvent('s1-dice:client:startAnimation', function(sourceId, result, name)
    local myId = PlayerId()
    local myPed = PlayerPedId()
    local targetPlayer = GetPlayerFromServerId(sourceId)

    if targetPlayer ~= -1 then
        local targetPed = GetPlayerPed(targetPlayer)
        local dist = #(GetEntityCoords(myPed) - GetEntityCoords(targetPed))
        if sourceId == GetPlayerServerId(myId) or dist < 15.0 then

            if sourceId == GetPlayerServerId(myId) then

                local animDict = "anim@mp_player_intcelebrationmale@wank"
                local animName = "wank"
                
                loadAnimDict(animDict)
                TaskPlayAnim(myPed, animDict, animName, 8.0, 1.0, 2000, 49, 0, 0, 0, 0)
                RemoveAnimDict(animDict) 

                QBCore.Functions.Notify(result .. " attın!", "success", 3000)
            else
                QBCore.Functions.Notify(name .. " zar attı: " .. result, "primary", 3000)
            end

            SendNUIMessage({
                action = "rollAnimation",
                result = result
            })
        end
    end
end)

RegisterNUICallback('animFinished', function(_, cb)
    isRolling = false
    SetNuiFocus(false, false)
    cb('ok')
end)