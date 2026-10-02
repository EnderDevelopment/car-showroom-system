local ESX = exports['es_extended']:getSharedObject()

local showrooms = {}
local warehouseCars = {}

-- Function to create a showroom
local function CreateShowroom(name, location)
    ESX.TriggerServerCallback('CarShowroomSystem:CreateShowroom', function(success, msg)
        if success then
            ESX.ShowNotification('Showroom created successfully!')
        else
            ESX.ShowNotification(msg)
        end
    end, name, location)
end

-- Function to purchase a car from the warehouse
local function PurchaseCar(carModel)
    ESX.TriggerServerCallback('CarShowroomSystem:PurchaseCar', function(success, msg)
        if success then
            ESX.ShowNotification('Car purchased successfully!')
        else
            ESX.ShowNotification(msg)
        end
    end, carModel)
end

-- Function to spawn a car in the showroom
local function SpawnCar(carModel, coords)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local distance = #(playerCoords - coords)
    
    if distance <= Config.CarSpawnDistance then
        local car = CreateVehicle(GetHashKey(carModel), coords.x, coords.y, coords.z, 0.0, true, false)
        SetVehicleOnGroundProperly(car)
        SetEntityAsMissionEntity(car, true, true)
        ESX.ShowNotification('Car spawned successfully!')
    else
        ESX.ShowNotification('You are too far from the showroom!')
    end
end

-- Event to update showrooms
RegisterNetEvent('CarShowroomSystem:UpdateShowrooms')
AddEventHandler('CarShowroomSystem:UpdateShowrooms', function(newShowrooms)
    showrooms = newShowrooms
end)

-- Event to update warehouse cars
RegisterNetEvent('CarShowroomSystem:UpdateWarehouseCars')
AddEventHandler('CarShowroomSystem:UpdateWarehouseCars', function(newWarehouseCars)
    warehouseCars = newWarehouseCars
end)

-- Main thread to handle showroom markers
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        for _, showroom in ipairs(showrooms) do
            local distance = #(playerCoords - vector3(showroom.location.x, showroom.location.y, showroom.location.z))
            
            if distance <= 10.0 then
                DrawMarker(Config.ShowroomMarker, showroom.location.x, showroom.location.y, showroom.location.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.ShowroomMarkerColor.r, Config.ShowroomMarkerColor.g, Config.ShowroomMarkerColor.b, Config.ShowroomMarkerColor.a, false, true, 2, nil, nil, false)
                
                if distance <= 1.5 then
                    ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to interact with the showroom')
                    
                    if IsControlJustReleased(0, 38) then
                        -- Open showroom menu
                        OpenShowroomMenu(showroom)
                    end
                end
            end
        end
    end
end)

-- Function to open the showroom menu
function OpenShowroomMenu(showroom)
    local elements = {}
    
    for _, car in ipairs(showroom.cars) do
        table.insert(elements, {label = car.car_model, value = car.car_model})
    end
    
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'showroom_menu', {
        title = showroom.name,
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        SpawnCar(data.current.value, showroom.location)
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end