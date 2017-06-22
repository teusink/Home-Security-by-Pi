# Secure-my-Pi
Description on how I configured the installation and Security of my Raspberry Pi and how I keep it fit for use and purpose.

## Goal
The goal of this project is to make a secure (or at least secure within a reasonable amount of effort) Raspberry Pi with the following features: Pi-Hole DNS-resolver, DNSSEC, DHCP, OpenVPN-server, and DNSCrypt (not sure). It is possible that by gaining new insights features are either removed or added.

My other goal is to gain a good understanding on DNS, Hardening and other Security-related aspects concerning Network Security. I feel that as a Chief Information Security Officer it is important to upkeep (general) knowledge about Technology.

Anything that I create is all done under MIT-license, so please do use it as you see fit. In regard to software created under other licences, those do not change and you need to check them for yourself.

## Installation Sources
- Raspberry Pi: https://www.raspberrypi.org/downloads/raspbian/
- Pi-hole: https://pi-hole.net/ - `curl -sSL https://install.pi-hole.net | bash`
- OpenVPN: http://www.pivpn.io/ - `curl -L https://install.pivpn.io | bash`
- xscreensaver: `sudo apt-get install xscreensaver`

## Informational Sources
- Block Ads Network-wide with A Raspberry Pi-hole (PDF): http://users.telenet.be/MySQLplaylist/pi-hole.pdf

- StackExchange: https://raspberrypi.stackexchange.com/
- Raspberry Pi NOOBS: https://github.com/raspberrypi/noobs
- Pi-hole Wiki: https://github.com/pi-hole/pi-hole/wiki
- Pi-hole OpenVPN-server Wiki: https://github.com/pi-hole/pi-hole/wiki/Pi-hole---OpenVPN-server
- Pi-hole DNSCrypt Wiki: https://github.com/pi-hole/pi-hole/wiki/DNSCrypt

# Installation
In this chapter I will explain the basics I undertook in order to install all the software required. In the chapter Hardening I will go more indepth on what has been changed after the installation.

## Raspberry Pi
- In regard to the base image, I choose that of Raspbian Jessie with Pixel. I am rather tech-savvy, but re-entering the Linux world with root only was a bit to much :).
- Concerning the installation itself, I followed the already online and well documented installation guide: https://www.raspberrypi.org/documentation/installation/installing-images/README.md

## Pi-hole

## OpenVPN

## DNSCrypt

# Hardening & Configuration
Hardening is the process of disabling or uninstalling application, services and hardware which are not used. To be fair, if you really want hardening, use the minimum image without Jessie, but apart from that, you can get it safe enough. So, while you are busy with some configuration work, harden your Pi also.

## Raspberry Pi

- Wifi and Bluetooth are two hardware components that I do not use and which could allow remote access. Therefore, I disabled both.

   Add the lines below in the config.txt file: `sudo nano /boot/config.txt`
   ```
   # Uncomment this to disable WiFi and Bluetooth
   dtoverlay=pi3-disable-wifi
   dtoverlay=pi3-disable-bt
   ```
   Add the lines below in the
   ```
   # disable WLAN
   blacklist brcmfmac
   blacklist brcmutil
   blacklist cfg80211
   blacklist rfkill
   
   # disable Bluetooth
   blacklist btbcm
   blacklist hci_uart
   ```
   And then run this command to disable the Bluetooth service: `sudo systemctl disable hciuart`
- Automatically locking is a handy feature to prevent access when your network is compromised. I used xscreensaver for this: xscreensaver: `sudo apt-get install xscreensaver`
- Because I live in Europe, I like to use a timeserver that resides in Europe.

   Use the lines below to replace the similar ones in the ntp.conf file: `sudo nano /etc/ntp.conf`
   ```
   server 0.europe.pool.ntp.org iburst
   server 1.europe.pool.ntp.org iburst
   server 2.europe.pool.ntp.org iburst
   server 3.europe.pool.ntp.org iburst
   ```
- Make sure you set/change the following default configurations using `sudo raspi-config`
   - Change User Password
   - Hostname
   - Advanced Options: Expand Filesystem
   - 

## Pi-hole

## OpenVPN

## DNSCrypt

# Keeping it updated

## Raspberry Pi

## Pi-hole

## OpenVPN

## DNSCrypt
