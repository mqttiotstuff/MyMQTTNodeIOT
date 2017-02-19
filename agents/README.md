#Agents, 

Associated to devices, here are some agents implemented for the current devices.

Agents are software MQTT provider and consummer adding logics to the sensors, and handling specific features.

In this folder you'll find some examples implemented in Python. Some ajustments / configuration must be done for your own usage as it is not provided yet .



## Configuration for broker and credentials

All agents use a `~/.mqttagents.conf` ini file for defining the mqttbroker and credentials.

to setup .mqttagents.conf : 

```
[agents]
mqttbroker=XXXXXX ; ip or host of the mqttbroker
username=XXXXX   ; broker connection username for agent
pass=XXXXXX		 ; broker connection password
```



## Running agents

Agents are run as processes, mainly using python

mqtt paho library is used , to install it,  see :  https://pypi.python.org/pypi/paho-mqtt/1.2





