local LastCCVehicle = nil
local CurrentCCMetersPerSecond = nil
local CurrentCCKmh = nil
local SpeedDiffTolerance = (0.5/3.6)
local LastFrameSpeed = nil

local LastIdealPedalPressure = 0.0
local IncreasePressure = false
local LastVehicleHealth = nil

Citizen.CreateThread(function()
    while true do
        Wait(0)

        local ped = PlayerPedId()
        local pedVeh = GetVehiclePedIsIn(ped)

        if LastCCVehicle then
            if pedVeh ~= LastCCVehicle then
                UnsetCruiseControl()
            else
                if IsControlJustPressed(0, 72) or IsControlJustPressed(0, 76) then -- brake or handbrake
                    UnsetCruiseControl()
                else
                    local engineHealth = GetVehicleEngineHealth(pedVeh)

                    if LastVehicleHealth and ((LastVehicleHealth - engineHealth) > 10) then
                        UnsetCruiseControl()
                    else
                        LastVehicleHealth = engineHealth

                        local curSpeed = GetEntitySpeed(pedVeh)

                        local diff = CurrentCCMetersPerSecond - curSpeed

                        if diff > SpeedDiffTolerance then -- car is slower then required
                            local pedalPressure = 0.95

                            if IsSteering(pedVeh) then
                                pedalPressure = 0.4
                            end

                            if IncreasePressure then
                                LastIdealPedalPressure = LastIdealPedalPressure + 0.025
                                IncreasePressure = false
                            end

                            SetControlNormal(0, 71, pedalPressure)
                        elseif diff > -(4*SpeedDiffTolerance) then -- when speed is met
                            ApplyIdealPedalPressure()
                        else
                            LastIdealPedalPressure = 0.2
                        end
                    end
                end
            end
        end

        LastForcedRpm = newLastForcedRpm
    end
end)

function ApplyIdealPedalPressure()
    if not IncreasePressure then
        IncreasePressure = true
    end
    SetControlNormal(0, 71, LastIdealPedalPressure)
end

function IsSteering(veh)
    return GetVehicleSteeringAngle(veh) > 10.0
end

function IsCruiseControlOn()
    return not not LastCCVehicle
end

function SetCruiseControl(kmh)
    ResetCurrentVehicleMaxSpeed()
    local mpsSpeed = KmhToMps(kmh)

    local veh = GetVehiclePedIsIn(PlayerPedId())

    LastCCVehicle = veh
    CurrentCCMetersPerSecond = mpsSpeed
    CurrentCCKmh = kmh
end

function UnsetCruiseControl()
    LastCCVehicle = nil
    CurrentCCMetersPerSecond = nil
    CurrentCCKmh = nil
    LastVehicleHealth = nil
end
