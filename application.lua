function readTempAndHumid()

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

    
    
    http.post( SERVER_ENDPOINT, 
        "Content-Type: application/x-www-form-urlencoded\r\n",
        jsonBody, 
        function(code, data) 
            print(data);
    
            -- 15 * 60 seconds sleep (15 minutes)
            print("Measurement successfull ... going to sleep");
            node.dsleep(15 * 60 * 1000000);
        end
    )
end

-- Get chipId.
chipId = node.chipid();

-- Read battery life
-- BUG: This does not work.
battery = adc.readvdd33();

-- Read brightness over adc
pinBrightness = 0;
brightness = adc.read(pinBrightness);

readTempAndHumid();
