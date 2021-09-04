-- ***************************************************************************
-- Send RSSI information about visible wifi ep, on the module
-- permit to make indoor location of the device by using the current
-- wifi spots
--
-- Written by Patrice freydiere
--
--  Adjusted on node MCU esp32 : 2020-04
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
     o.tmr:alarm(10000,tmr.ALARM_AUTO, function() 
    

        local f =  o:getcallback() 
            if f ~= nil then
            local function listap(err, t)
                if err ~= nil then
                   print("scan failed")
                   return
                end
                local k,v,i,l
               
                if t == nil then
                    return
                end
               
               for i,v in ipairs(t) do
                   -- print(v["channel"] .. "," .. v["bssid"] .. "," .. v["rssi"] )
                   
                   
                  -- f.callback("test")
                   f.callback(v["ssid"] ..":" .. v["channel"] .. "," .. v["bssid"] .. "," .. v["rssi"] )
                   --for k,l in pairs(v) do
                   --   print(k .. ":" .. l)
                     
                   --end
                   
               end
                
            end
            wifi.sta.scan({
            },listap)
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
