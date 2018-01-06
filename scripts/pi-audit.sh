#!/bin/sh
echo To: dummy@example.com
echo From: dummy@example.com
echo "Subject: Raspberry Pi [$HOSTNAME] - Audit-log: $(date)"
echo
echo "Raspberry Pi [$HOSTNAME] - Audit-log: $(date)"
echo
echo
echo ✓ Initiating packages update...........
echo ---------------------------------------
nice -n 19 sudo apt-get update
sudo apt-get install -y --only-upgrade lynis debsecan
echo ---------------------------------------
echo
echo ✓ Lynis Audit..........................
echo ---------------------------------------
nice -n 19 sudo lynis audit system --pentest --nocolors
echo ---------------------------------------
echo
echo ✓ Debsecan Audit.......................
echo ---------------------------------------
nice -n 19 sudo debsecan --only-fixed --suite sid --format detail
echo ---------------------------------------
