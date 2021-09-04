
-- ***************************************************************************
-- 8 LEDS - WS2812 Module
-- module is connected to GPIO2 (0) - using the UART
--
-- Written by Patrice freydiere
--
-- MIT license, http://opensource.org/licenses/MIT
-- ***************************************************************************

Led8 = {}

function Led8:new (o) 
     o = o or {} 

     if not o.name then
         error("name not specified")
     end

     if not o.leds then
        o.leds = 8
     end

     o.value = ""
    
     setmetatable(o, self)
     self.__index = self
    
     ws2812.init()
     ws2812.write(string.rep(string.char(0),3*o.leds))
     return o
end

function Led8:issensor()
    return false
end

-- message received for changing the value
function Led8:providevalue(v)
    -- print("changed value")
    -- print(v)
    if v == nil then
       ws2812.write(string.rep(string.char(0),3*self.leds))
    else 
        if type(v) == "string" then
            if string.len(v) == 0 then
                ws2812.write(string.rep(string.char(0),3*self.leds))
            else
                ws2812.write(v) 
            end
            self.value = v
        end
    end
end

-- get name
function Led8:getname()
    return self.name
end

-- get the current value
function Led8:getvalue()
    return self.value
end

return Led8

