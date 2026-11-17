local isOpen = false

RegisterNetEvent('vehiclecheck:client:notify', function(message)
    TriggerEvent('chat:addMessage', {
        color = { 190, 230, 190 },
        multiline = true,
        args = { 'VehicleCheck', tostring(message) }
    })
end)

RegisterNetEvent('vehiclecheck:client:open', function()
    if isOpen then return end
    isOpen = true
    TriggerEvent('chat:addMessage', {
        color = { 190, 230, 190 },
        args = { 'VehicleCheck', 'Accès validé. La tablette et le diagnostic seront ajoutés dans une prochaine phase.' }
    })
    isOpen = false
end)

RegisterCommand(VehicleCheck.Config.command, function()
    TriggerServerEvent('vehiclecheck:server:requestOpen')
end, false)
