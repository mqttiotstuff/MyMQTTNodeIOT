# Led screen display device

An other device setted up, use the LED 8x8 matrix. 
part : [http://www.banggood.com/CJMCU-64-Bit-WS2812-5050-RGB-LED-Driver-Development-Board-p-981678.html](http://www.banggood.com/CJMCU-64-Bit-WS2812-5050-RGB-LED-Driver-Development-Board-p-981678.html)

we used an interruptor for interacting with the device, and coupled a luminosity detector. This could help adjusting the luminosity associated to the led control.

using an old plastic box, this looks like this :

![device.jpg](device.jpg) 

the lex matrix is in front and all the other stuff is in back.


you can have a details view of the ESP connections

## Software components

in this device, we used :

- an ESP 8266 for wifi connection
- a luminosity detector connected to the ADC pin
- an interruptor using an other gpio connection

## Associated Agent 

The led device take the input from the mqtt queue, and display it, an MQTT agent translate the display wishes into the different screen states.

an example implemented in Python, show how to create the corresponding agent to display text on the led screen.

