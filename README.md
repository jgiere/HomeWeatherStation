# HomeWeatherStation

HomeWeatherStation is the sourcecode for a small personal weather station for your home. The source code is fairly easy to understand and can be easily customized.

The station is able to measure the brightness, temperature and humidity in your home. Additionally, it keeps track of the battery life. The brightness is measured by an analog photoresistor. Temperature and humidity are measured by an DHT21 or DHT22. After the micro controller measured your home and send the data to a server, it goes into a deep sleep for 15 minutes (you can customise the time).

For this project you need to know how to flash a NodeMCU with a firmware and how to assemble the hardware. A tutorial on how to flash the NodeMCU, you can look at my [blog article](https://jgiere.de/getting-started-developing-on-a-nodemcu/)

# Parts
You need the following hardware parts:
* NodeMCU (preferably the development kit)
* Photoresistor
* DHT21 or DHT22 (you can use a DHT11 as well, but the DHT21 and 22 are more precise)
* Dupont wires
* 10kOhm resistor

# Customisation
The most basic customisations can be made in the file "config.lua". There you can specify the wifi SSID and password and other properties.

"init.lua" sole purpose is to import "config.lua", set up a wifi connection and opening "application.lua".

"application.lua" is the main code. Here all the measurements are taken and send to the server. Thanks to the Lua firmware, this code is short.

# TODO
* Publish the server source code
* Publish the PostgreSQL script
* Include a digital brightness sensor
* Bugfix: Battery life can not be measured with an analog brightness sensor (using the only ADC port)
* Create an image of the hardware assembling

# License
This source code is available under the GPLv3, Copyright Johannes Giere, 2017
