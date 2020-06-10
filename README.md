# Home-Security-by-Pi
Description on how I configured the installation and Security of Raspberry Pi and how I keep it fit for use and purpose.

**Table of Contents**
- Introduction
  - [The Scope](#the-scope)
  - [The Hardware](#the-hardware)
  - [The Software](#the-software)
  - [Steps to take](#steps-to-take)
- [1 - Installation](https://github.com/teusink/Home-Security-by-Pi/blob/master/1-Installation.md)
- [2 - Configuration](https://github.com/teusink/Home-Security-by-Pi/blob/master/2-Configuration.md)
- [3 - Hardening](https://github.com/teusink/Home-Security-by-Pi/blob/master/3-Hardening.md)
- [4 - Maintenance](https://github.com/teusink/Home-Security-by-Pi/blob/master/4-Maintenance.md)
- [5 - Skipped](https://github.com/teusink/Home-Security-by-Pi/blob/master/5-Skipped.md)
- [6 - Common issues](https://github.com/teusink/Home-Security-by-Pi/blob/master/6-Common-issues.md)

# Introduction
The goal of this project is to make a secure (or at least secure within a reasonable amount of effort) Raspberry Pi with the following network-features: Pi-Hole DNS-resolver, DNSSEC, DNS-over-HTTPS, DHCP, and OpenVPN-server. It is possible that by gaining new insights features are either removed or added.

My other goal is to gain a good understanding on DNS, Hardening and other Security-related aspects concerning Network Security. I think that as an Information Security Officer and Director of the Cybersecurity Company [MITE3 Cybersecurity](https://www.mite3.nl/en/) it is important to upkeep (general) knowledge about Technology and it's Security.

## The Scope
Scope is an important part for this project. Otherwise you can endlessly install security tools and solutions which in the end have a trade-off. This might be resources and performance, but also your own precious time to keep it running :).

The constraints are:
- Apart from OpenVPN, there is nothing that can be reached from the outside world. In this guide I assume that there is a network-firewall present between the Internet, and the actual Pi.
- The networking-services this device delivers are meant to enhance security of other network-connected devices in a non-intrusive manner.
- And although this device delivers services in a (reasonable) secure way, it is not meant to be a device that delivers security services by it self, such as network-scanning and vulnerability scans.
- It is meant for home or small-office use. Larger companies or institutions should look at other solutions to protect their people.

## The Hardware
The hardware I use exists of the following components:
- Raspberry Pi 3 Model B 1GB
- SDHC card Class 10 - 16GB

The costs: ~ € 70,-

## The Software
The base image that is used to build this guide is the following:
- Image with desktop based on Debian Stretch
- Version: November 2017
- Release date: 2017-11-29
- Kernel version: 4.9

Note: there are no indications that newer versions of Debian Stretch cause glitches with this guide. But if so, please let me know!

# Word of thanks
A special word of thanks goes to Jacob Salmela with his up-to-date [manual](http://users.telenet.be/MySQLplaylist/pi-hole.pdf) (PDF). This guide is inspired on his, although I go a step further in terms of features. Nevertheless, his contribution to (not only) this guide is worth my sincere gratitude. Thanks!

# Licensing
All the licensing and copyrights of any of the code and applications belong to their respective owners. All other coding falls under the MIT-license: https://github.com/teusink/Home-Security-by-Pi/blob/master/LICENSE

Feel free to remake, reshape and reuse whatever you like or need.
