
-- ***************************************************************************
-- Serial actuator Module
--
-- Written by Patrice freydiere
--
-- MIT license, http://opensource.org/licenses/MIT
-- ***************************************************************************
--


SerialActuator = {}


function SerialActuator:new (o) 
     o = o or {} 
     if not o.name then
        error("name not defined")
     end
     if not o.serial then
        error("serial not defined")
     end
     
     o.callback = nil
     
     setmetatable(o, self)
     self.__index = self
    
     
     return o
end

function SerialActuator:issensor()
    return false
end


-- define the change callback, 
-- the function is called with (self, state)
function SerialActuator:changecallback(cb)
    self.callback = cb 
end

function SerialActuator:getcallback()
    return self.callback
end

-- message received for changing the value
function SerialActuator:providevalue(v)   
    if v ~= nil and type(v) == "string" then
       self.serial("SET-" .. string.upper(self.name) .. v, nil)
    end
end


function SerialActuator:getname()
    return self.name
end

function SerialActuator:getvalue()
    return self.value
end

return SerialActuator

