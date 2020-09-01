local LastSpeedLimitedVehicle = nil
local CurrentMaxSpeedMetersPerSecond = nil
local CurrentMaxSpeedKmh = nil
local SpeedDiffTolerance = (2/3.6)
local LastForcedRpm = nil

Citizen.CreateThread(function()
    while true do
        Wait(0)

        if LastSpeedLimitedVehicle then

            local ped = PlayerPedId()
            local pedVeh = GetVehiclePedIsIn(ped)
            local newLastForcedRpm = nil

            if pedVeh ~= LastSpeedLimitedVehicle then
                ResetVehicleMaxSpeed(LastSpeedLimitedVehicle)
                LastSpeedLimitedVehicle = nil
            else
                local rpm = GetVehicleCurrentRpm(pedVeh)
                local curSpeed = GetEntitySpeed(pedVeh)

                local diff = CurrentMaxSpeedMetersPerSecond - curSpeed

                if diff < SpeedDiffTolerance then -- lower RPM while speed is max
                    local newRpm = nil
                    if LastForcedRpm then
                        newRpm = LastForcedRpm - 0.03
                        LastForcedRpm = newRpm
                    else
                        newRpm = rpm - 0.03
                        LastForcedRpm = newRpm
                    end
                    
                    if newRpm > 0.35 then
                        SetVehicleCurrentRpm(pedVeh, newRpm)
                    end
                end
            end
        end

        LastForcedRpm = newLastForcedRpm
    end
end)

function IsLimitingSpeed()
    return not not LastSpeedLimitedVehicle
end

function LimitVehicleSpeed(kmh)
    UnsetCruiseControl()

    local mpsSpeed = KmhToMps(kmh)

    local veh = GetVehiclePedIsIn(PlayerPedId())

    LastSpeedLimitedVehicle = veh
    CurrentMaxSpeedMetersPerSecond = mpsSpeed
    CurrentMaxSpeedKmh = kmh

    SlowDownToLimitSpeed(veh, mpsSpeed)

    SetVehicleMaxSpeed(veh, mpsSpeed)
end

function SlowDownToLimitSpeed(veh, wantedSpeed)
    local timeout = 4.0 -- limits the slowing down to 4 seconds at most

    while timeout > 0.0 do
        Wait(0)
        
        timeout = timeout - GetFrameTime()
        
        local speed = GetEntitySpeed(veh)
        if wantedSpeed > speed then
            return
        else
            SetControlNormal(0, 72, 1.0)
            SetControlNormal(0, 71, 0.0)
        end
    end
end

function ResetCurrentVehicleMaxSpeed()
    if LastSpeedLimitedVehicle then
        ResetVehicleMaxSpeed(LastSpeedLimitedVehicle)
    else
        ResetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId()))
    end
end

function ResetVehicleMaxSpeed(veh)
    local maxSpeed = GetVehicleHandlingFloat(veh,"CHandlingData","fInitialDriveMaxFlatVel")
    SetVehicleMaxSpeed(veh, maxSpeed)
    LastSpeedLimitedVehicle = nil
    CurrentMaxSpeedMetersPerSecond = nil
    CurrentMaxSpeedKmh = nil
    LastForcedRpm = nil
end
