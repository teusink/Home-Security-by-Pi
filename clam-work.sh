#!/bin/sh
echo To: <your_account_name>@domain.tld
echo From: <your_account_name>@domain.tld
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
  nice -n 19 sudo rkhunter --check --sk --rwo --enable all
  echo
  echo "Initiating ClamAV scan @ $(date)"
  echo -------------------------------------
  nice -n 19 sudo clamscan -r -i /
fi
