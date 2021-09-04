-- ***************************************************************************
-- Serial Comm Module
--
-- Written by Patrice freydiere
--
-- MIT license, http://opensource.org/licenses/MIT
-- ***************************************************************************

-- init UART
uart.setup(0,115200, 8, uart.PARITY_NONE, uart.STOPBITS_1, 0)

do
  -- cache
  local shift = table.remove
  -- factory
  local make_publisher = function()
    local queue = { }
    local is_sending = false
    local currentcallback = nil
    local function send()
      if #queue > 0 and not is_sending then
        --print("sendc")
        is_sending = true
        local tp = shift(queue, 1)
          -- print("sending " .. tp[1])
        -- print(tp[2])
        -- print("publish " .. tp[1] ..":" .. tp[2])
        
        currentcallback = tp[2]
        uart.write(0,string.format("S%03d%s\n", string.len(tp[1]), tp[1]))
       
      end
    end

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
                         local message = string.sub(s,5,5 + l - 1)
                         -- print("extracted message" .. l .. message)
                         if string.len(message) == l then
                             
                             if currentcallback ~= nil then
                                
                                 currentcallback(message)
                                 -- print("ok")
                             else 
                                 -- print("null call back")
                             end
                             currentcallback = nil
                             is_sending = false
                         else 
                            -- print("message ".. message .. " aborted")
                         end
                     else
                         -- print("bad message")
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
         
    return function(command, callbackfunction)
      -- closure for keeping the values (otherwise we have null values)
      local ltopic = command
      local lvalue = callbackfunction
      queue[#queue + 1] = { ltopic, lvalue }
      send()
    end
  end
  -- expose
  return make_publisher
end
