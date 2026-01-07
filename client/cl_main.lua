-- =================================================================
-- OPTIMIZACIÓN: CACHÉ DE NATIVAS (Esto mejora el rendimiento drásticamente)
-- =================================================================

local isMenuOpen = false
local spawnedShowroomVehicles = {}
local nearbyVehicles = {}
local isHudActive = false

-- =================================================================
-- SECCIÓN 1: FUNCIONES AUXILIARES
-- =================================================================

local function GetPlayerCoords()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    return {
        x = pos.x,
        y = pos.y,
        z = pos.z,
        h = GetEntityHeading(ped)
    }
end

-- =================================================================
-- SECCIÓN 2: LÓGICA DEL MENÚ NUI
-- =================================================================

local function SetMenuState(state)
    if isMenuOpen == state then
        return
    end
    isMenuOpen = state

    SendNUIMessage({
        action = 'setVisible',
        status = state
    })

    if state then
        SendNUIMessage({
            action = 'loadTranslations',
            translations = Config.Locales[Config.Language],
            itemsPerPage = Config.ItemsPerPage
        })
    end
    SetNuiFocus(state, state)
end

-- =================================================================
-- SECCIÓN 3: GESTIÓN DE ENTIDADES
-- =================================================================

local function SpawnShowroomVehicle(vehicleData)
    if not vehicleData.spawn_x or not vehicleData.spawn_y then
        return
    end

    local modelName = vehicleData.model
    local modelHash = GetHashKey(modelName)

    if not IsModelInCdimage(modelHash) then
        return
    end

    RequestModel(modelHash)
    local timeout = 0
    while not HasModelLoaded(modelHash) and timeout < 1500 do
        Wait(10)
        timeout = timeout + 10
    end

    if not HasModelLoaded(modelHash) then
        return
    end

    local x, y, z, h = tonumber(vehicleData.spawn_x), tonumber(vehicleData.spawn_y), tonumber(vehicleData.spawn_z),
        tonumber(vehicleData.spawn_h)
    local vehicle = CreateVehicle(modelHash, x, y, z, h, false, false)

    SetEntityAsMissionEntity(vehicle, true, true)
    SetEntityInvincible(vehicle, true)
    SetVehicleEngineOn(vehicle, false, true, true)
    SetVehicleDoorsLocked(vehicle, 4)
    SetVehicleTyresCanBurst(vehicle, false)
    SetVehicleUndriveable(vehicle, true)
    FreezeEntityPosition(vehicle, true)
    SetModelAsNoLongerNeeded(modelHash)

    spawnedShowroomVehicles[vehicleData.id] = {
        entity = vehicle,
        info = vehicleData
    }
end

local function ClearShowroomVehicles()
    for id, data in pairs(spawnedShowroomVehicles) do
        if DoesEntityExist(data.entity) then
            DeleteEntity(data.entity)
        end
    end
    spawnedShowroomVehicles = {}
    nearbyVehicles = {}
end

local function DeleteSpecificShowroomVehicle(vehicleId)
    local data = spawnedShowroomVehicles[vehicleId]
    if data and data.entity and DoesEntityExist(data.entity) then
        DeleteEntity(data.entity)
    end
    spawnedShowroomVehicles[vehicleId] = nil
end

-- =================================================================
-- SECCIÓN 4: INICIALIZACIÓN
-- =================================================================

local function InitializeClientLoad()
    TriggerServerEvent('DP-PdmEscaparates:server:getVehicles')
    TriggerServerEvent('DP-PdmEscaparates:server:getSpawns')
end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        CreateThread(function()
            Wait(1000)
            InitializeClientLoad()
        end)
    end
end)

AddEventHandler('onResourceStop', ClearShowroomVehicles)

-- =================================================================
-- SECCIÓN 5: EVENTOS
-- =================================================================

RegisterNetEvent('DP-PdmEscaparates:client:openMenu', function()
    SetMenuState(true)
end)

RegisterNetEvent('DP-PdmEscaparates:client:sendVehicles', function(vehicleList)
    ClearShowroomVehicles()
    local nuiList = {}

    for _, vehicleData in pairs(vehicleList) do
        SpawnShowroomVehicle(vehicleData)
        table.insert(nuiList, {
            id = vehicleData.id,
            model = vehicleData.model,
            display_name = vehicleData.display_name,
            setter_name = vehicleData.setter_name,
            price = vehicleData.price,
            date_added = tostring(vehicleData.date_added),
            spawn_name = vehicleData.spawn_name,
            spawn_x = vehicleData.spawn_x,
            spawn_y = vehicleData.spawn_y,
            spawn_z = vehicleData.spawn_z
        })
    end

    SendNUIMessage({
        action = 'sendVehicles',
        vehicleList = nuiList
    })
end)

