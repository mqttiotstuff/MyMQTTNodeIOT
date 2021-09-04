-- ***************************************************************************
-- Serial Sensor Module
--
-- Written by Patrice freydiere
--
-- MIT license, http://opensource.org/licenses/MIT
-- ***************************************************************************

SerialSensor = {}

function SerialSensor:new (o) 
     o = o or {} 

     if not o.serial then
         error("serial not specified")
     end

     if not o.name then
         error("name not specified")
     end

     o.value = 0
     
     setmetatable(o, self)
     self.__index = self

     local ser = o.serial

     -- TEMPERATURE(Q)|HUMIDITY(Q)|LIGHT(QW)|SOIL(Q)
     o.tmr = tmr.create()
     -- timer for getting the information
     o.tmr:alarm(10000,tmr.ALARM_AUTO, function() 
        -- print("send")
      
        o.serial("QUERY-TEMPERATURE", function(resulttemp)
           --  print("received ...")
            local r1 = resulttemp
           -- print("temperature result")
             o.serial("QUERY-HUMIDITY",function(resulth)
                local r2 = resulth
               -- print("humidity result")
                o.serial("QUERY-LIGHT", function(resultl)
                    local r3 = resultl
                    -- print("light result")
                    o.serial("QUERY-SOIL", function(results)
                    -- print("soil result")
                            local f =  o:getcallback() 
                            if f ~= nil then
                            -- print("send to mqtt")
                                f.callback(r1 .. "|" .. r2 .. 
                                      "|" .. r3 .. "|" .. results)
                                       
                            end
                   end)
                end)
             end)


        end)

      
     end)
     
     return o
end

function SerialSensor:issensor()
    return true
end




-- define the change callback, 
-- the function is called with (self, state)
function SerialSensor:changecallback(cb)
    self.callback = cb 
end

function SerialSensor:getcallback()
    return self.callback
end


-- get name
function SerialSensor:getname()
    return self.name
end

-- get the current value
function SerialSensor:getvalue()
    return self.value
end

return SerialSensor
