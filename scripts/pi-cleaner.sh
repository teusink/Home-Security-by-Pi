#!/bin/sh
echo To: dummy@example.com
echo From: dummy@example.com
echo "Subject: Raspberry Pi [$HOSTNAME] - Cleaning-log: $(date)"
echo
echo "Raspberry Pi [$HOSTNAME] - Cleaning-log: $(date)"
echo
echo
echo ✓ Clean 7 days old downloaded files....
echo ---------------------------------------
nice -n 19 sudo tmpreaper 7d /home/pi/Downloads --showdeleted
echo ---------------------------------------
echo
echo ✓ Clean 30 days old config files.......
echo ---------------------------------------
nice -n 19 sudo tmpreaper 30d /home/pi/oldconffiles --showdeleted
echo ---------------------------------------
echo
echo ✓ Clean 1 day old /tmp files.....
echo ---------------------------------------
nice -n 19 sudo tmpreaper 1d /tmp --showdeleted
echo ---------------------------------------
echo
echo ✓ Clean 30 days old /var/tmp files.....
#### WARNING: /tmp gets cleaned upon reboot, but /var/tmp needs to be more persistent!
echo ---------------------------------------
nice -n 19 sudo tmpreaper 30d /var/tmp --showdeleted
echo ---------------------------------------
echo
echo ✓ Clean 30 days old package files......
echo ---------------------------------------
if [ `date +%d` == "01" ] 
then
  echo "✓ Cleaning of old package files needed, it is day `date +%d`"
  echo
  sudo apt-get clean
  sudo apt-get purge -y $(dpkg -l | grep '^rc' | awk '{print $2}')
else
  echo "✗ Cleaning of apt cache files not needed, it is day `date +%d`"
fi
echo ---------------------------------------
