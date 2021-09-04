
-- ***************************************************************************
-- temperature Module
--
-- Written by Patrice freydiere
--
-- MIT license, http://opensource.org/licenses/MIT
-- ***************************************************************************
--  this module when triggered, push the events

Temperature = {}

function Temperature:new (o) 
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

     -- timer for getting the information
     tmr.alarm(0, 1000, 1, function() 
     
        local f =  o:getcallback() 
        if f ~= nil then
            local status, t, h = dht.read11(o.pin)
            if status == 0 then
                o.value = t -- memoize the temperature
                f.callback(t)
            end
        end 
     end)
     return o
end

function Temperature:issensor()
    return true
end


-- define the change callback, 
-- the function is called with (self, state)
function Temperature:changecallback(cb)
    self.callback = cb 
end

function Temperature:getcallback()
    return self.callback
end

function Temperature:getpin() 
    return self.pin
end

function Temperature:getname()
    return self.name
end

function Temperature:getvalue()
    return self.value
end

return Temperature

