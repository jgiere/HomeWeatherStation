function readTempAndHumid(chipId, battery, brightness)

    status, temp, humi, temp_dec, humi_dec = dht.read(PIN_DHT);
    
    jsonBody = string.format(' { "temperature": %s, "humidity": %s.%s, "battery": %s, "device": %s, "brightness": %s }' ,
        temp,
        math.floor(humi),
        humi_dec,
        battery,
        chipId,
        brightness
    );
    
    http.post( SERVER_ENDPOINT, 
        "Content-Type: application/x-www-form-urlencoded\r\n",
        jsonBody, 
        function(code, data) 
            print(data);

            print("Measurement successfull ... going to sleep");
            node.dsleep(SLEEP_TIME);
        end
    )
end

-- Get chipId.
local chipId = node.chipid();

-- Read battery life
local battery;
if BATTERY_ACTIVATED == 1 then
    battery = adc.read(PIN_BATTERY) * 4 / 978;
end
if BATTERY_ACTIVATED == 0 then
    battery = 65535;
end

-- Read brightness
if BRIGHTNESS_ACTIVATED == 1 then
    local brightnessStatus = tsl2561.init(2, 1, tsl2561.ADDRESS_FLOAT, tsl2561.PACKAGE_T_FN_CL);
    if status == tsl2561.TSL2561_OK then
        status = tsl2561.settiming(tsl2561.INTEGRATIONTIME_402MS, tsl2561.GAIN_1X);
    end
    if brightnessStatus == tsl2561.TSL2561_OK then
        local lux = tsl2561.getlux();
        readTempAndHumid(chipId, battery, lux);
    end
end
if BRIGHTNESS_ACTIVATED == 0 then
    local lux = 384;
    readTempAndHumid(chipId, battery, lux);
end


