# Running agents as service



This is someting trinky to run script at startup from systemd, especially if there are bash scripts / python scripts.

here is the procedure i used for testing purpose to run the agents at boot time (avoiding to run them at every startup)

1 - create the .service

here is an example of a unique script running, remember this is not a production ready procedure as the process is not monitored in case of failure, systemd is able to rerun the process if it fails.



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



copy the .service file to /lib/systemd/system

2 - register the service

```
sudo systemctl enable mqttagents.service
```

3 - test the run