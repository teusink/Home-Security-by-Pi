**Table of Contents**
- [Introduction](https://github.com/teusink/Home-Security-by-Pi/blob/master/README.md)
- 1 - Installation
  - [1.1 - Raspberry Pi](#raspberry-pi)
  - [1.2 - Pi-hole](#pi-hole)
  - [1.3 - PiVPN (OpenVPN)](#pivpn-openvpn)
- [2 - Configuration](https://github.com/teusink/Home-Security-by-Pi/blob/master/2-Configuration.md)
- [3 - Hardening](https://github.com/teusink/Home-Security-by-Pi/blob/master/3-Hardening.md)
- [4 - Maintenance](https://github.com/teusink/Home-Security-by-Pi/blob/master/4-Maintenance.md)
- [5 - Skipped](https://github.com/teusink/Home-Security-by-Pi/blob/master/5-Skipped.md)
- [6 - Common issues](https://github.com/teusink/Home-Security-by-Pi/blob/master/6-Common-issues.md)

# Installation
In this chapter I will explain the basics I undertook in order to install all the software required. In the chapters Configuration and Hardening I will go more indepth on what has been changed after the installation.

## Installation Sources
Below is a list of sources online I used in order to come to this repo. Thanks for the contributers!
- Raspberry Pi: https://www.raspberrypi.org/downloads/raspbian/
- Pi-hole: https://pi-hole.net/ - `sudo curl -sSL https://install.pi-hole.net | bash`
- PiVPN (OpenVPN): http://www.pivpn.io/ - `sudo curl -L https://install.pivpn.io | bash`

## Information Sources
- Raspberry Pi NOOBS: https://github.com/raspberrypi/noobs
- Pi-hole Wiki: https://github.com/pi-hole/pi-hole/wiki
- Pi-hole OpenVPN-server Wiki: https://github.com/pi-hole/pi-hole/wiki/Pi-hole---OpenVPN-server
- Headless Pi Configuration: https://hackernoon.com/raspberry-pi-headless-install-462ccabd75d0

## Raspberry Pi
- In regard to the base image, I choose that of Raspbian Stretch with Pixel. I am rather tech-savvy, but re-entering the Linux world with shell-only was a bit to much :).
- Concerning the installation itself, I followed the already online and well documented installation guide: https://www.raspberrypi.org/documentation/installation/installing-images/README.md
- When doing a headless configuration, make sure to create the file `ssh` in the `/boot` partition of your Pi from your Windows, Linux or macOS system. When booting, check your DHCP server for the Pi's IP-address and move on from there with SSH.

### Update it after install
Updating is important, but you might want to consider removing non-neccesarry packages first to save download and update time.
- If you want to remove packages first, look for here: https://github.com/teusink/Home-Security-by-Pi/blob/master/3-Hardening.md#removing-software-and-games
- After installation, execute an update first using: `sudo apt-get update && sudo apt-get upgrade -y`

## Pi-hole
- Install Pi-hole with the command: `sudo curl -sSL https://install.pi-hole.net | bash`
- Follow instructions for installation here: https://github.com/pi-hole/pi-hole/#one-step-automated-install

## PiVPN (OpenVPN)
- Install PiVPN server with the command: `sudo curl -L https://install.pivpn.io | bash`
- Follow instructions for installation here: https://www.sitepoint.com/setting-up-a-home-vpn-using-your-raspberry-pi/

# Done
- This part is done now, so do a reboot now: `sudo reboot`
