![Speed Limiter](/img/img.jpg)
# RP Friendly Cruise Control/Speed Limiter

Our discord with more scripts: https://discord.gg/F28PfsY

This is new iteration of Cruise Control/Speed Limiting, that I've had good feedback on compared to other Cruise Control/Speed limiter scripts.

You can configure what cars have cruise control in the config, other cars have just speed limiter - you must hold W key to drive.

## Speed limiter

Compared to other speed limiter script I've tried, this one controls the engine RPM so that the engine does not overrev in lower speeds. With this script you can easily cruise at lower speeds with speed limiter. When setting the speed limit the car DOES NOT suddenly slow down but instead it applies breaks until wanted speed is reached.

## Cruise control

The cruise control, compared to other scripts, works by applying ideal pedal pressure to reach and maintain wanted speed. The script also lets off the gas when steering to have more control over the car in turns.

## Control

By default, you open Cruise Control menu by pressing F7. You can configure the key or wether or not it even is controlable by key in config. You can just as well integrate this script into your system and control the speed limiter/cruise control with event API.

## Config

In `config.lua` you can set if you want to use KM/H or MPH with
- `Mode = MODE_MPH` or `Mode = MODE_KMH`
- You can configure the speeds in default menu in `Speeds` table
- You can translate the resource in the `Text` table
- You can add or remove vehicles in the `CruiseControlWhitelist` table

## API

- `TriggerEvent('teb_speed_control:setCruiseControl', speed)`
Sets the cruise control to wanted speed. KM/H or MPH is configured in Config.lua

- `TriggerEvent('teb_speed_control:setSpeedLimiter', speed)`
Sets the speed limiter to wanted speed. KM/H or MPH is configured in Config.lua

- `TriggerEvent('teb_speed_control:stop')`
Stops cruise control AND speed limiter
