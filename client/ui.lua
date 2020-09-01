Citizen.CreateThread(function()
    WarMenu.CreateMenu('teb_speed_control', '')
    WarMenu.SetMenuX('teb_speed_control', 0.7)
    WarMenu.SetMenuY('teb_speed_control', 0.4) 
    WarMenu.SetSubTitle('teb_speed_control', Config.Text.SelectSpeed)

    local currentHeadline = ''

    while true do
        Wait(0)

        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)

        if Config.ToggleWithKey and veh > 0 and IsControlJustPressed(0, Config.Key) then
            WarMenu.OpenMenu('teb_speed_control')
        end

        if Config.ToggleWithKey and WarMenu.IsMenuOpened('teb_speed_control') then

            if veh == 0 or not veh then
                WarMenu.CloseMenu()
            end

            local unit = Config.Mode == MODE_KMH and 'km/h' or 'mph'
            local vehModel = GetEntityModel(veh)

            local hasCruiseControl = Config.CruiseControlWhitelist[vehModel]

            if hasCruiseControl then
                EnsureWarmenuTitle(Config.Text.CruiseControl)
            else
                EnsureWarmenuTitle(Config.Text.SpeedLimiter)
            end
            
            if WarMenu.Button(Config.Text.SetCurrentSpeed) then
                SetCurrentSpeed(hasCruiseControl, veh)
            end
            
            if WarMenu.Button(Config.Text.Disable) then
                TriggerEvent('teb_speed_control:stop')
            end

            for _, speed in pairs(Config.Speeds) do
                if WarMenu.Button(speed .. ' ' .. unit) then
                    SetRequestedSpeed(hasCruiseControl, speed)
                end
            end

            WarMenu.Display()
        end
    end
end)

function SetCurrentSpeed(hasCruiseControl, veh)
    local speed = GetEntitySpeed(veh)
    
    if Config.Mode == MODE_KMH then
        SetRequestedSpeed(hasCruiseControl, MpsToKmh(speed))
    else
        SetRequestedSpeed(hasCruiseControl, MpsToMph(speed))
    end
end

function SetRequestedSpeed(hasCruiseControl, speed)
    if hasCruiseControl then
        TriggerEvent('teb_speed_control:setCruiseControl', speed)
    else
        TriggerEvent('teb_speed_control:setSpeedLimiter', speed)
    end
end

local CurrentHeadline = ''
function EnsureWarmenuTitle(title)
    if CurrentHeadline ~= title then
        CurrentHeadline = title
        WarMenu.SetTitle('teb_speed_control', title)
    end
end