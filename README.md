# Home-Security-by-Pi
Description on how I configured the installation and Security of my Raspberry Pi and how I keep it fit for use and purpose.

**Table of Contents**
- Introduction
- [1 - Installation](https://github.com/teusink/Home-Security-by-Pi/blob/master/1-Installation.md)
- [2 - Configuration](https://github.com/teusink/Home-Security-by-Pi/blob/master/2-Configuration.md)
- [3 - Hardening](https://github.com/teusink/Home-Security-by-Pi/blob/master/3-Hardening.md)
- [4 - Maintenance](https://github.com/teusink/Home-Security-by-Pi/blob/master/4-Maintenance.md)

# Introduction
The goal of this project is to make a secure (or at least secure within a reasonable amount of effort) Raspberry Pi with the following features: Pi-Hole DNS-resolver, DNSSEC, DHCP, and OpenVPN-server. It is possible that by gaining new insights features are either removed or added.

My other goal is to gain a good understanding on DNS, Hardening and other Security-related aspects concerning Network Security. I feel that as a Lead Information Security Officer it is important to upkeep (general) knowledge about Technology.

# The Hardware
The hardware I use exists of the following components:
- Raspberry Pi 3 Model B 1GB
- SanDisk Ultra SDHC card - 16GB
- Pi-Blox Case for Raspberry Pi - Black

**How it looks :)**

![Pi-Blox Case](https://3.bp.blogspot.com/-35IKtcxvbds/Wh_wxulKH_I/AAAAAAAC-qM/ZFdeJaGM5j0Rzs1o9cJ1gWrJ4--BZcxAQCPcBGAYYCw/s1600/Pi-Blox-Case.jpg)

# The Software
The base image that is used to build this guid is the following:
- Image with desktop based on Debian Stretch
- Version: September 2017
- Release date: 2017-09-07
- Kernel version: 4.9

# Steps to take
1. Install Pi - [Chapter 1]
1. Configure Pi - [Chapter 2]
1. Remove software - [Chapter 3]
1. Update/upgrade Pi - [Chapter 4]
1. Install Pi-hole - [Chapter 1]
1. Install PiVPN - [Chapter 1]
1. Configure Pi-hole - [Chapter 2]
1. Configure PiVPN - [Chapter 2]
1. Rest of hardening - [Chapter 3]

# General Informational Sources
- StackExchange: https://raspberrypi.stackexchange.com/
- Raspberry Pi NOOBS: https://github.com/raspberrypi/noobs
- Pi-hole Wiki: https://github.com/pi-hole/pi-hole/wiki
- Pi-hole OpenVPN-server Wiki: https://github.com/pi-hole/pi-hole/wiki/Pi-hole---OpenVPN-server

# Licensing
All the licensing and copyrights of any of the code and applications belong to their respective owners. All other coding falls under the MIT-license: https://github.com/teusink/Home-Security-by-Pi/blob/master/LICENSE

Feel free to remake, reshape and reuse whatever you like or need.
