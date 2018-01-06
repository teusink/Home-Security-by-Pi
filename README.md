# Home-Security-by-Pi
Description on how I configured the installation and Security of my Raspberry Pi and how I keep it fit for use and purpose.

**Table of Contents**
- Introduction
- [1 - Installation](https://github.com/teusink/Home-Security-by-Pi/blob/master/1-Installation.md)
- [2 - Configuration](https://github.com/teusink/Home-Security-by-Pi/blob/master/2-Configuration.md)
- [3 - Hardening](https://github.com/teusink/Home-Security-by-Pi/blob/master/3-Hardening.md)
- [4 - Maintenance](https://github.com/teusink/Home-Security-by-Pi/blob/master/4-Maintenance.md)
- [5 - Skipped](https://github.com/teusink/Home-Security-by-Pi/blob/master/5-Skipped.md)

# Introduction
The goal of this project is to make a secure (or at least secure within a reasonable amount of effort) Raspberry Pi with the following network-features: Pi-Hole DNS-resolver, DNSSEC, DHCP, and OpenVPN-server. It is possible that by gaining new insights features are either removed or added.

My other goal is to gain a good understanding on DNS, Hardening and other Security-related aspects concerning Network Security. I feel that as a Lead Information Security Officer it is important to upkeep (general) knowledge about Technology.

# The Scope
Scope is an important part for this project. Otherwise you can endlessly install security tools and solutions which in the end have a trade-off. This might be resources and performance, but also your own precious time to keep it running :).

The constraints are:
- Apart from OpenVPN, there is nothing that can be reached from the outside world. I always assume that there is a network-firewall present between the Internet, and the actual Pi.
- The networking-services this device delivers are meant to enhance security of other network-connected devices in a non-intrusive manner.
- And although this device delivers services in a (reasonable) secure way, it is not meant to be a device that delivers security services by it self, such as network-scanning and vulnerability scans.
- It is meant for home or small-office use. Larger companies or institutions should look at other solutions to protect their people.

# The Hardware
The hardware I use exists of the following components:
- Raspberry Pi 3 Model B 1GB
- SDHC card Class 10 - 16GB
- Pi-Blox Case for Raspberry Pi - Black

The costs: ~ € 70,-

**How it looks :)**

![Pi-Blox Case](https://3.bp.blogspot.com/-35IKtcxvbds/Wh_wxulKH_I/AAAAAAAC-qM/ZFdeJaGM5j0Rzs1o9cJ1gWrJ4--BZcxAQCPcBGAYYCw/s1600/Pi-Blox-Case.jpg)

# The Software
The base image that is used to build this guid is the following:
- Image with desktop based on Debian Stretch
- Version: November 2017
- Release date: 2017-11-29
- Kernel version: 4.9

# Steps to take
1. Install Pi - [Chapter 1]
1. Configure Pi - [Chapter 2]
1. Remove software & games - [Chapter 3]
1. Update/upgrade Pi and firmware - [Chapter 4]
1. Install Pi-hole - [Chapter 1]
1. Install PiVPN - [Chapter 1]
1. Rest of the configuration - [Chapter 2]
1. Rest of the hardening - [Chapter 3]
1. Rest of the maintenance - [Chapter 4]

# General Informational Sources
- StackExchange: https://raspberrypi.stackexchange.com/
- Raspberry Pi NOOBS: https://github.com/raspberrypi/noobs
- Pi-hole Wiki: https://github.com/pi-hole/pi-hole/wiki
- Pi-hole OpenVPN-server Wiki: https://github.com/pi-hole/pi-hole/wiki/Pi-hole---OpenVPN-server

# Word of thanks
A special word of thanks goes to Jacob Salmela with his up-to-date [manual](http://users.telenet.be/MySQLplaylist/pi-hole.pdf) (PDF). This guide is inspired on his, although I go a step further in terms of features. Nevertheless, his contribution to (not only) this guide is worth my sincere gratitude. Thanks!

# Licensing
All the licensing and copyrights of any of the code and applications belong to their respective owners. All other coding falls under the MIT-license: https://github.com/teusink/Home-Security-by-Pi/blob/master/LICENSE

Feel free to remake, reshape and reuse whatever you like or need.
