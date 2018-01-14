#!/bin/sh
echo To: dummy@example.com
echo From: dummy@example.com
echo "Subject: Raspberry Pi [$HOSTNAME] - Update-log: $(date)"
echo
echo "Raspberry Pi [$HOSTNAME] - Update-log: $(date)"
echo
echo
echo ✓ Initiating packages-list update......
echo ---------------------------------------
nice -n 19 sudo apt-get update
echo ---------------------------------------
echo
if [ "$1" = "dist-upgrade" ] || [ "$2" = "dist-upgrade" ]
then
   echo ⚠ Initiating distribution upgrade......
   echo ---------------------------------------
   sudo apt-get dist-upgrade -y
   echo ---------------------------------------
else
   echo ✓ Initiating packages upgrade..........
   echo ---------------------------------------
   sudo apt-get upgrade -y
   echo ---------------------------------------
fi
echo
echo ✓ Initiating Pi Firmware update........
echo ---------------------------------------
sudo PRUNE_MODULES=1 rpi-update
echo ---------------------------------------
echo
echo ✓ Initiating packages autoremove.......
echo ---------------------------------------
sudo apt-get autoremove -y --purge
echo ---------------------------------------
echo
echo ✓ Initiating packages autoclean........
echo ---------------------------------------
sudo apt-get autoclean -y
echo ---------------------------------------
echo
echo ✓ Initiating Pi-hole update............
echo ---------------------------------------
sudo pihole -up -g
echo ---------------------------------------
echo
if [ "$1" = "no-reboot" ] || [ "$2" = "no-reboot" ]
then
  echo "✗ Skipping reboot @ $(date)"
else
  echo "✓ Initiating reboot @ $(date)"
  sudo reboot
fi
