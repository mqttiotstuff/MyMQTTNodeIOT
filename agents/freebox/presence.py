
#
# Mqttagent that measure the existance of several wifi id,  
#
#



import paho.mqtt.client as mqtt
import random
import time
import re
import ConfigParser
import os.path
import freebox
import json

config = ConfigParser.RawConfigParser()


PRESENCE = "home/agents/presence"


#############################################################
## MAIN

conffile = os.path.expanduser('~/.mqttagents.conf')
if not os.path.exists(conffile):
   raise Exception("config file " + conffile + " not found")

config.read(conffile)


username = config.get("agents","username")
password = config.get("agents","password")
mqttbroker = config.get("agents","mqttbroker")

aliases = config.get("presence","aliases")
if not aliases:
   raise Exception("presence key not found")

aliases = json.loads(aliases)
print("aliases for presence :" + str(json.dumps(aliases)))


client2 = mqtt.Client()

# client2 is used to send events to wifi connection in the house 
client2.username_pw_set(username, password)
client2.connect(mqttbroker, 1883, 60)


# Blocking call that processes network traffic, dispatches callbacks and
# handles reconnecting.
# Other loop*() functions are available that give a threaded interface and a
# manual interface.

client2.loop_start()



# connect to freebox

app_id = "fr.freebox.dom" 
j = json.load(open("result_auth"))
app_token = str(j["result"]["app_token"]) # freebox don't like unicode


f = freebox.FbxApp(app_id,app_token)

def listActualConnectedDevices():
   # list connected devices
   ap = f.com("wifi/ap/0/stations")['result']
   # extract the mac / name
   couplelist = map(lambda x:(x['mac'],x['hostname']), ap)
   return toHash(couplelist)

def toHash(l):
   h = {}
   if not l is None:
      for (m,host) in l:
         h[m]= host
   return h

lastActivated = None

def sendWithAlias(m,host, state):
   

   if aliases.has_key(m):
      host = aliases[m]

   client2.publish(PRESENCE + "/" + host, str(state), qos=1)

reconnect = 100

while True:
   time.sleep(3)
   reconnect = reconnect - 1
   if reconnect < 0:
      f = freebox.FbxApp(app_id,app_token) 
      reconnect = 100
   old = lastActivated
   lastActivated = listActualConnectedDevices()
   if old != None:
      # compare the new and missing
      for k in lastActivated:
         if not old.has_key(k):
            sendWithAlias(k, lastActivated[k],1)

      for k in old:
         if not lastActivated.has_key(k):
            sendWithAlias(k, old[k],0)

   



