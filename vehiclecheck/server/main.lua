local ESX

local function log(message, level)
    print(('[vehiclecheck] %s: %s'):format(level or 'INFO', message))
end

local function getFramework()
    local selected = VehicleCheck.Config.framework
    if selected == 'auto' then
        local esxStarted = GetResourceState('es_extended') == 'started'
        local qbStarted = GetResourceState('qb-core') == 'started'
        local qbxStarted = GetResourceState('qbx_core') == 'started'
        local count = (esxStarted and 1 or 0) + (qbStarted and 1 or 0) + (qbxStarted and 1 or 0)
        if count ~= 1 then
            return nil, count == 0 and 'Aucun framework compatible démarré.' or 'Plusieurs frameworks détectés : configurez framework explicitement.'
        end
        selected = esxStarted and 'esx' or (qbStarted and 'qbcore' or 'qbox')
    end

    if selected ~= 'esx' then
        return nil, ('Le framework « %s » n’est pas encore implémenté (seul ESX Legacy est disponible en 0.1.0).'):format(selected)
    end
    if GetResourceState('es_extended') ~= 'started' then
        return nil, 'ESX Legacy (es_extended) doit être démarré avant VehicleCheck.'
    end

    local ok, object = pcall(function()
        return exports['es_extended']:getSharedObject()
    end)
    if not ok or not object then
        return nil, 'Impossible de récupérer l’objet partagé ESX.'
    end
    return object
end

local function hasTablet(source)
    if not VehicleCheck.Config.requireTablet then return true end
    if GetResourceState('ox_inventory') ~= 'started' then return false end
    local ok, count = pcall(function()
        return exports.ox_inventory:Search(source, 'count', VehicleCheck.Config.tabletItem)
    end)
    return ok and type(count) == 'number' and count > 0
end

local function canOpen(source)
    if not ESX then return false, 'VehicleCheck n’est pas initialisé correctement.' end
    if not hasTablet(source) then return false, 'Vous devez posséder une tablette de diagnostic.' end
    if not VehicleCheck.Config.requireJob then return true end
    local player = ESX.GetPlayerFromId(source)
    if not player or not player.job then return false, 'Informations joueur indisponibles.' end
    local job = VehicleCheck.Config.allowedJobs[player.job.name]
    local grade = tonumber(player.job.grade) or 0
    if not job or grade < VehicleCheck.Config.minimumGrade then
        return false, 'Vous n’avez pas les autorisations nécessaires.'
    end
    return true
end

RegisterNetEvent('vehiclecheck:server:requestOpen', function()
    local src = source
    local allowed, reason = canOpen(src)
    if not allowed then
        TriggerClientEvent('vehiclecheck:client:notify', src, reason)
        return
    end
    TriggerClientEvent('vehiclecheck:client:open', src)
end)

CreateThread(function()
    local err
    ESX, err = getFramework()
    if not ESX then
        log(err, 'ERREUR')
        return
    end
    log('Phase fondations prête — ESX Legacy détecté. Aucune interface/diagnostic n’est encore livré.')
end)
