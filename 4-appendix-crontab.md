```
MAILTO=dummy@example.com
#
# m h  dom mon dow   command
#
# Pi Log Folder creation (daily)
0 1 * * * sudo bash /home/pi/scripts/pi-log-folder.sh
#
# Pi Security Scan (daily)
0 3 * * * sudo bash /home/pi/scripts/pi-security-scan.sh >/home/pi/logs/`date +%Y-%m-%d`/pi-security-scan.log 2>&1
0 7 * * * sudo /usr/sbin/ssmtp dummy@example.com < /home/pi/logs/`date +%Y-%m-%d`/pi-security-scan.log
#
# Pi Cleaner (daily)
0 4 * * * sudo bash /home/pi/scripts/pi-cleaner.sh >/home/pi/logs/`date +%Y-%m-%d`/pi-cleaner.log 2>&1
0 7 * * * sudo /usr/sbin/ssmtp dummy@example.com < /home/pi/logs/`date +%Y-%m-%d`/pi-cleaner.log
#
# Pi Update (weekly)
0 5 * * SUN sudo bash /home/pi/scripts/pi-update.sh >/home/pi/logs/`date +%Y-%m-%d`/pi-update.log 2>&1
0 7 * * SUN sudo /usr/sbin/ssmtp dummy@example.com < /home/pi/logs/`date +%Y-%m-%d`/pi-update.log
#
# Pi Audit (weekly)
0 5 * * MON sudo bash /home/pi/scripts/pi-audit.sh >/home/pi/logs/`date +%Y-%m-%d`/pi-audit.log 2>&1
0 7 * * MON sudo /usr/sbin/ssmtp dummy@example.com < /home/pi/logs/`date +%Y-%m-%d`/pi-audit.log
```
