
// Copyright (C) 2018  Johannes Giere

// https://github.com/adafruit/Adafruit_Sensor
#include <Adafruit_Sensor.h>

// https://github.com/beegee-tokyo/DHTesp
#include <DHTesp.h>

#include <ESP8266WiFi.h>

#define DHTPIN D5 
#define DHTTYPE DHTesp::AM2302 //DHT11, DHT21, DHT22
 
DHTesp dht;

const char* ssid     = "Odin";
const char* password = "biNgTgPE4bpGgxFyoOyfjb2cv5D1AxQ";

void setup() 
{
  // sudo chmod 666 /dev/ttyUSB0
  Serial.begin(115200);

  delay(10);

  // We start by connecting to a WiFi network
  connectToWiFi();
  
  measure();

  enterDeepSleep();
}

void enterDeepSleep() {
    // Disconnect from WiFi before going into deep sleep.
  WiFi.disconnect();
  
  Serial.println("Going into deep sleep for 5 seconds");
  ESP.deepSleep(5e6); // 5e6 is 5 microseconds
}

void connectToWiFi() {
  Serial.print("Connecting to ");
  Serial.println(ssid);
  
  /* Explicitly set the ESP8266 to be a WiFi-client, otherwise, it by default,
     would try to act as both a client and an access-point and could cause
     network-issues with your other WiFi-devices on your WiFi-network. */
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi connected");  
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

void measure() {
  dht.setup(DHTPIN, DHTTYPE);
  Serial.println("DHT initiated");

  delay(dht.getMinimumSamplingPeriod());
  
  float humidity = measureHumidity();
  float temperature = measureTemperature();

  // Check if valid values have been returned. If any of the values is NaN, a error is printed.
  if (isnan(temperature) || isnan(humidity)) 
  {
    Serial.println("DHT22 could not be read.");

    if(isnan(temperature)) {
      Serial.println("The temperature is NaN");
    }
    if(isnan(humidity)) {
      Serial.println("The humidity is NaN");      
    }
    
    return;
  } 

  float lux = measureBrightness();
  float batteryLife = measureBatteryLife();
  
  Serial.print(dht.getStatusString());
  Serial.print("\t");
  Serial.print(humidity, 1);
  Serial.print("\t\t");
  Serial.print(temperature, 1);
  Serial.print("\t\t");
  Serial.print(dht.toFahrenheit(temperature), 1);
  Serial.print("\t\t");
  Serial.print(dht.computeHeatIndex(temperature, humidity, false), 1);
  Serial.print("\t");
  Serial.println(dht.computeHeatIndex(dht.toFahrenheit(temperature), humidity, true), 1);
  Serial.print("\t");
  Serial.println(dht.computePerception(temperature, humidity, false));
    
  yield();
}

float measureHumidity() {
  return dht.getHumidity(); //Luftfeuchte auslesen;
}

float measureTemperature() {
  return dht.getTemperature(); //Temperatur auslesen
}

/**
 * TODO: Not yet implemented.
 */
float measureBrightness() {
  return 0.0;
}

/**
 * TODO: Not yet implemented.
 */
int measureBatteryLife() {
  return 0;
}

void loop() 
{}
