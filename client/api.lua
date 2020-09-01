AddEventHandler('teb_speed_control:setCruiseControl', function(speed)
    SetCruiseControl(GetConfigCorrectSpeed(speed))
end)

AddEventHandler('teb_speed_control:setSpeedLimiter', function(speed)
    LimitVehicleSpeed(GetConfigCorrectSpeed(speed))
end)

AddEventHandler('teb_speed_control:stop', function()
    UnsetCruiseControl()
    ResetCurrentVehicleMaxSpeed()
end)

-- converts given speed that is either
-- mph/kmh depending on config
-- into kmh required by this resource
function GetConfigCorrectSpeed(speed)
    if Config.Mode == MODE_KMH then
        return speed
    end

    return speed * 1.609
end