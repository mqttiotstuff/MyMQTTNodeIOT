
#
# MQTT agent to manage a LED strip, with smooth transitions
#
#



import paho.mqtt.client as mqtt
import random
import time
import re
import ConfigParser
import os.path

config = ConfigParser.RawConfigParser()


LEDSTRIPPATH = "home/esp04/actuators/ledstrip"

rr,rg,rb = 0,0,0

# The callback for when the client receives a CONNACK response from the server.
def on_connect(client, userdata, flags, rc):

    global LEDSTRIPPATH
    print("Connected with result code "+str(rc))

    # Subscribing in on_connect() means that if we lose the connection and
    # reconnect then subscriptions will be renewed.
    client.subscribe("home/agents/smoothlights")
    client.subscribe(LEDSTRIPPATH)


def readrgbvalues(s):
   # read the value
   match = re.search("([0-9]+),([0-9]+),([0-9]+)",s)
   if not match:
      return
   # make the animation
   r = int(match.group(1))
   g = int(match.group(2))
   b = int(match.group(3))
   return r,g,b

issending = False

def id(d):
   return d

def easing(d):
   return d*d

evolution=easing



# The callback for when a PUBLISH message is received from the server.
def on_message(client, userdata, msg):
   global LEDSTRIPPATH
   global rr,rg,rb
   global issending

   if msg.topic == LEDSTRIPPATH and not issending:
      rr,rg,rb = readrgbvalues(msg.payload)

      

   # print str(msg)

   if msg.topic == "home/agents/smoothlights":
      # read the rgb values
      try:
         print("read the value")
         r,g,b = readrgbvalues(msg.payload)

         maxsteps = 50
         issending = True
         for i in range(0,maxsteps):
            ri = int(float(r-rr)* evolution(float(i)/maxsteps) + rr)
            gi = int(float(g-rg)* evolution(float(i)/maxsteps) + rg)
            bi = int(float(b-rb)* evolution(float(i)/maxsteps) + rb)
            values = str(ri) + "," + str(gi) + "," + str(bi)

            # print("send values " + values)
            client2.publish(LEDSTRIPPATH,values)
            time.sleep(0.020)
       
         values = str(r) + "," + str(g) + "," + str(b)
         client2.publish(LEDSTRIPPATH,values)

         rr = r
         rg = g 
         rb = b 


      except Exception as e:
         print(str(e))
      finally:
         issending = False

   return



conffile = os.path.expanduser('~/.mqttagents.conf')
if not os.path.exists(conffile):
   raise Exception("config file " + conffile + " not found")

config.read(conffile)



username = config.get("agents","username")
password = config.get("agents","password")
mqttbroker = config.get("agents","mqttbroker")



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

