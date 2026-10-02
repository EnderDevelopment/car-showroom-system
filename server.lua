local ESX = exports['es_extended']:getSharedObject()

local showrooms = {}
local warehouseCars = {}

-- Function to load showrooms from the database
local function LoadShowrooms()
    MySQL.Async.fetchAll('SELECT * FROM showrooms', {}, function(result)
        for _, row in ipairs(result) do
            local showroom = {
                id = row.id,
                owner = row.owner,
                name = row.name,
                location = json.decode(row.location),
                cars = {}
            }
            
            MySQL.Async.fetchAll('SELECT * FROM showroom_cars WHERE showroom_id = @showroom_id', {['@showroom_id'] = row.id}, function(cars)
                for _, car in ipairs(cars) do
                    table.insert(showroom.cars, {car_model = car.car_model})
                end
                
                table.insert(showrooms, showroom)
            end)
        end
    end)
end

-- Function to load warehouse cars from the database
local function LoadWarehouseCars()
    MySQL.Async.fetchAll('SELECT * FROM warehouse_cars', {}, function(result)
        for _, row in ipairs(result) do
            table.insert(warehouseCars, {car_model = row.car_model, price = row.price})
        end
    end)
end

-- Function to create a showroom
ESX.RegisterServerCallback('CarShowroomSystem:CreateShowroom', function(source, cb, name, location)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer.getMoney() >= Config.ShowroomPrice then
        xPlayer.removeMoney(Config.ShowroomPrice)
        
        MySQL.Async.execute('INSERT INTO showrooms (owner, name, location) VALUES (@owner, @name, @location)', {
            ['@owner'] = xPlayer.identifier,
            ['@name'] = name,
            ['@location'] = json.encode(location)
        }, function(rowsChanged)
            if rowsChanged > 0 then
                local showroom = {
                    id = rowsChanged,
                    owner = xPlayer.identifier,
                    name = name,
                    location = location,
                    cars = {}
                }
                
                table.insert(showrooms, showroom)
                TriggerClientEvent('CarShowroomSystem:UpdateShowrooms', -1, showrooms)
                cb(true, 'Showroom created successfully!')
            else
                cb(false, 'Failed to create showroom!')
            end
        end)
    else
        cb(false, 'You do not have enough money to create a showroom!')
    end
end)

-- Function to purchase a car from the warehouse
ESX.RegisterServerCallback('CarShowroomSystem:PurchaseCar', function(source, cb, carModel)
    local xPlayer = ESX.GetPlayerFromId(source)
    local carPrice = 0
    
    for _, car in ipairs(warehouseCars) do
        if car.car_model == carModel then
            carPrice = car.price
            break
        end
    end
    
    if carPrice > 0 then
        if xPlayer.getMoney() >= carPrice then
            xPlayer.removeMoney(carPrice)
            
            -- Add car to the player's inventory or spawn it
            cb(true, 'Car purchased successfully!')
        else
            cb(false, 'You do not have enough money to purchase this car!')
        end
    else
        cb(false, 'Car not found in the warehouse!')
    end
end)

-- Event to handle player joining
AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    TriggerClientEvent('CarShowroomSystem:UpdateShowrooms', playerId, showrooms)
    TriggerClientEvent('CarShowroomSystem:UpdateWarehouseCars', playerId, warehouseCars)
end)

-- Load showrooms and warehouse cars when the resource starts
Citizen.CreateThread(function()
    LoadShowrooms()
    LoadWarehouseCars()
end)