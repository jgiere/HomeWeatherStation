
dhtTemp = nil;
dhtTempDec = nil;
humidity = nil;
humidityDec = nil;
battery = nil;
lux = nil;
ds18b20Temp = nil;
-- Get chipId.
chipId = node.chipid();
    
function sendData()
    jsonBody = string.format(' { "temperature": %s, "humidity": %s.%s, "battery": %s, "device": %s, "brightness": %s, "temperature_2": %s }' ,
        dhtTemp,
        math.floor(humidity),
        humidityDec,
        battery,
        chipId,
        lux,
        ds18b20Temp
    );
    print(jsonBody);
    
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

-- Get Data from DHT
function readDHT(callback, callback2, callback3, callback4)
    
    if DHT_ACTIVATED == 1 then
        status, dhtTemp, humidity, dhtTempDec, humidityDec = dht.read(PIN_DHT);
    end
    if DHT_ACTIVATED == 0 then
        dhtTemp = -999;
        dhtTempDec = 0;
        humidity = -999;
        humidityDec = 0;
    end

    callback(callback2, callback3, callback4);
end

-- Read battery life
function readBattery(callback, callback2, callback3)
    if BATTERY_ACTIVATED == 1 then
        battery = adc.read(PIN_BATTERY) * 4 / 978;
    end
    if BATTERY_ACTIVATED == 0 then
        battery = 65535;
    end

    callback(callback2, callback3);
end

-- Read brightness
function readBrightness(callback, callback2)
    local brightnessStatus;
    
    if BRIGHTNESS_ACTIVATED == 1 then
        brightnessStatus = tsl2561.init(2, 1, tsl2561.ADDRESS_FLOAT, tsl2561.PACKAGE_T_FN_CL);
        if brightnessStatus == tsl2561.TSL2561_OK then
            brightnessStatus = tsl2561.settiming(tsl2561.INTEGRATIONTIME_402MS, tsl2561.GAIN_1X);
        end
        if brightnessStatus == tsl2561.TSL2561_OK then
            lux = tsl2561.getlux();
        end
    end
    
    if BRIGHTNESS_ACTIVATED == 0 then
        lux = 384;
    end
    
    callback(callback2);
end

function readDS18B20(callback)
    if DS18B20_ACTIVATED == 1 then
        ds18b20.setup(PIN_DS18B20)
    
        -- read all sensors and print all measurement results
        ds18b20.read(
            function(ind,rom,res,temp,tdec,par)
                ds18b20Temp = temp;
                
                callback();
            end,{}
        );
    end

    if DS18B20_ACTIVATED == 0 then
    
    end
end


readDHT(
    readBattery,
    readBrightness,
    readDS18B20,
    sendData
);
