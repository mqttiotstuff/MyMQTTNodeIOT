
-- ***************************************************************************
-- Relay Module
--
-- Written by Patrice freydiere
--
-- MIT license, http://opensource.org/licenses/MIT
-- ***************************************************************************

LEDStrip = {}

function LEDStrip:new (o) 
     o = o or {} 

     if not o.pin then
         error("pin not specified")
     end

     if not o.name then
         error("name not specified")
     end

     o.value = "0,0,0"
    
     setmetatable(o, self)
     self.__index = self
   
     pwm.setup(o.pin, 100, 0)
     pwm.start(o.pin) 

     pwm.setup(o.pin + 1, 100, 0)
     pwm.start(o.pin + 1) 
     
     pwm.setup(o.pin + 2, 100, 0)
     pwm.start(o.pin + 2) 

     return o
end

function LEDStrip:issensor()
    return false
end


-- message received for changing the value
function LEDStrip:providevalue(v)
    -- print("changed value")
    -- print(v)
    if v ~= nil and type(v) == "string" then
        -- split the values
        local r,g,b
        for r,g,b in string.gmatch(v, "(%d+),(%d+),(%d+)") do
            pwm.setduty(self:getpin()+1, tonumber(r))
            pwm.setduty(self:getpin(), tonumber(g))
            pwm.setduty(self:getpin()+2, tonumber(b))
        end
        self.value = v
    end
end

-- get configured physical pin
function LEDStrip:getpin() 
    return self.pin
end

-- get name
function LEDStrip:getname()
    return self.name
end

-- get the current value
function LEDStrip:getvalue()
    return self.value
end

return LEDStrip

