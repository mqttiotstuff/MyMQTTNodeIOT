
-- ***************************************************************************
--  MQTT client for home automation, based on node mcu 
--  this is the main module, launching all the logic for the 
--  device, should not be modified
--
-- Written by Patrice freydiere
--
-- MIT license, http://opensource.org/licenses/MIT
-- ***************************************************************************


Objects = require("objects")
C = require("configure")
local P = C.parameters()

print(node.heap())

local deviceID = P["DEVICEID"];
local baseMQTTPath = "home/" .. deviceID;
local broker = P["MQTTBROKER"]


allobjects = nil 

print("connecting to "..P["SSID"])
wifi.sta.config(P["SSID"],P["PWD"], 0)

wifi.sta.autoconnect(1)
wifi.setmode(wifi.STATION)



print("set mode")

print(node.heap())

wifi.sta.eventMonReg(wifi.STA_IDLE, function() print("STATION_IDLE") end)
wifi.sta.eventMonReg(wifi.STA_CONNECTING, function() print("STATION_CONNECTING") end)
wifi.sta.eventMonReg(wifi.STA_WRONGPWD, function() print("STATION_WRONG_PASSWORD") end)
wifi.sta.eventMonReg(wifi.STA_APNOTFOUND, function() print("STATION_NO_AP_FOUND") end)
wifi.sta.eventMonReg(wifi.STA_FAIL, function() print("STATION_CONNECT_FAIL") end)
wifi.sta.eventMonReg(wifi.STA_GOTIP, function() print("STATION_GOT_IP") end)

print("connect")

wifi.sta.connect()

print("connected to wifi")

-- init mqtt client with keepalive timer 120sec
local m = mqtt.Client(P["MQTTCLIENTID"], 10, deviceID, deviceID)



-- setup Last Will and Testament (optional)
-- Broker will publish a message with qos = 0, retain = 0, data = "offline" 
-- to topic "/lwt" if client don't send keepalive packet
m:lwt(baseMQTTPath .. "/status", "offline", 0, 0)

m:on("connect", function(con) 
    print("connected to mqtt,  init the objects ")


    allobjects = Objects:new(baseMQTTPath, m)
    
    C.hardwardConfigure(allobjects)
    
    print("registering ...")
    allobjects:register()
    print("... registration done")
    
end)

m:on("offline", function(con) 
    print("offline")
end)

-- on message receive event
m:on("message", function(conn, topic, data) 
  print(topic .. ":" , topic) 
  if data ~= nil then
    print(data)
  end
end)


----------------------------------------------------------
-- main


print ("connect to mqtt " .. broker)
-- for secure: m:connect("192.168.11.118", 1880, 1)
m:connect(broker, 1883, 0, true, function(conn) 

    print("connected to mqtt broker") 
    
end, function (client, reason)
    print("error in connecting " .. reason)
end)


