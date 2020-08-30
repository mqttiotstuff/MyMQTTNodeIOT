# Ambiant Led strip lights

An other device setted up, use a RGB led strip

Parts : 

- Weemos ESP8266 emmbeded board, 
- Led strips, and monted on a 2,5 m wooden block
- 3 power transistor (TO201) using the pwm to power the RGB Lights channel
- a 12V power supply 3A

we also used an interruptor for interacting with the device.

The device looks like this :

![device.jpg](device.jpg) 

the lex matrix is in front and all the other stuff is in back.

you can have a details view of the ESP connections

## Software components

in this device, we used :

- an ESP 8266 for wifi connection
- a ledstrip PWM actuator, using the myMQTTIoT lua stack
- V2: Added Body sensor detector
- V2: Added switch

## Associated Agent - smooth light agent

The agent make transitions to smooth the lightening and darking, and also led color transitions.


