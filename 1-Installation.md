# Installation
In this chapter I will explain the basics I undertook in order to install all the software required. In the chapter Hardening I will go more indepth on what has been changed after the installation.

## Installation Sources
- Raspberry Pi: https://www.raspberrypi.org/downloads/raspbian/
- Pi-hole: https://pi-hole.net/ - `sudo curl -sSL https://install.pi-hole.net | bash`
- OpenVPN: http://www.pivpn.io/ - `sudo curl -L https://install.pivpn.io | bash`

## Raspberry Pi
- In regard to the base image, I choose that of Raspbian Jessie with Pixel. I am rather tech-savvy, but re-entering the Linux world with root only was a bit to much :).
- Concerning the installation itself, I followed the already online and well documented installation guide: https://www.raspberrypi.org/documentation/installation/installing-images/README.md

## Pi-hole
- Install Pi-hole with the command: `sudo curl -sSL https://install.pi-hole.net | bash`
- Follow instructions for installation here: https://github.com/pi-hole/pi-hole/#one-step-automated-install

## OpenVPN
- Install OpenVPN server with the command: `sudo curl -L https://install.pivpn.io | bash`
- Follow instructions for installation here: https://www.sitepoint.com/setting-up-a-home-vpn-using-your-raspberry-pi/

## Done
- This part is done now, so do a reboot now: `sudo reboot`
