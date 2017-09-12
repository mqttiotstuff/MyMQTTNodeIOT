
#
# MQTT agent to measure the freebox wifi device emitting power
# permit to interpolate the device position
#



import paho.mqtt.client as mqtt
import random
import time
import re
import ConfigParser
import os.path

import sys
import traceback

config = ConfigParser.RawConfigParser()


CONNECTION_ROOT = "home/agents/freeboxconnection"


import freebox
import json
import time
import string


#############################################################
## MAIN

conffile = os.path.expanduser('~/.mqttagents.conf')
if not os.path.exists(conffile):
   raise Exception("config file " + conffile + " not found")

config.read(conffile)

username = config.get("agents","username")
password = config.get("agents","password")
mqttbroker = config.get("agents","mqttbroker")

client2 = mqtt.Client()

# client2 is used to send time oriented messages, without blocking the receive one
client2.username_pw_set(username, password)
client2.connect(mqttbroker, 1883, 60)


# Blocking call that processes network traffic, dispatches callbacks and
# handles reconnecting.
# Other loop*() functions are available that give a threaded interface and a
# manual interface.

client2.loop_start()

app_id = "fr.freebox.dom" 
j = json.load(open("result_auth"))
app_token = str(j["result"]["app_token"]) # freebox don't like unicode

f = freebox.FbxApp(app_id,app_token)

cnx_reconnect = 100

while True:
    time.sleep(1)
    try:
	# reconnect if needed
        cnx_reconnect = cnx_reconnect - 1
        if cnx_reconnect < 0:
            f = freebox.FbxApp(app_id,app_token)
            cnx_reconnect = 100

	# query the box
	ap = f.com("/connection")['result']

        for k,v in ap.items():
	    client2.publish(CONNECTION_ROOT + "/" + k , str(v))

    except Exception as e:
        exc_type, exc_value, exc_traceback = sys.exc_info()
        traceback.print_tb(exc_traceback)


