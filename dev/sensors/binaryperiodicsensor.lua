-- ***************************************************************************
-- BinarySensor Module, implement a periodic read module, sending state of the sensor 
--
-- Written by Patrice freydiere
--
-- MIT license, http://opensource.org/licenses/MIT
-- ***************************************************************************

BinarySensor = {}

function BinarySensor:new (o) 
     o = o or {} 

     if not o.pin then
         error("pin not specified")
     end

     if not o.name then
         error("name not specified")
     end

     o.callback = nil
     o.value = 0
     
     
     
     setmetatable(o, self)
     self.__index = self
    
     gpio.mode(o.pin,  gpio.INPUT );
        
     local my = self
     o.mytimer = tmr.create()
   
     local triggercallback = function()
        local state = gpio.read(o.pin)
        local f = o:getcallback() 

            if f ~= nil and o.value ~= state then
                
                o.value = state
                
                f.callback(state)
            end 
                
        
     end

         o.mytimer:register(500, tmr.ALARM_AUTO , function (t)
                triggercallback()
                end)
        o.mytimer:start()
    
     return o
end

function BinarySensor:issensor()
    return true
end


-- define the change callback, 
-- the function is called with (self, state)
function BinarySensor:changecallback(cb)
    self.callback = cb 
end

function BinarySensor:getcallback()
    return self.callback
end

function BinarySensor:getpin() 
    return self.pin
end

function BinarySensor:getname()
    return self.name
end

function BinarySensor:getvalue()
    return self.value
end

return BinarySensor

