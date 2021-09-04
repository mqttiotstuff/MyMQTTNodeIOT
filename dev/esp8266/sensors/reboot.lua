-- ***************************************************************************
-- reboot Module, implement a soft reset, that can be programmed remotely
--
-- Written by Patrice freydiere
--
-- MIT license, http://opensource.org/licenses/MIT
-- ***************************************************************************
--


Reboot = {}


function Reboot:new (o) 
     o = o or {} 
     o.name= "reboot"

     o.callback = nil
     
     setmetatable(o, self)
     self.__index = self
     
     return o
end

function Reboot:issensor()
    return false
end


-- define the change callback, 
-- the function is called with (self, state)
function Reboot:changecallback(cb)
    self.callback = cb 
end

function Reboot:getcallback()
    return self.callback
end

-- message received for changing the value
function Reboot:providevalue(v)
    if v ~= nil and type(v) == "string" then
        local status = tonumber(v)
        if (status == 1) then 
            node.restart()
        end
    end
end


function Reboot:getname()
    return self.name
end

function Reboot:getvalue()
    return self.value
end

return Reboot

