-- ***************************************************************************
-- Objects, object responsible of all the device objects, 
-- centralize the events and subscribes
--
-- Written by Patrice freydiere
--
--   Adjusted on node MCU esp32 : 2020-04
--
-- MIT license, http://opensource.org/licenses/MIT
-- ***************************************************************************



Objects = { }

-- construct a new object, with m
function Objects:new (baseMQTTPath, m)
     o = {objects={}, baseMQTTPath = baseMQTTPath}
     o.m = m
     o.pub = dofile("mqtt-queue-helper.lua")(m)
     setmetatable(o, self)
     self.__index = self
     return o
end

-- this function is called by a sensor, when something changed
-- it can be in ISR, so we are just able to push the notification
-- in queue to send it
function Objects:sensorchanged(sensor, value)

    if self.pub and value ~= nil then

       --print("sensor ".. sensor:getname() .. " changed :" .. tostring(value))
        
       -- enqueue or send the message
       self.pub(self.baseMQTTPath .. "/sensors/" .. sensor:getname(),value)
      
    end
end


-- this function register the callback functions
-- for all sensors, then they can callback to signal
-- a value changed
function Objects:register()
     local s = ""
     for k,v in pairs(self.objects) do
        if v.issensor then
            --has a is sensor method
            if v:issensor() then
                local r = v
                local this = self
                local structCallback = { callback = function(value)
                    -- print("in callback")
                    this:sensorchanged(r,value)         
                end } 
                v:changecallback(structCallback)
            else 
                local r = v
                -- this is an actuator
                self.m:subscribe(self.baseMQTTPath .. "/actuators/" .. r:getname(),
                                    0, function(conn, topic, message) 
         
                end)
            end
           
        end
        if string.len(s) > 0 then
            s = s .. ","
        end
        s = s .. v:getname()
     end
     print("send hello to ".. self.baseMQTTPath)
     self.pub(self.baseMQTTPath,s) 

     -- on message received event (especially for actuators)
     self.m:on("message", function(conn, topic, data) 
     local datasnapshot = data
     local topicsnapshot = topic
     
     -- print(topic .. ":" , topic) 
     local k,v
     for k,v in pairs(self.objects) do
        -- watch for actuators
        if v.issensor and not v:issensor() then
            -- does the message is for v ?
            if topicsnapshot == self.baseMQTTPath .. "/actuators/" .. v:getname() then

                    -- print("topic")
                    -- print(topic)
                    -- print("message:")
                    -- print(message)

                    -- print("evaluate")
                    -- received message
                    
                    -- print("provide")
                    -- print(datasnapshot)
                    v:providevalue(datasnapshot)
                        
                    
            end --topic
          end -- sensor  
        end -- for
      
    end) -- on



     
     
end


-- add sensor or actuator
function Objects:add(o)
     local n = o:getname()
     self.objects[n] = o
     print("added ".. n)
end

-- list sensors and actuators
function Objects:list()
    l = {}
    for k,v in pairs(self.objects) do 
        table.insert(l, k) 
        -- print( "added in list ".. k)
    end
    return l
end


return Objects


