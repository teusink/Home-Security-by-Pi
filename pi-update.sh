#!/bin/sh
echo To: your_account_name@domain.tld
echo From: your_account_name@domain.tld
echo "Subject: Raspberry Pi Update-log: $(date)"
echo
echo "** Raspberry Pi Update-log: $(date) **"
echo
echo * Initiating apt update and upgrade *
echo -------------------------------------
sudo apt-get update && sudo apt-get upgrade -y
echo -------------------------------------
echo
echo * Initiating Raspberry PI update... *
echo -------------------------------------
sudo rpi-update
echo -------------------------------------
echo
echo * Initiating apt autoremove........ *
echo -------------------------------------
sudo apt-get autoremove -y
echo -------------------------------------
echo
echo * Initiating apt autoclean......... *
echo -------------------------------------
sudo apt-get autoclean -y
echo -------------------------------------
echo
echo * Initiating Pi-hole update........ *
echo -------------------------------------
sudo pihole -up -g
echo -------------------------------------
echo
echo "Initiating reboot @ $(date)"
sudo reboot
