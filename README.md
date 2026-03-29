# FiveM Artifacts Updater for Linux

FiveM Artifacts Updater is just a shell script (using api call and fallback webscrap) to update your FiveM artifacts to a build number or the last release of artifacts, made for Linux for people with almost no idea of using it.

To auto-update artifacts for you, you should run a cron job.

## Installation
Cd your FXServer directory and

```bash
git clone https://github.com/eth3real-code/auto-updater-fivem-artifacts-linux
```

## Pre-requisites
This script is intended to run with FiveM as a service, there are some people that run FiveM inside a screen (this is not the way to do so). So in order to have this script we need first to have FiveM as a service.

To do that first we need to create the service.
```bash
$ sudo nano /etc/systemd/system/fivem.service
```
We will write the following content in the file.
```bash

[Unit]
Description=FiveM Service
After=network.target

[Service]
ExecStart=/path/to/run.sh #Edit with your FiveM FXServer Directory 
User=fivem # your user
Group=fivem # your group <- usually is you username.

[Install]
WantedBy=multi-user.target
```
Now we have configured our service! Now our FiveM will run as a **service**!

So let's refresh the **systemd** to allow our service to show.

```bash
$ sudo systemctl daemon-reload
```
Service FiveM Quick guide Credits : https://raw.githubusercontent.com/Jonirulah/FiveM-Artifacts-Updater/refs/heads/main/README.md


# Sudo permissions
Your-fivem-os-user ALL=(ALL) NOPASSWD: /bin/systemctl restart fivem.service, /bin/systemctl start fivem.service, /bin/systemctl stop fivem.service # Replaces Your-fivem-os-user with your user!
