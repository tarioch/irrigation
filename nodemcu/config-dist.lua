local module = {}

module.SSID = "myWifiSsid"
module.SSID_PASS = "supersecret"

module.HOST = "ipOfMqttHost"
module.PORT = 1883
module.USER = "userForMqtt"
module.PASS = "passwordForMqtt"
module.ID = "client_" .. node.chipid()

module.ENDPOINT = "nodemcu/relay1/"

module.MAX_RELAY = 7

return module  
