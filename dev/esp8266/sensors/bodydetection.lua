-- ***************************************************************************
-- interrupt Module, implement the interruptor module, sending state of the sensor by using the ISR node interrupt
--
-- Written by Patrice freydiere
--
-- MIT license, http://opensource.org/licenses/MIT
-- ***************************************************************************
--  this module when triggered, push the events

BodyDetect = {}

function BodyDetect:new (o) 
     o = o or {} 

     if not o.name then
         error("name not specified")
     end

     o.callback = nil
     
     setmetatable(o, self)
     self.__index = self

     local bdlast = 0

     print("init body detector")
     adc.force_init_mode(adc.INIT_ADC)



     -- timer for getting the information
     tmr.alarm(0, 100, 1, function() 
    
        local f =  o:getcallback() 
        if f ~= nil then
            local v= adc.read(0)
            local status = (v<400)
            if status ~= bdlast then
                o.value = status 
                bdlast = status
                -- print(status)
                f.callback(tostring(status))
            end
        end 
     end)
 
     
     return o
end

function BodyDetect:issensor()
    return true
end


-- define the change callback, 
-- the function is called with (self, state)
function BodyDetect:changecallback(cb)
    self.callback = cb 
end

function BodyDetect:getcallback()
    return self.callback
end

function BodyDetect:getpin() 
    return self.pin
end

function BodyDetect:getname()
    return self.name
end

function BodyDetect:getvalue()
    return self.value
end

return BodyDetect

