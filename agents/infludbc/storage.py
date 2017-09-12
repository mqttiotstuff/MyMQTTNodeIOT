
#
# MQTT agent to manage storage in the influxdb 
#
#



import paho.mqtt.client as mqtt
import random
import time
import re
import ConfigParser
import os.path
import traceback
import urllib
import urllib2


#############################################################
## Global Parmeters

config = ConfigParser.RawConfigParser()

conffile = os.path.expanduser('~/.mqttagents.conf')
if not os.path.exists(conffile):
   raise Exception("config file " + conffile + " not found")

config.read(conffile)

username = config.get("agents","username")
password = config.get("agents","password")
mqttbroker = config.get("agents","mqttbroker")

influxdb = config.get("storage","influxdb")

print "influxdb url :" + str(influxdb)


METEO = "home/agents/meteo"
DETECTOR = "home/esp05/sensors/meteo"
WIFI = "home/esp01/sensors/wifilocation"
WIFIALL = "home/agents/wifi/hostname/"

#############################################################
## Callback

# The callback for when the client receives a CONNACK response from the server.
def on_connect(client, userdata, flags, rc):

    print("Connected with result code "+str(rc))

    # Subscribing in on_connect() means that if we lose the connection and
    # reconnect then subscriptions will be renewed.
    client.subscribe(DETECTOR)
    # client.subscribe(WIFI)
    client.subscribe(WIFIALL + "+")


def sendMeasure(t, device, value):
   global influxdb
   requeststring =  influxdb + "/write?db=home"

   ret = urllib2.Request(requeststring, data= str(t) + ",device=" +str(device) + " value=" + str(value) )
   r = urllib2.urlopen(ret)

def sendWifi(t, mac, value):
   global influxdb
   requeststring =  influxdb + "/write?db=home&rp=aweek"

   ret = urllib2.Request(requeststring, data= str(t) + ",mac=" +str(mac) + " value=" + str(value) )
   r = urllib2.urlopen(ret)





# The callback for when a PUBLISH message is received from the server.
def on_message(client, userdata, msg):

   global METEO


   if msg.topic == DETECTOR:
      try:
         m = re.match("T(\d+.?\d+),H(\d+.?\d+),P(\d+.?\d+)",msg.payload)
         if m:
            (temperature,humidity,pression) = m.group(1),m.group(2),m.group(3) 
	    sendMeasure("temperature","esp05",temperature)
	    sendMeasure("humidity","esp05",humidity)
	    sendMeasure("pression","esp05",pression)

      except Exception,e:
         traceback.print_exc(e) 
         pass
   elif msg.topic == WIFI:
      try:
         m = re.match("([^,]+),(-?\d+),([^,]+),(\d+)", msg.payload)
         if m:
            (mac,signal) = m.group(3), m.group(2)
            sendWifi("wifi",mac,signal)
           
      except Exception,e:
         traceback.print_exc(e)
         pass
   elif len(msg.topic) > len(WIFIALL) and  msg.topic.startswith(WIFIALL):
      try:
         hostname = msg.topic[len(WIFIALL):]
         # print(hostname)
         sendWifi("wifi",hostname.replace(" ","_"),msg.payload)
           
      except Exception,e:
         traceback.print_exc(e)
         pass



#############################################################
## MAIN

client = mqtt.Client()
client2 = mqtt.Client()


client.on_connect = on_connect
client.on_message = on_message

client.username_pw_set(username, password)
client.connect(mqttbroker, 1883, 60)

# client2 is used to send time oriented messages, without blocking the receive one
client2.username_pw_set(username, password)
client2.connect(mqttbroker, 1883, 60)


# Blocking call that processes network traffic, dispatches callbacks and
# handles reconnecting.
# Other loop*() functions are available that give a threaded interface and a
# manual interface.

client2.loop_start()
client.loop_forever()

