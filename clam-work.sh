#!/bin/sh
echo To: security@teusink.eu
echo From: joram@teusink.eu
echo "Subject: Raspberry Pi ClamAV- & rkhunter-log: $(date)"
echo
echo "Raspberry Pi ClamAV- & rkhunter-log: $(date)"
echo
echo
echo Initiating clamfresh database update.
echo -------------------------------------
sudo /etc/init.d/clamav-freshclam stop
sudo freshclam
sudo /etc/init.d/clamav-freshclam start
echo
echo Initiating rkhunter database update..
echo -------------------------------------
sudo rkhunter --update && sudo rkhunter --propupd
echo
if [ "$1" = "no-scan" ]
then
  echo "Skipping ClamAV & Rootkit Hunter scan @ $(date)"
else
  echo "Initiating Rootkit Hunter scan @ $(date)"
  echo -------------------------------------
  sudo rkhunter --check --enable all
  echo
  echo "Initiating ClamAV scan @ $(date)"
  echo -------------------------------------
  clamscan -r -i /
fi
