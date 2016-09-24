#Precision Temperature / Pression / Humidity sensor

This sensor use the BMP280 chipset to measure Temperature / Pression and Humidity

**Parts :**

- Wemos ESP8266 emmbeded board, 
- [BMP280 I2C Module](https://cdn-shop.adafruit.com/datasheets/BST-BMP280-DS001-11.pdf)
- 3,3 regulator
- 2 lipo 3,7V Batteries - 3000 mAh

The device looks like this :

![device.jpg](device.jpg) 


##Software components

in this device, we used :

- an ESP 8266 for wifi connection
- the BME/BMP280 module using the myMQTTIoT lua stack

this module is a wrapper to [https://github.com/avaldebe/AQmon](https://github.com/avaldebe/AQmon) BMP 280 module



