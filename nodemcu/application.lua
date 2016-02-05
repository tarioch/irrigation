local module = {}  
m = nil

local function register_myself()
    local topics = {}
    for i=0, config.MAX_RELAY, 1
    do
        local topic = config.ENDPOINT .. i .. "/command"
        print("Registering...")    
        m:subscribe(topic,0,function(conn)
            print("Successfully subscribed to topic")
        end)
    end
end

local function handleCommand(relay, data)
    if data == "1" then
        gpio.write(relay, gpio.LOW)
        m:publish(config.ENDPOINT .. relay .. "/state","1",0,1)
    elseif data == "0" then
        gpio.write(relay, gpio.HIGH)
        m:publish(config.ENDPOINT .. relay .. "/state","0",0,1)
    else
        print("unknown data " .. data)
    end
end

local function mqtt_start()  
    m = mqtt.Client(config.ID, 120, config.USER, config.PASS, 1)

    m:lwt(config.ENDPOINT .. "state", "dead", 0, 1)

    m:on("message", function(conn, topic, data) 
      if data ~= nil then
        print(topic .. ": " .. data)
        relay = string.match(topic, "/(%d+)/command$")
        handleCommand(relay, data)
      end
    end)

    print("Connecting to broker...")
    m:connect(config.HOST, config.PORT, 0, function(con) 
        print("Connected")
        register_myself()
        m:publish(config.ENDPOINT .. "state","online",0,1)
    end) 
end

local function reset_gpio()
    for i=0, config.MAX_RELAY, 1
    do
        gpio.mode(i, gpio.OUTPUT)
        gpio.write(i, gpio.HIGH)
    end
end

function module.start()  
    reset_gpio()
    mqtt_start()
end

return module  