
-------------------------------------------------------------------
---
---    Configuration LUA Module
---      this file define the connexion parameters to wifi connexion, 
---      and modules available on the hardware
---


------- This Section defines the software modules used in hardwardConfigure procedure to configure the sensors and actuators



--Interruptor = require("interrupt")
--Temperature = require("temperature")
Relay = require("relay")
--LocationByWifi = require("locationbywifi")
--Led8 = require("led8")
--BD = require("bodydetection")
--ADC = require("adcesp")

local Parameters = {

    --- define here the WIFI parameters
    ---

    --- ssid define the id of the wifi endpoint connection
    --- pwd define the wifi connection password
    SSID = "freebox_pf",
    PWD = "frett271234567890",

    --- device id is the id of the mqtt sensor root queue
    --- and the connexion to the mqtt broker
    DEVICEID = "esp01",

    
    --- define here the MQTT connection parameters
    MQTTBROKER = "mqtt.frett27.net",
   
    --- define the mqtt client id for connection to the mqtt broker 
    MQTTCLIENTID = "clientid1"

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

    local r = Relay:new({pin = 7, name="relay1"})
    allobjects:add(r)
    
     local r2 = Relay:new({pin = 8, name="relay2"})
     allobjects:add(r2)

    --local wl = LocationByWifi:new({name="wifilocation"})
    --allobjects:add(wl)

    --local l8 = Led8:new({name="led8",leds=64})
    --allobjects:add(l8)

    --local bdd = BD:new({name="body"})
    --allobjects:add(bdd)

    --local a = ADC:new({name="adc"})
    --allobjects:add(a)

end


return Configure
