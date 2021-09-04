

TouchSensor = {}


function TouchSensor:new (o) 
     o = o or {} 
     if not o.name then
         error("name not specified")
     end
     if not o.pad then
        error("pad must be specified")
     end
     if not o.threshold then
        error("threshold must be specified")
     end

     o.callback = nil
     o.value = nil
   
     setmetatable(o, self)
     self.__index = self

     local localo = o
     localo.lasttime = 0
     
     local function touchInterrupt(pad) 
        -- print("touch "..pad)
        local f = localo:getcallback()
        if f ~= nil and pad ~= nil then
            -- f.callback(1)

            
            local u = node.uptime()
            -- print(tostring(u))
            if u < localo.lasttime + 1000000 then
                return
            end
            localo.lasttime = u

            -- print(tostring(pad))
            if pad[0] ~= nil then
                f.callback(1)
            else
                f.callback(0)
            end
            
            
        end

     end
     
     local params = {}
     params.pad = o.pad
     params.cb = touchInterrupt
     params.thres = o.threshold
     params.intrInitAtStart = true
     print("before create")
     o.ts = touch.create(params)
     o.ts:setThres(0, 200)
     o.ts:setTriggerMode(touch.TOUCH_TRIGGER_BELOW )

     -- pulling
   -- o.tmr = tmr.create()
    --o.tmr:alarm(1000,tmr.ALARM_AUTO, function() 
    --     local raw = o.ts:read()
    --     for key,value in pairs(raw) do 
    --        print(key,value) 
    --     end
    --end)
     
     return o
end

function TouchSensor:issensor()
    return true
end


-- define the change callback, 
-- the function is called with (self, state)
function TouchSensor:changecallback(cb)
    self.callback = cb 
end

function TouchSensor:getcallback()
    return self.callback
end

function TouchSensor:getpin() 
    return self.pin
end

function TouchSensor:getname()
    return self.name
end

function TouchSensor:getvalue()
    return self.value
end

return TouchSensor
