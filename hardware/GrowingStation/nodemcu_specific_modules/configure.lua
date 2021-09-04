
-------------------------------------------------------------------
---
---    Configuration LUA Module
---      this file define the connexion parameters to wifi connexion, 
---      and modules available on the hardware
---


------- This Section defines the software modules used in hardwardConfigure procedure to configure the sensors and actuators

Reboot = require("reboot")
Health = require("health")
SensorSerial = require("serialsensor")
SerialActuator = require("serialactuator")


local Parameters = {

    --- define here the WIFI parameters
    ---

    --- ssid define the id of the wifi endpoint connection
    --- pwd define the wifi connection password
    SSID = "SSID",
    PWD =  "PASSWORD",

    --- device id is the id of the mqtt sensor root queue
    --- and the connexion to the mqtt broker
    DEVICEID = "esp50",
    
    --- define here the MQTT connection parameters
    MQTTBROKER =  "BROKER", --"192.168.4.53",
   
    --- define the mqtt client id for connection to the mqtt broker 
    MQTTCLIENTID = "client_"

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
    print(node.heap())
    
    local serialcomm = dofile("serialcomm.lua")()
    
    local ss = SerialSensor:new({name="serre", serial=serialcomm})
    allobjects:add(ss)

    local light = SerialActuator:new({name="light", serial=serialcomm})
    allobjects:add(light)

    local pump = SerialActuator:new({name="pump", serial=serialcomm})
    allobjects:add(pump)

    --local l = LocationWifi:new({name="wifilocation"})
    --allobjects:add(l)

    -- reboot
    local rb = Reboot:new({})
    allobjects:add(rb)

    -- health
    local health = Health:new({})
    allobjects:add(health)

end


return Configure
