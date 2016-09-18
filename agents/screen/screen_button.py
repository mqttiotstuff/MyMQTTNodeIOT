
#
# MQTT agent to manage a LED screen
#
#
#
#



import paho.mqtt.client as mqtt
import random
import time
import scroll
import fancyfont

import ConfigParser
import os.path

config = ConfigParser.RawConfigParser()


def get_config_item(section, name, default):
    """
    Gets an item from the config file, setting the default value if not found.
    """
    try:
        value = config.get(section, name)
    except:
        value = default
    return value




# The callback for when the client receives a CONNACK response from the server.
def on_connect(client, userdata, flags, rc):

    print("Connected with result code "+str(rc))

    # Subscribing in on_connect() means that if we lose the connection and
    # reconnect then subscriptions will be renewed.
    client.subscribe("home/esp03/sensors/interruptor")
    client.subscribe("home/esp03/sensors/adc")

adccounter = 0

# The callback for when a PUBLISH message is received from the server.
def on_message(client, userdata, msg):
   global adccounter

   # print str(msg)

   if msg.topic == "home/esp03/sensors/interruptor" and str(msg.payload) == "0":
       displayTime()
       # c = random.randint(0,16*16)
       # client2.publish("home/esp03/actuators/led8", scroll.toLED(fancyfont.printChar(c),chr(30) + chr(0) + chr(0)))


   if msg.topic == "home/esp03/sensors/adc":
       v = int(msg.payload)
       if v > 500:
          c = random.randint(0,16*16-1)
	  client2.publish("home/esp03/actuators/led8", scroll.toLED(fancyfont.printChar(c),chr(30) + chr(0) + chr(0)))
	  # fillscreen(client2, 127, 127, 0, 1/20.0) 

   return

#
# launch the led time display
#
def displayTime():

    # compute time
    t = time.strftime("%H:%M")
    scroll.scroll(client2, t, "home/esp03/actuators/led8")

#
# fill the screen with a custom color
#
def fillscreen(client,r,g,b,factor=1.0):
    t = []

    for i in range(0,64):
        t.append(r * factor)
	t.append(g * factor)
        t.append(b * factor)

    s = ""
    for i in range(0,len(t)):
        s = s + chr(int(t[i]))

    client.publish("home/esp03/actuators/led8" ,s)


#
# Start the main logic
#



conffile = os.path.expanduser('~/.mqttagents.conf')
if not os.path.exists(conffile):
    raise Exception("config file " + conffile + " not found")

config.read(conffile)


client = mqtt.Client()
client2 = mqtt.Client()

client.on_connect = on_connect
client.on_message = on_message


username = config.get("agents","username")
password = config.get("agents","password")
mqttbroker = config.get("agents","mqttbroker")

client.username_pw_set(username,password)
client.connect(mqttbroker, 1883, 60)

client2.username_pw_set(username,password)
client2.connect(mqttbroker, 1883, 60)


# Blocking call that processes network traffic, dispatches callbacks and
# handles reconnecting.
# Other loop*() functions are available that give a threaded interface and a
# manual interface.

client2.loop_start()
client.loop_forever()

