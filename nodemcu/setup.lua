local module = {}

local function wifi_wait_ip()  
  if wifi.sta.getip()== nil then
    print("IP unavailable, Waiting...")
  else
    tmr.stop(1)
    print("\n====================================")
    print("ESP8266 mode is: " .. wifi.getmode())
    print("MAC address is: " .. wifi.ap.getmac())
    print("IP is "..wifi.sta.getip())
    print("====================================")
    app.start()
  end
end

local function wifi_start()  
  wifi.setmode(wifi.STATION);
  wifi.sta.config(config.SSID,config.SSID_PASS)
  wifi.sta.connect()
  print("Connecting to " .. config.SSID .. " ...")
  tmr.alarm(1, 2500, 1, wifi_wait_ip)
end

function module.start()  
  print("Configuring Wifi ...")
  wifi.setmode(wifi.STATION);
  wifi_start()
end

return module  