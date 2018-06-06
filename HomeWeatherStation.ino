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

  Serial.println();
  Serial.println();
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
  
  dht.setup(DHTPIN, DHTTYPE);
  Serial.println("DHT initiated");
}
 
void loop() 
{
  delay(dht.getMinimumSamplingPeriod());
  
  float humidity = dht.getHumidity(); //Luftfeuchte auslesen
  float temperature = dht.getTemperature(); //Temperatur auslesen
  
  // Prüfen ob eine gültige Zahl zurückgegeben wird. Wenn NaN (not a number) zurückgegeben wird, dann Fehler ausgeben.
  if (isnan(temperature) || isnan(humidity)) 
  {
    Serial.println("DHT22 konnte nicht ausgelesen werden");
  } 
  else
  {
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
  }
  
  yield();

  Serial.println("Going into deep sleep for 5 seconds");
  ESP.deepSleep(5e6); // 5e6 is 5 microseconds
}
