# Running agents as service

Sample to install agents launch in systemd services. 

Here is the procedure used ,for testing purpose, to run the agents at boot time (avoiding to run them at every startup)

1 - create the .service file

the .service file must be located in /lib/systemd/system

the file :
```
[Unit]
Description=MqttAgents
After=multi-user.target

[Service]
StandardOutput=console
User=pi
Group=pi
ExecStart=/bin/bash /home/pi/mqttagent/launch_all.sh
WorkingDirectory=/home/pi/
Type=simple
KillMode=none
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target

```


2 - register the service

```
sudo systemctl enable mqttagents.service
```

3 - test the launch

```
sudo systemctl start mqttagents
```

