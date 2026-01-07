local Framework = {}

-- =================================================================
-- SECCIÓN 1: CARGA DINÁMICA DEL FRAMEWORK
-- =================================================================

if Config.Framework == 'qbcore' then
    Framework.Core = exports['qb-core']:GetCoreObject()
elseif Config.Framework == 'esx' then
    TriggerEvent('esx:getSharedObject', function(obj)
        Framework.Core = obj
    end)
elseif Config.Framework == 'new_esx' then
    Framework.Core = exports.es_extended:getSharedObject()
elseif Config.Framework == 'ox' then
    Framework.Core = exports.ox_core:GetCoreObject()
end

-- =================================================================
-- SECCIÓN 2: INICIALIZACIÓN DE LA BASE DE DATOS
-- =================================================================

local function InitializeDatabaseSchema()
    local createSpawnsTableQuery = [[
        CREATE TABLE IF NOT EXISTS `dp_pdmescaparates_spawns` (
            `id` INT(11) NOT NULL AUTO_INCREMENT,
            `name` VARCHAR(50) NOT NULL,
            `x` DECIMAL(10, 2) NOT NULL,
            `y` DECIMAL(10, 2) NOT NULL,
            `z` DECIMAL(10, 2) NOT NULL,
            `h` DECIMAL(10, 2) NOT NULL,
            PRIMARY KEY (`id`),
            UNIQUE KEY `unique_spawn_name` (`name`)
        );
    ]]

    local createVehiclesTableQuery = [[
        CREATE TABLE IF NOT EXISTS `dp_pdmescaparates_vehicles` (
            `id` INT(11) NOT NULL AUTO_INCREMENT,
            `model` VARCHAR(50) NOT NULL, 
            `display_name` VARCHAR(100) NOT NULL, 
            `spawn_id` INT(11) NULL DEFAULT 0, 
            `price` INT(11) NOT NULL DEFAULT 0,
            `date_added` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
            `setter_identifier` VARCHAR(60) NOT NULL, 
            `setter_name` VARCHAR(100) NOT NULL, 
            PRIMARY KEY (`id`),
            INDEX `model_index` (`model`)
        );
    ]]

    exports['oxmysql']:execute(createSpawnsTableQuery, {}, function()
    end)
    exports['oxmysql']:execute(createVehiclesTableQuery, {}, function()
    end)
end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        InitializeDatabaseSchema()
    end
end)

-- =================================================================
-- SECCIÓN 3: FUNCIONES DE UTILIDAD
-- =================================================================

local function HasJob(source)
    local src = source
    if not Framework.Core then
        return false
    end
    if type(src) ~= 'number' then
        return false
    end

    local hasJob = false
    if Config.Framework == 'qbcore' then
        local Player = Framework.Core.Functions.GetPlayer(src)
        if Player and Player.PlayerData.job.name == Config.JobName then
            hasJob = true
        end
    elseif Config.Framework == 'esx' or Config.Framework == 'new_esx' then
        local Player = Framework.Core.GetPlayerFromId(src)
        if Player and Player.job and Player.job.name == Config.JobName then
            hasJob = true
        end
    elseif Config.Framework == 'ox' then
        local Player = Framework.Core.GetPlayer(src)
        if Player and Player.job and Player.job == Config.JobName then
            hasJob = true
        end
    end
    return hasJob
end

-- =================================================================
-- SECCIÓN 4: CAPA DE PERSISTENCIA (Base de Datos)
-- =================================================================

local function GetShowroomVehicles(cb)
    local query = [[
        SELECT 
            v.id, v.model, v.display_name, v.spawn_id, v.setter_identifier, v.setter_name, v.price,
            CAST(v.date_added AS CHAR) as date_added,
            s.name AS spawn_name,
            s.x AS spawn_x, 
            s.y AS spawn_y, 
            s.z AS spawn_z, 
            s.h AS spawn_h
        FROM 
            dp_pdmescaparates_vehicles v
        LEFT JOIN 
            dp_pdmescaparates_spawns s ON v.spawn_id = s.id;
    ]]
    exports['oxmysql']:query(query, {}, function(result)
        if result then
            cb(result)
        else
            cb({})
        end
    end)
end

local function GetShowroomSpawns(cb)
    exports['oxmysql']:query('SELECT id, name, x, y, z, h FROM dp_pdmescaparates_spawns', {}, cb)
end

-- Función para recargar la lista en TODOS los clientes
local function ReloadAllClients()
    GetShowroomVehicles(function(vehicles)
        TriggerClientEvent('DP-PdmEscaparates:client:sendVehicles', -1, vehicles)
    end)
end

