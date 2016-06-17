#
#
#
#
import paho.mqtt.client as mqtt
import random
import font
import time



# The callback for when the client receives a CONNACK response from the server.
def on_connect(client, userdata, flags, rc):

    print("Connected with result code "+str(rc))

    # Subscribing in on_connect() means that if we lose the connection and
    # reconnect then subscriptions will be renewed.
    client.subscribe("home/esp03/sensors/interruptor")


# The callback for when a PUBLISH message is received from the server.
def on_message(client, userdata, msg):
    scroll(client2, "quentin !!! ;-)")
    return

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
# construct a char representation
# 
def charSequence(char,color):
    e = font.printChar(char)
    return toLED(e,color)

def toLED(buffer, color):
    s = ""
    for i in range(7,-1,-1):
        for j in range(0,8):
            b = (buffer[j][i:i+1]) == "X"
            s = (s + color) if b else (s + chr(0)+chr(0) + chr(0))

    return s

def shiftBufferLeft(buffertoshift,enteringelements,outelements):
    assert type(buffertoshift) == list
    assert type(enteringelements) == list    
    assert len(buffertoshift) == 8
    assert len(enteringelements) == 8
    assert type(outelements) == list

    for i in range(0,8):
        s = buffertoshift[i]
        c = s[0:1]
	r = s[1:8]
        buffertoshift[i] = r + enteringelements[i] 
        outelements[i] = c

def scroll(client, message):
    print("message to scroll :" + str(message))
    buffer = []
    for i in range(0,8):
        buffer.append("        ")

    displayed = [buffer]
    for m in message:
        displayed.append(font.printChar(ord(m)))    

    # print(displayed)

    for i in range(0,8*(len(message) + 1)):
        a=[" "," "," "," "," "," "," "," "]
        for j in range(len(message),-1,-1):
            b=[" "," "," "," "," "," "," "," "]
            shiftBufferLeft(displayed[j],a,b)
            a=b
        #print(" display " + str(i))
        #print(displayed)
        m = toLED(displayed[0], chr(30) + chr(0) + chr(0)) 
        client.publish("home/esp03/actuators/led8",m)
	
        time.sleep(0.05)



client = mqtt.Client()
client2 = mqtt.Client()


client.on_connect = on_connect
client.on_message = on_message

client.username_pw_set("USER","PASSWORD")
client.connect("mqtt.net", 1883, 60)

client2.username_pw_set("USER","PASSWORD")
client2.connect("mqtt.net", 1883, 60)


# Blocking call that processes network traffic, dispatches callbacks and
# handles reconnecting.
# Other loop*() functions are available that give a threaded interface and a
# manual interface.

client2.loop_start()
client.loop_forever()