RegisterNetEvent('DP-PdmEscaparates:client:sendSpawns', function(spawnList)
    SendNUIMessage({
        action = 'sendSpawns',
        spawnList = spawnList
    })
end)

RegisterNetEvent('DP-PdmEscaparates:client:deleteVehicleEntity', function(vehicleId)
    DeleteSpecificShowroomVehicle(vehicleId)
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    InitializeClientLoad()
end)

-- =================================================================
-- SECCIÓN 6: NUI CALLBACKS
-- =================================================================

RegisterNUICallback('closeMenu', function(data, cb)
    SetMenuState(false);
    cb('ok')
end)
RegisterNUICallback('requestSpawnCoords', function(data, cb)
    SendNUIMessage({
        action = 'updateCoords',
        coords = GetPlayerCoords()
    });
    cb('ok')
end)
RegisterNUICallback('notifyClient', function(data, cb)
    local msg = _L(data.messageKey or 'unknown_error')
    TriggerEvent('QBCore:Notify', msg, data.type or 'error', 5000)
    cb('ok')
end)
RegisterNUICallback('setSpawnPosition', function(data, cb)
    TriggerServerEvent('DP-PdmEscaparates:server:setSpawn', data);
    cb('ok')
end)
RegisterNUICallback('assignVehicle', function(data, cb)
    TriggerServerEvent('DP-PdmEscaparates:server:assignVehicle', data);
    cb('ok')
end)
RegisterNUICallback('deleteVehicle', function(data, cb)
    TriggerServerEvent('DP-PdmEscaparates:server:deleteVehicle', data.id);
    cb('ok')
end)
RegisterNUICallback('editVehicle', function(data, cb)
    TriggerServerEvent('DP-PdmEscaparates:server:editVehicle', data);
    cb('ok')
end)

-- =================================================================
-- SECCIÓN 7: HILOS DE EJECUCIÓN OPTIMIZADOS
-- =================================================================

CreateThread(function()
    while true do
        Wait(0)
        if isMenuOpen and IsControlJustReleased(0, 200) then
            SetMenuState(false)
        end
    end
end)

-- [HILO 1: SELECTOR LENTO]
-- Ajustado a 8.0 metros para reducir candidatos.
CreateThread(function()
    while true do
        local myCoords = GetEntityCoords(PlayerPedId())
        local tempNearby = {}
        local count = 0

        for id, data in pairs(spawnedShowroomVehicles) do
            if DoesEntityExist(data.entity) then
                local dist = #(myCoords - GetEntityCoords(data.entity))
                -- [OPTIMIZACIÓN] Reducido de 15.0 a 8.0 para procesar menos
                if dist < 8.0 then
                    count = count + 1
                    tempNearby[count] = {
                        id = id,
                        entity = data.entity,
                        info = data.info
                    }
                end
            end
        end

        nearbyVehicles = tempNearby
        Wait(400) -- Ejecutar menos veces por segundo (aprox 2.5 veces)
    end
end)

-- [HILO 2: RENDERIZADOR RÁPIDO]
CreateThread(function()
    while true do
        local sleep = 1000

        -- Solo si hay vehículos en el "pool" cercano
        if #nearbyVehicles > 0 then
            local myCoords = GetEntityCoords(PlayerPedId())
            local visibleVehicles = {}
            local shouldSendUpdate = false
            local index = 0

            for i = 1, #nearbyVehicles do
                local data = nearbyVehicles[i]
                local vehCoords = GetEntityCoords(data.entity)
                local dist = #(myCoords - vehCoords)

                -- Si estamos cerca, activamos modo frame
                if dist < 5.0 then
                    sleep = 0

                    -- Solo calculamos pantalla si estamos en rango visual
                    if dist < 3.5 then
                        local tagHeight = vehCoords.z + 1.2
                        local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(vehCoords.x, vehCoords.y,
                            tagHeight)

                        if onScreen then
                            index = index + 1
                            visibleVehicles[index] = {
                                id = data.id,
                                display_name = data.info.display_name,
                                spawn_name = data.info.spawn_name,
                                setter_name = data.info.setter_name,
                                price = data.info.price,
                                x = screenX,
                                y = screenY
                            }
                            shouldSendUpdate = true
                        end
                    end
                end
            end

            if shouldSendUpdate then
                SendNUIMessage({
                    action = 'updateHUD',
                    vehicles = visibleVehicles
                })
                isHudActive = true
            elseif isHudActive then
                -- Limpieza si nos alejamos
                SendNUIMessage({
                    action = 'updateHUD',
                    vehicles = {}
                })
                isHudActive = false
            end
        else
            -- Limpieza si la lista de cercanos se vacía
            if isHudActive then
                SendNUIMessage({
                    action = 'updateHUD',
                    vehicles = {}
                })
                isHudActive = false
            end
        end

        Wait(sleep)
    end
end)
