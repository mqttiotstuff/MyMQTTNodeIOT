
-- ***************************************************************************
-- Relay Module
--
-- Written by Patrice freydiere
--
-- MIT license, http://opensource.org/licenses/MIT
-- ***************************************************************************

Relay = {}

function Relay:new (o) 
     o = o or {} 

     if not o.pin then
         error("pin not specified")
     end

     if not o.name then
         error("name not specified")
     end

     o.value = 0
    
     setmetatable(o, self)
     self.__index = self
    
     gpio.mode(o.pin, gpio.OUTPUT)
     gpio.write(o.pin, o.value)

     
     return o
end

function Relay:issensor()
    return false
end

-- message received for changing the value
function Relay:providevalue(v)
    print("changed value")
    print(v)
    if v ~= nil and type(v) == "string" then
        local status = tonumber(v)
        if (status == 0 or status == 1) then 
    
             gpio.mode(self:getpin(), gpio.OUTPUT)
             gpio.write(self:getpin(), status)
            
            self.value = status

            
        end
    end
end

-- get configured physical pin
function Relay:getpin() 
    return self.pin
end

-- get name
function Relay:getname()
    return self.name
end

-- get the current value
function Relay:getvalue()
    return self.value
end

return Relay

