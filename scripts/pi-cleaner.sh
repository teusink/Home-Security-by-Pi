#!/bin/sh
echo To: dummy@example.com
echo From: dummy@example.com
echo "Subject: Raspberry Pi [$HOSTNAME] - Cleaning-log: $(date)"
echo
echo "Raspberry Pi [$HOSTNAME] - Cleaning-log: $(date)"
echo
echo
echo ✓ Clean dead.letter email file.........
echo ---------------------------------------
nice -n 19 sudo rm /home/pi/dead.letter
echo ---------------------------------------
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
echo ✓ Clean 30 days old /home/pi/logs/ files.....
echo ---------------------------------------
nice -n 19 sudo tmpreaper 30d /home/pi/logs/ --showdeleted
echo ---------------------------------------
echo
echo ✓ Clean 30 days old /var/tmp files.....
#### WARNING: /tmp gets cleaned upon reboot, but /var/tmp needs to be more persistent!
echo ---------------------------------------
nice -n 19 sudo tmpreaper 30d /var/tmp --showdeleted
echo ---------------------------------------
echo
if [ `date +%d` == "01" ] 
then
  echo ✓ Monthly clean-up old package files...
  echo ---------------------------------------
  sudo apt-get clean
  sudo apt-get purge -y $(dpkg -l | grep '^rc' | awk '{print $2}')
  echo ---------------------------------------
  echo
  echo ✓ Monthly clean-up of /boot.bak, remnent from upgrade
  echo ---------------------------------------
  if [ -d /boot.bak ]
  then 
    nice -n 19 sudo rm /boot.bak -r -d -v
  else
    echo ✗ Directory /boot.bak does not exists
  fi
  echo ---------------------------------------
else
  echo "✗ Monthly clean-up of files not needed, it is day `date +%d`"
fi
echo
if [ "$1" = "no-reboot" ]
then
  echo "✗ Skipping reboot @ $(date)"
else
  echo "✓ Initiating reboot @ $(date)"
  sudo reboot
fi