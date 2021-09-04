--
-- This module listen to serial commands, and send them on mqtt topics
--

SerialReceiveSensor = {}



function SerialReceiveSensor:new (o) 

     
     -- init UART
     uart.setup(0,115200, 8, uart.PARITY_NONE, uart.STOPBITS_1, 0)
     o = o or {} 
     if not o.name then
         error("name not specified")
     end
     
     o.callback = nil
     
     o.value = nil
      
     uart.on("data","\n", 
        function(data)
          
           local charext = "" 
           if data ~= nil then
               local s = data
         
               while string.len(s) > 0 and string.sub(s,1,1) ~= "S" do
                   s = string.sub(s,2)
               end    
               -- print("transformed " .. s)
               if string.len(s) >= 4 then
                 if string.sub(s,1,1) == "S" then
                     charext = string.sub(s,2,4)   
                     print(charext)          
                     local l = tonumber(charext) 
                     if l ~= nil then 
                         local message = string.sub(s,5)
                         -- print("extracted message" .. tostring(l) .. tostring(message))
                         -- print(string.len(message))
                         if string.len(message) == l + 2 or string.len(message) == l + 1 then -- lf included
                            local f = o:getcallback()
        		            if f ~= nil then
                            print("callback")
                                  f.callback(string.sub(message, 1, l))
                            end
                         else 
                            -- print("message ".. message .. " aborted")
                         end
                     else
                         print("bad message")
                     end
                  else
                     -- print("not starting with S")
                  end
               else 
                   print("message too small")
               end
           end
           
           send() 
         end,0)
   
     setmetatable(o, self)
     self.__index = self

     
     return o
end

function SerialReceiveSensor:issensor()
    return true
end


-- define the change callback, 
-- the function is called with (self, state)
function SerialReceiveSensor:changecallback(cb)
    self.callback = cb 
end

function SerialReceiveSensor:getcallback()
    return self.callback
end

function SerialReceiveSensor:getpin() 
    return self.pin
end

function SerialReceiveSensor:getname()
    return self.name
end

function SerialReceiveSensor:getvalue()
    return self.value
end

return SerialReceiveSensor
