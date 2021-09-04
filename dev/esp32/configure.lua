
-------------------------------------------------------------------
---
---    Configuration LUA Module
---      this file define the connexion parameters to wifi connexion, 
---      and modules available on the hardware
---


------- This Section defines the software modules used in hardwardConfigure procedure to configure the sensors and actuators
LocationWifi = require("locationbywifi")
TouchSensor = require("touchsensor")
Health = require("health")
SerialReceive = require("serialreceive")

local Parameters = {

    --- define here the WIFI parameters
    ---

    --- ssid define the id of the wifi endpoint connection
    --- pwd define the wifi connection password
    SSID = "YOURSSIDHERE",
    PWD =  "YOURPASSWORDHERE",

    --- device id is the id of the mqtt sensor root queue
    --- and the connexion to the mqtt broker
    DEVICEID = "esp20",
    
    --- define here the MQTT connection parameters
    MQTTBROKER =  "mqtt.frett27.net", 
   
    --- define the mqtt client id for connection to the mqtt broker 
    MQTTCLIENTID = "client_e1"

}

Parameters.MQTTCLIENTID = Parameters.MQTTCLIENTID .. Parameters.DEVICEID

local Configure = {
}

function Configure.parameters() 
    return Parameters
end


---
--- Describe here the configuration of the build hardware
---

function Configure.hardwardConfigure(allobjects)

    -- local l = LocationWifi:new({name="wifilocation"})
    -- allobjects:add(l)

    -- local t = TouchSensor:new({name="touch", pad=0, threshold=200})
    -- allobjects:add(t)

    local h = Health:new({})
    allobjects:add(h)

    -- local sr = SerialReceive:new({name="packets"})
    -- allobjects:add(sr)

end


return Configure
