-- ***************************************************************************
-- interrupt Module, implement the interruptor module, sending state of the sensor by using the ISR node interrupt
--
-- Written by Patrice freydiere
--
-- MIT license, http://opensource.org/licenses/MIT
-- ***************************************************************************
--  this module when triggered, push the events

Interruptor = {}

function Interruptor:new (o) 
     o = o or {} 

     if not o.pin then
         error("pin not specified")
     end

     if not o.name then
         error("name not specified")
     end

     o.callback = nil
     
     setmetatable(o, self)
     self.__index = self
    
     gpio.mode(o.pin, gpio.INT, gpio.PULLUP)
     local p = o.pin
     local my = self
     local triggercallback = function(level)
    
        local state = gpio.read(p)
        local f = o:getcallback() 
        --print("trig")
        if f ~= nil then
             print("call")
            o.value = state
            f.callback(state)
        end 
        -- print("end call")
        
    end
     gpio.trig(o.pin, "both", triggercallback)


     
     return o
end

function Interruptor:issensor()
    return true
end


-- define the change callback, 
-- the function is called with (self, state)
function Interruptor:changecallback(cb)
    self.callback = cb 
end

function Interruptor:getcallback()
    return self.callback
end

function Interruptor:getpin() 
    return self.pin
end

function Interruptor:getname()
    return self.name
end

function Interruptor:getvalue()
    return self.value
end

return Interruptor

