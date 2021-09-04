
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
 
-- print(node.heap())

local deviceID = P["DEVICEID"];
local baseMQTTPath = "home/" .. deviceID
local broker = P["MQTTBROKER"];
if broker == nil then
    error("no broker config")
end
 

allobjects = nil 

wifi.mode(wifi.STATION, false)
local c = {}
c.ssid = P["SSID"]
c.pwd = P["PWD"]
c.auto = true
wifi.start()
wifi.sta.config(c, false)

-- wifi.sta.autoconnect(1)

-- print("set mode")

-- print(node.heap())

--wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function(t) 
                -- disconnected is launched when load balance
--                print("disconnected " .. t.reason)           
--                if t.reason ~= 8 then
--                    node.restart()
--                end
              
--            end)



print("connecting to "..P["SSID"])
-- wifi.sta.connect()



-- print("connected to wifi")

-- init mqtt client with keepalive timer 120sec
local m = mqtt.Client(P["MQTTCLIENTID"], 100, deviceID, deviceID)



-- setup Last Will and Testament (optional)
-- Broker will publish a message with qos = 0, retain = 0, data = "offline" 
-- to topic "/lwt" if client don't send keepalive packet
m:lwt(baseMQTTPath .. "/status", "offline", 0, 0)



function init() 
    print("connected to mqtt,  init the objects ")

    allobjects = Objects:new(baseMQTTPath, m)
    C.hardwardConfigure(allobjects)
    
    -- print("registering ...")
    allobjects:register()
    -- print("... registration done")
    print("done")
end


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


----------------------------------------------------------
-- main


wifi.sta.on("got_ip", function(event, infos)
    print("connected to wifi")
    
    print ("connect to mqtt " .. broker)

    m:connect(broker, 1883, 0, function(client)

        print("connected to mqtt broker "..tostring(broker)) 


        print(node.heap())
        init()

        
    
    
    end)
  

end)

wifi.sta.on("disconnected", function(event)
    node.restart()
end)


