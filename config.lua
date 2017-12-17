SSID = "";
PASSWORD = "";

-- 15 * 60 seconds sleep (15 minutes)
SLEEP_TIME = 15 * 60 * 1000000;

SERVER = "http://127.0.0.1/HomeWeatherStationAPI/api";
MEASURE_SCRIPT = "measure.php";

SERVER_ENDPOINT = string.format("%s/%s", SERVER, MEASURE_SCRIPT);

-- Measuring setups
DHT_ACTIVATED = 0;
BATTERY_ACTIVATED = 0;
BRIGHTNESS_ACTIVATED = 0;

-- PIN configuration
PIN_DHT = 4;
PIN_BATTERY = 0;
