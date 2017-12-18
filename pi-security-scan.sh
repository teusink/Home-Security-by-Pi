#!/bin/sh
echo To: <your_account_name>@domain.tld
echo From: <your_account_name>@domain.tld
echo "Subject: Raspberry Pi Anti-mwalware and -rootkit-log: $(date)"
echo
echo "Raspberry Pi Anti-mwalware and -rootkit-log: $(date)"
echo
echo
echo ✓ Initiating clamfresh database update.
echo ---------------------------------------
sudo /etc/init.d/clamav-freshclam stop
sudo freshclam
sudo /etc/init.d/clamav-freshclam start
echo ---------------------------------------
echo
echo ✓ Initiating rkhunter database refresh.
echo ---------------------------------------
sudo sudo rkhunter --propupd
echo ---------------------------------------
echo
echo ✓ Initiating rkhunter database update..
echo ---------------------------------------
sudo rkhunter --update
echo ---------------------------------------
echo
if [ "$1" = "no-scan" ]
then
  echo "✗ Skipping scans @ $(date)"
else
  echo "✓ Initiating Rootkit Hunter scan @ $(date)"
  echo ---------------------------------------
  nice -n 19 sudo rkhunter --check --sk --rwo --enable all
  echo ---------------------------------------  
  echo
  echo "✓ Initiating chkrootkit scan @ $(date)"
  echo ---------------------------------------
  nice -n 19 sudo chkrootkit -q
  echo ---------------------------------------
  echo
  echo "✓ Initiating ClamAV scan @ $(date)"
  echo ---------------------------------------
  nice -n 19 sudo clamscan -r -i --exclude-dir="^/sys" /
  echo ---------------------------------------
fi
