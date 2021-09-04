
-- ***************************************************************************
-- BMP280 Module (Temperature / Humidity / Pressure)
--
-- Written by Patrice freydiere
--
-- MIT license, http://opensource.org/licenses/MIT
-- ***************************************************************************
--  this module when triggered, push the events

BME = {}

local BMP280 = require("bme280")

function BME:new (o) 
     o = o or {} 

     if not o.sda then
         error("sda pin not specified")
     end

     if not o.scl then
         error("scl pin not specified")
     end
     if not o.name then
         error("name not specified")
     end

     o.callback = nil
     
     setmetatable(o, self)
     self.__index = self

     BMP280.init(o.sda,o.scl)


     -- timer for getting the information
     tmr.alarm(0, 2310, tmr.ALARM_AUTO, function() 
        -- print("read temp")
        BMP280.read()
        local f =  o:getcallback() 
        if f ~= nil then
            o.value = "T"..tostring(BMP280.temperature)..",H"..tostring(BMP280.humidity)..",P"..tostring(BMP280.pressure)
                -- print("temperature " .. tostring(status))
            f.callback(o.value)
        end 
     end)
     return o
end

function BME:issensor()
    return true
end


-- define the change callback, 
-- the function is called with (self, state)
function BME:changecallback(cb)
    self.callback = cb 
end

function BME:getcallback()
    return self.callback
end

function BME:getpin() 
    return self.pin
end

function BME:getname()
    return self.name
end

function BME:getvalue()
    return self.value
end

return BME

