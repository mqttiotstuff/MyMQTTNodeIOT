-- ***************************************************************************
--  MQTT client for home automation, based on node mcu 
--  this is the main module, launching all the logic for the 
--  device, should not be modified
--
-- Written by Patrice freydiere
--
-- MIT license, http://opensource.org/licenses/MIT
-- ***************************************************************************

-- updated for new firmware 2020 - change eventmon events
-- changed disconnected logic and MQTT connection logic

Objects = require("objects")
C = require("configure")
local P = C.parameters()
 
print(node.heap())

local deviceID = P["DEVICEID"];
local baseMQTTPath = "home/" .. deviceID
local broker = P["MQTTBROKER"];
if broker == nil then
    error("no broker config")
end
 

allobjects = nil 

wifi.setmode(wifi.STATION)
local c = {}
c.ssid = P["SSID"]
c.pwd = P["PWD"]
wifi.sta.config(c)

-- wifi.sta.autoconnect(1)
-- print("set mode")
-- print(node.heap())

wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function(t) 
                -- disconnected is launched when load balance
                print("disconnected " .. t.reason)           
                if t.reason ~= 8 then
                    node.restart()
                end
            end)

print("connecting to "..P["SSID"])
wifi.sta.connect()

-- init mqtt client with keepalive timer 120sec
local m = mqtt.Client(P["MQTTCLIENTID"], 100, deviceID, deviceID)

-- setup Last Will and Testament (optional)
-- Broker will publish a message with qos = 0, retain = 0, data = "offline" 
-- to topic "/lwt" if client don't send keepalive packet
m:lwt(baseMQTTPath .. "/status", "offline", 0, 0)

m:on("connect", function(con) 
   
end)

m:on("offline", function(con) 
    node.restart()
end)

-- on message receive event
m:on("message", function(conn, topic, data) 
  -- print(topic .. ":" , topic) 
  if data ~= nil then
    -- print(data)
  end
end)

function init() 
    print("connected to mqtt,  init the objects ")
    allobjects = Objects:new(baseMQTTPath, m)
    -- configure the device elements
    C.hardwardConfigure(allobjects)
end

----------------------------------------------------------
-- main

init()
    
wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, function(ssid,bssid,channel)
    print("connected to wifi")
    
    print ("connect to mqtt " .. broker)

    m:connect(broker, 1883, false, function(conn) 
            print("connected to mqtt broker "..tostring(conn)) 
            print(node.heap())
            -- print("registering ...")
            allobjects:register()
            -- print("... registration done")
            
        end, function (client, reason)
           print("error in connecting " .. reason)
           node.restart()
    end)
    print ("done")

end)


