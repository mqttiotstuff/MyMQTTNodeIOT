-- ***************************************************************************
-- send technical information about the device, to monitor health
--
-- Written by Patrice freydiere
--
--  Adjusted on node MCU esp32 : 2020-04
--
-- MIT license, http://opensource.org/licenses/MIT
-- ***************************************************************************


Health = {}


function Health:new (o) 
     o = o or {} 

     o.callback = nil
     o.value = nil
     o.name = "health"
     
     setmetatable(o, self)
     self.__index = self


     o.tmr = tmr.create()
     -- timer for getting the information
     o.tmr:alarm(1000,tmr.ALARM_AUTO, function() 
    

        local f =  o:getcallback() 
        f.callback(node.heap())
        
     end)
     
     return o
end

function Health:issensor()
    return true
end


-- define the change callback, 
-- the function is called with (self, state)
function Health:changecallback(cb)
    self.callback = cb 
end

function Health:getcallback()
    return self.callback
end


function Health:getname()
    return self.name
end

function Health:getvalue()
    return self.value
end

return Health
