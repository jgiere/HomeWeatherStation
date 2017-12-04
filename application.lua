function readTempAndHumid(chipId, battery, brightness)

    --read dht21 from pin
    pinDHT21 = 4;
    status, temp, humi, temp_dec, humi_dec = dht.read(pinDHT21);
    
    jsonBody = string.format(' { "temperature": %s, "humidity": %s.%s, "battery": %s, "device": %s, "brightness": %s }' ,
        temp,
        math.floor(humi),
        humi_dec,
        battery,
        chipId,
        brightness
    );

    print(SERVER_ENDPOINT);
    
    http.post( SERVER_ENDPOINT, 
        "Content-Type: application/x-www-form-urlencoded\r\n",
        jsonBody, 
        function(code, data) 
            print(data);

            print("Measurement successfull ... going to sleep");
            --node.dsleep(SLEEP_TIME);
        end
    )
end

-- Get chipId.
local chipId = node.chipid();

-- Read battery life
-- BUG: This does not work.
local battery = adc.readvdd33();

-- Read brightness
local brightnessStatus = tsl2561.init(2, 1, tsl2561.ADDRESS_FLOAT, tsl2561.PACKAGE_T_FN_CL)
if brightnessStatus == tsl2561.TSL2561_OK then
    local lux = tsl2561.getlux();
    readTempAndHumid(chipId, battery, lux);
end


