-- ***************************************************************************
-- ADC value transmitter, use the adc input to publish the value every seconds
--
-- Written by Patrice freydiere
--
-- MIT license, http://opensource.org/licenses/MIT
-- ***************************************************************************
--  this module when triggered, push the events

ADC = {}

function ADC:new (o) 
     o = o or {} 

     if not o.name then
         error("name not specified")
     end

     o.callback = nil
     
     setmetatable(o, self)
     self.__index = self

     print("init adc")
     adc.force_init_mode(adc.INIT_ADC)

    

     -- timer for getting the information
     tmr.alarm(1, 1000, tmr.ALARM_AUTO, function() 
    
        local f =  o:getcallback() 
        if f ~= nil then
            local v= adc.read(0)
                -- print(status)
            o.value = v 
            f.callback(tostring(v))
        end 
     end)
 
     
     return o
end

function ADC:issensor()
    return true
end


-- define the change callback, 
-- the function is called with (self, state)
function ADC:changecallback(cb)
    self.callback = cb 
end

function ADC:getcallback()
    return self.callback
end

function ADC:getpin() 
    return self.pin
end

function ADC:getname()
    return self.name
end

function ADC:getvalue()
    return self.value
end

return ADC
