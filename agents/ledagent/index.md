#Led MQTT Agent

This agent implemented in `Python`, permit to scroll messages on the led 8x8 matrice display. This can be time, or other informations.

In this sample implementation, from a button action event, the scroll starts.

This example, use the `paho.mqtt.client` MQTT client 3.1 implementation, in order to make it work properly with delays between two shift, 2 mqtt connections are use, one for the subscription, one for sending the images on the LED, with delays.

**Notice in the implementation** that the second client use the background network thread. Otherwise the ack / watchdog disconnect the connection.

See it in action on this video : [Video LED Scrolling Agent](https://www.youtube.com/watch?v=oWcosF2_CQw)