local function AddShowroomSpawn(spawnData, src)
    exports['oxmysql']:query('SELECT COUNT(id) as cnt FROM dp_pdmescaparates_spawns WHERE name = ?', {spawnData.name},
        function(result)
            local count = (result and result[1] and result[1].cnt) and tonumber(result[1].cnt) or 0
            if count > 0 then
                TriggerClientEvent('QBCore:Notify', src, _L('error_name_exists', spawnData.name), 'error', 5000)
                return
            end
            exports['oxmysql']:insert('INSERT INTO dp_pdmescaparates_spawns (name, x, y, z, h) VALUES (?, ?, ?, ?, ?)',
                {spawnData.name, spawnData.x, spawnData.y, spawnData.z, spawnData.h}, function()
                    TriggerClientEvent('QBCore:Notify', src, _L('spawn_saved', spawnData.name), 'success', 5000)
                end)
        end)
end

local function AddShowroomVehicle(vehicleData, src)
    local Player = Framework.Core.Functions.GetPlayer(src)
    local playerName =
        Player and (Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname) or 'Desconocido'
    local playerIdentifier = Player and Player.PlayerData.citizenid or 'unknown'
    local price = tonumber(vehicleData.price) or 0

    exports['oxmysql']:insert(
        'INSERT INTO dp_pdmescaparates_vehicles (model, display_name, spawn_id, price, setter_identifier, setter_name) VALUES (?, ?, ?, ?, ?, ?)',
        {vehicleData.model, vehicleData.display_name or vehicleData.model, vehicleData.spawn_id or 0, price,
         playerIdentifier, playerName}, function()
            TriggerClientEvent('QBCore:Notify', src, _L('vehicle_assigned', vehicleData.display_name), 'success', 5000)
            ReloadAllClients()
        end)
end

-- =================================================================
-- SECCIÓN 5: EVENTOS DE RED
-- =================================================================

RegisterNetEvent('DP-PdmEscaparates:server:getVehicles')
AddEventHandler('DP-PdmEscaparates:server:getVehicles', function()
    local src = source
    -- Eliminada comprobación de trabajo. Todos deben ver los coches.
    GetShowroomVehicles(function(vehicles)
        TriggerClientEvent('DP-PdmEscaparates:client:sendVehicles', src, vehicles)
    end)
end)

RegisterNetEvent('DP-PdmEscaparates:server:getSpawns')
AddEventHandler('DP-PdmEscaparates:server:getSpawns', function()
    local src = source
    if not HasJob(src) then
        return
    end
    GetShowroomSpawns(function(spawns)
        TriggerClientEvent('DP-PdmEscaparates:client:sendSpawns', src, spawns)
    end)
end)

RegisterNetEvent('DP-PdmEscaparates:server:setSpawn')
AddEventHandler('DP-PdmEscaparates:server:setSpawn', function(spawnData)
    local src = source
    if not HasJob(src) then
        return
    end
    if not spawnData.name or not spawnData.x then
        return
    end
    AddShowroomSpawn(spawnData, src)
end)

RegisterNetEvent('DP-PdmEscaparates:server:assignVehicle')
AddEventHandler('DP-PdmEscaparates:server:assignVehicle', function(vehicleData)
    local src = source
    if not HasJob(src) then
        return
    end
    if not vehicleData.model then
        return
    end
    AddShowroomVehicle(vehicleData, src)
end)

RegisterNetEvent('DP-PdmEscaparates:server:editVehicle')
AddEventHandler('DP-PdmEscaparates:server:editVehicle', function(vehicleData)
    local src = source
    if not HasJob(src) then
        return
    end

    local price = tonumber(vehicleData.price) or 0

    exports['oxmysql']:execute(
        'UPDATE dp_pdmescaparates_vehicles SET model = ?, display_name = ?, spawn_id = ?, price = ? WHERE id = ?',
        {vehicleData.model, vehicleData.display_name, vehicleData.spawn_id, price, vehicleData.id},
        function(rowsAffected)
            TriggerClientEvent('QBCore:Notify', src, _L('vehicle_updated', vehicleData.display_name), 'success', 5000)
            TriggerClientEvent('DP-PdmEscaparates:client:deleteVehicleEntity', -1, vehicleData.id)
            ReloadAllClients()
        end)
end)

RegisterNetEvent('DP-PdmEscaparates:server:deleteVehicle')
AddEventHandler('DP-PdmEscaparates:server:deleteVehicle', function(vehicleId)
    local src = source
    if not HasJob(src) then
        return
    end

    exports['oxmysql']:execute('DELETE FROM dp_pdmescaparates_vehicles WHERE id = ?', {vehicleId},
        function(rowsAffected)
            TriggerClientEvent('QBCore:Notify', src, _L('vehicle_deleted'), 'success', 5000)
            TriggerClientEvent('DP-PdmEscaparates:client:deleteVehicleEntity', -1, vehicleId)
            ReloadAllClients()
        end)
end)

-- =================================================================
-- SECCIÓN 6: COMANDOS
-- =================================================================

RegisterCommand(Config.Command, function(source, args, rawCommand)
    local src = source
    -- El comando SÍ se mantiene restringido, solo el menú de gestión.
    if HasJob(src) then
        TriggerClientEvent('DP-PdmEscaparates:client:openMenu', src)
    else
        if Config.NotifyOnDeny then
            TriggerClientEvent('QBCore:Notify', src, _L('no_permission'), 'error', 5000)
        end
    end
end)
