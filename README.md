# Car Showroom System

Manage and display cars in your FiveM server with ease.

## Features

- Create and manage car showrooms at any location
- Purchase cars from a dedicated warehouse
- Interactive markers and menus for easy navigation

## Requirements

- FiveM server
- ESX Framework
- MySQL-Async

## Installation

1. Download the script and place it in your FiveM server's `resources` folder.
2. Import the `database.sql` file into your MySQL database.
3. Add the following to your `server.cfg`:

```
start mysql-async
start es_extended
start CarShowroomSystem
```

## Usage

### Creating a Showroom

1. Use the `/createshowroom` command followed by the name and location.
2. The showroom will be created at the specified location.

### Purchasing a Car

1. Use the `/purchasecar` command followed by the car model.
2. The car will be added to your inventory or spawned at your location.

## Configuration

The script can be configured in the `config.lua` file. Adjust the following settings:

```lua
Config = {}

-- Showroom settings
Config.ShowroomPrice = 500000 -- Price to create a showroom
Config.ShowroomMarker = 27 -- Marker type for showrooms
Config.ShowroomMarkerColor = {r = 0, g = 255, b = 0, a = 100} -- Marker color

-- Warehouse settings
Config.WarehouseMarker = 27 -- Marker type for warehouse
Config.WarehouseMarkerColor = {r = 255, g = 0, b = 0, a = 100} -- Marker color

-- Car settings
Config.CarPrice = 100000 -- Base price for cars
Config.CarSpawnDistance = 5.0 -- Distance to spawn cars from the showroom
```

---

## Generated with EnderDevelopment

This plugin was generated in minutes with [EnderDevelopment](https://enderdevelopment.com) — the AI platform that turns your ideas into working Minecraft plugins, Discord bots and FiveM scripts.

**Want your own?** [Generate this project on EnderDevelopment](https://dash.enderdevelopment.com?utm_source=github&utm_medium=readme&utm_campaign=car-showroom-system&utm_content=bottom) — describe it in one sentence and get the full source code.