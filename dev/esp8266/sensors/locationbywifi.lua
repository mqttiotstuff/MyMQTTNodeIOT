-- ***************************************************************************
-- Send RSSI information about visible wifi ep, on the module
-- permit to make indoor location of the device by using the current
-- wifi spots
--
-- This module is quite incompatible with mqtt wifi usage
--
--
-- Written by Patrice freydiere
--
-- MIT license, http://opensource.org/licenses/MIT
-- ***************************************************************************


LocationByWifi = {}


function LocationByWifi:new (o) 
     o = o or {} 

     if not o.name then
         error("name not specified")
     end

     o.callback = nil
     o.value = nil
     
     setmetatable(o, self)
     self.__index = self


     o.tmr = tmr.create()
     -- timer for getting the information
     o.tmr:alarm(15000,tmr.ALARM_AUTO, function() 
    

        local f =  o:getcallback() 
            if f ~= nil then
            local function listap(t)
                local k,v
                for k,v in pairs(t) do
                    f.callback(k..":"..v)
                end
            end
            wifi.sta.getap(listap)
        end 

     end)
     
     return o
end

function LocationByWifi:issensor()
    return true
end


-- define the change callback, 
-- the function is called with (self, state)
function LocationByWifi:changecallback(cb)
    self.callback = cb 
end

function LocationByWifi:getcallback()
    return self.callback
end

function LocationByWifi:getpin() 
    return self.pin
end

function LocationByWifi:getname()
    return self.name
end

function LocationByWifi:getvalue()
    return self.value
end

return LocationByWifi
