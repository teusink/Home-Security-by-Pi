#!/bin/sh
echo ------------------------------------
echo Initiating apt update and upgrade...
date
echo ------------------------------------
sudo apt-get update && sudo apt-get upgrade -y
echo ------------------------------------
echo
echo Initiating Raspberry PI update......
date
echo ------------------------------------
sudo rpi-update
echo ------------------------------------
echo
echo Initiating apt autoremove...........
date
echo ------------------------------------
sudo apt-get autoremove -y
echo ------------------------------------
echo
echo Initiating apt autoclean............
date
echo ------------------------------------
sudo apt-get autoclean -y
echo ------------------------------------
echo
echo Initiating reboot of Raspberry Pi...
sudo reboot
