#!/bin/sh
echo To: dummy@example.com
echo From: dummy@example.com
echo "Subject: Raspberry Pi Rootkit-detection-log: $(date)"
echo
echo "Raspberry Pi Rootkit-detection-log: $(date)"
echo
echo
echo ✓ Initiating packages update...........
echo ---------------------------------------
nice -n 19 sudo apt-get update
sudo apt-get install -y --only-upgrade chkrootkit rkhunter
echo ---------------------------------------
echo
echo ✓ Initiating rkhunter database refresh.
echo ---------------------------------------
nice -n 19 sudo rkhunter --propupd --nocolors
echo ---------------------------------------
echo
echo ✓ Initiating rkhunter database update..
echo ---------------------------------------
nice -n 19 sudo rkhunter --update --nocolors
echo ---------------------------------------
echo
if [ "$1" = "no-scan" ]
then
  echo "✗ Skipping scans @ $(date)"
else
  echo "✓ Initiating Rootkit Hunter scan @ $(date)"
  echo ---------------------------------------
  nice -n 19 sudo rkhunter --check --sk --rwo --enable all --nocolors
  echo ---------------------------------------  
  echo
  echo "✓ Initiating chkrootkit scan @ $(date)"
  echo ---------------------------------------
  nice -n 19 sudo chkrootkit -q
  echo ---------------------------------------
fi
