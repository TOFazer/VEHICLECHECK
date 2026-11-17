VehicleCheck = VehicleCheck or {}

VehicleCheck.Config = {
    -- V1 prend en charge ESX Legacy en premier. Les autres adaptateurs viendront ensuite.
    framework = 'esx', -- 'auto' ou 'esx'
    command = 'vehiclecheck',
    tabletItem = 'vehicle_tablet',
    requireTablet = false, -- à activer après l'intégration ox_inventory
    requireJob = true,
    allowedJobs = { mechanic = true },
    minimumGrade = 0,
    debug = false,
}
