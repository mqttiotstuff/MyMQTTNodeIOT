# MyMqttIot HowTo

To use the myMqttIot tookit, follow the below instructions, and description

## Toolkit files

The toolkit can be used using the ESPxplorer programmer to send the files to ESP8266, it permit to send the lua routines to make it work.

The core consist of several files that must be sent to the esp :

```
main.lua : main file that boot the system
mqtt-queue-helper.lua : routine from Vladimir Dronnikov  helping queuing messages to mqtt broker
objects.lua : sensor and object manager

init.lua : bootstrap executing the main.lua file

configure.lua : the configuration files
```

Configure is the main point when setting up a new device, it describe the modules and 

Bundled configure File : 

```lua

-------------------------------------------------------------------
---
---    Configuration LUA Module
---      this file define the connexion parameters to wifi connexion, 
---      and modules available on the hardware
---


------- This Section defines the software modules used in hardwardConfigure procedure to configure the sensors and actuators



--Interruptor = require("interrupt")
--Temperature = require("temperature")
--Relay = require("relay")
--LocationByWifi = require("locationbywifi")
Led8 = require("led8")
--BD = require("bodydetection")
ADC = require("adcesp")

local Parameters = {

    --- define here the WIFI parameters
    ---

    --- ssid define the id of the wifi endpoint connection
    --- pwd define the wifi connection password
    SSID = "",
    PWD = "",

    --- device id is the id of the mqtt sensor root queue
    --- and the connexion to the mqtt broker
    DEVICEID = "esp03",

    
    --- define here the MQTT connection parameters
    MQTTBROKER = "mqtt.frett27.net",
   
    --- define the mqtt client id for connection to the mqtt broker 
    MQTTCLIENTID = "clientid3"

}


local Configure = {
}

function Configure.parameters() 
    return Parameters
end



---
--- Describe here the configuration of the build hardware
---

function Configure.hardwardConfigure(allobjects)
    
    -- local i=Interruptor:new({pin=6, name="interruptor"})
    -- allobjects:add(i)
    -- local t = Temperature:new({pin = 4, name="temperature"})
    -- allobjects:add(t)

    -- local r = Relay:new({pin = 3, name="relay1"})
    -- allobjects:add(r)
    
    -- local r2 = Relay:new({pin = 0, name="relay2"})
    -- allobjects:add(r2)

    --local wl = LocationByWifi:new({name="wifilocation"})
    --allobjects:add(wl)

    local l8 = Led8:new({name="led8",leds=64})
    allobjects:add(l8)

    --local bdd = BD:new({name="body"})
    --allobjects:add(bdd)

    local a = ADC:new({name="adc"})
    allobjects:add(a)

end


return Configure
```

The configure.lua file has a configure section for defining the broker, and credentials for connecting to the broker. then the second section, `hardwardConfigure` function set up the devices managed by the toolkit.

ie : Relay, LocationByWifi, Led8, BD, ADC, Temperature

All are Lua objects following a common interface to be taken by the Objects.lua object that manage the life cycle and communication to the MQTT broker.



## Sensors and Actuators

### Interrupt

this object managed a switch connected to a Digital GPIO, 

instanciation is done giving a "pame", and "pin" information in the constructor. Instanciation example :

```
local i=Interruptor:new({pin=6, name="interruptor"})
allobjects:add(i)
```

then when the interrupt change its state, it is launch a message on "**home/[deviceid]/sensors/interrupt**" with the switch state (0 or 1).



@@To be continued