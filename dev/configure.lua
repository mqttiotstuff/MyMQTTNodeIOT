
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

LocationByWifi = require("locationbywifi")


local Parameters = {

    --- define here the WIFI parameters
    ---

    --- ssid define the id of the wifi endpoint connection
    --- pwd define the wifi connection password
    SSID = "REPLACE_WITH_YOUR_WIFI_ID",
    PWD = "REPLACE_WITH_YOUR_WIFI_CONNEXION",

    --- device id is the id of the mqtt sensor root queue
    --- and the connexion to the mqtt broker
    DEVICEID = "esp02",

    
    --- define here the MQTT connection parameters
    MQTTBROKER = "mqtt.frett27.net",
   
    --- define the mqtt client id for connection to the mqtt broker 
    MQTTCLIENTID = "clientid2"

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

    local wl = LocationByWifi:new({name="wifilocation"})
    allobjects:add(wl)


end


return Configure
