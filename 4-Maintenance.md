**Table of Contents**
- [Introduction](https://github.com/teusink/Home-Security-by-Pi/blob/master/README.md)
- [1 - Installation](https://github.com/teusink/Home-Security-by-Pi/blob/master/1-Installation.md)
- [2 - Configuration](https://github.com/teusink/Home-Security-by-Pi/blob/master/2-Configuration.md)
- [3 - Hardening](https://github.com/teusink/Home-Security-by-Pi/blob/master/3-Hardening.md)
- 4 - Maintenance
  - [4.1 - Monitoring](#monitoring)
  - [4.2 - Security Auditing](#security-auditing)
  - [4.3 - Patching Raspberry Pi & Pi-hole](#patching-raspberry-pi--pi-hole)
  - [4.4 - Patching PiVPN](#patching-pivpn)
  - [4.5 - Keep disk-usage in control](#keep-disk-usage-in-control)
  - [4.6 - Back-up the SD-card](#back-up-the-sd-card)
- [5 - Skipped](https://github.com/teusink/Home-Security-by-Pi/blob/master/5-Skipped.md)
- [6 - Common issues](https://github.com/teusink/Home-Security-by-Pi/blob/master/6-Common-issues.md)

# Maintenance
Ultimately, the core practice of Security is just to install all (security) updates. This is not different from your Pi. Below I will explain how I did that.

>Important note: everywhere xxx is mentioned in an IP-address and everywhere where an example email-address is mentioned, use your own details!

And here you can see the entire contents of the crontab file that is used: [crontab](https://github.com/teusink/Home-Security-by-Pi/blob/master/4-appendix-crontab.md).

Please not with the crontab above, it is expanded with putting log-files in different folders and an additional command to create the daily folder for the logs. My advice is to follow this practice and disable emailing the logs (put the # comment before the email command in cron). This prevents deleting emails you don't read anyway, but keeping the log-files in case of issues. The Pi-Cleaner scripts cleans out the logs-folder of anything older than 30 days, so don't worry on a growing set of logs.

## Information Sources
- Logwatch: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-logwatch-log-analyzer-and-reporter-on-a-vps
- Lynis: https://cisofy.com/documentation/lynis/
- Debsecan: https://packages.debian.org/stretch/debsecan
- Force firmware update Pi: https://www.raspberrypi.org/forums/viewtopic.php?f=66&t=84887
- tmpreaper package: https://www.thegeekstuff.com/2013/10/tmpreaper-examples/

## Monitoring
Maintenance starts with monitoring, so install Logwatch to do just that. You will get notified daily with what has happened on your Pi.

- Install Logwatch using: `sudo apt-get install logwatch`.
- Edit the Config file of Logwatch with the lines below to enable emailing (rest stays default): `sudo nano /usr/share/logwatch/default.conf/logwatch.conf`

  ```
  MailTo dummy@example.com
  MailFrom dummy@example.com
  ```
  
## Security Auditing
You can also audit your own setup against some security best-practices and known vulnerabilities. There are two tools for that. One is Lynis (configuration and best-practices analyzer), and the other is Debsecan (known vulnerabilities scan in packages).
- To install Lynis: `sudo apt-get install lynis`.
- To install Debsecan `sudo apt-get install debsecan`.
- Configure Debsecan with `sudo dpkg-reconfigure debsecan`, select `stretch` as the distro and disable email notifications (we do that ourselves).

### Manual audit
- To run a Lynis audit: `sudo lynis audit system`.
- To run a Debsecan audit: `sudo debsecan`.

I have created two tickets based on the scans per 2017/12/25.
- Lynis: https://github.com/teusink/Home-Security-by-Pi/issues/23
- Debsecan: https://github.com/teusink/Home-Security-by-Pi/issues/28

### Automated audit weekly after patching
To really stay on par with new found weaknesses on your Pi, create a weekly audit on your system.
- Create a script called [pi-audit.sh](https://github.com/teusink/Secure-my-Pi/blob/master/scripts/pi-audit.sh) and place it in the Pi's scripts folder in the home-directory. Also create the folder `scripts` and `logs` in the home-directory if they don't exists yet.
- Edit your crontab to plan a regular execution of the script using `sudo crontab -u root -e`.
- Add this line: `0 5 * * MON sudo bash /home/pi/scripts/pi-audit.sh >/home/pi/logs/pi-audit.log 2>&1`. This line means that it will do an audit every Monday at 5 am and it outputs it logs (including errors!) to a log file.
- If you want an email of the log, add this line: `0 7 * * MON sudo /usr/sbin/ssmtp dummy@example.com < /home/pi/logs/pi-audit.log `. This line means that the log-file created in the update above will be emailed to you every Monday at 7 am.

## Patch management
This part is all about patching your Raspberry Pi system.

### Automated Patching
The following packages are included in this automation script: Raspberry Pi OS, Raspberry Pi Firmware, Pi-hole, Cloudflared. OpenVPN (PiVPN) has unattended upgrades and it upgrades itself. Therefore, this is not included in the script.

- Create a script called [pi-update.sh](https://github.com/teusink/Secure-my-Pi/blob/master/scripts/pi-update.sh) and place it in the Pi's scripts folder in the home-directory. Also create the folder `scripts` and `logs` in the home-directory if they don't exists yet.
- Edit your crontab to plan a regular execution of the script using `sudo crontab -u root -e`.
- Add this line: `0 5 * * SUN sudo bash /home/pi/scripts/pi-update.sh >/home/pi/logs/pi-update.log 2>&1`. This line means that it will do an update every Sunday at 5 am and it outputs it logs (including errors!) to a log file.
- Add this line: `0 7 * * SUN sudo /usr/sbin/ssmtp dummy@example.com < /home/pi/logs/pi-update.log`. This line means that the log-file created in the update above will be emailed to you every Sunday at 7 am.

### Manual Patching
Note: the script pi-update.sh has two options (parameters):
- `no-reboot`: To prevent the reboot from happening. It might come in handy if you want to do rebooting in another way.
- `dist-upgrade`: Instead of doing `apt-get upgrade` it does `apt-get dist-upgrade`. The difference is that dist-upgrade also removes packages, which might be dangerous to your setup.
- Example: `sudo sudo bash /home/pi/pi-update.sh no-reboot`

### Force Firmware Update
If you replaced your hardware, but not your SD-card, you might want to redo the firmware update. The same applies if you cloned the SD-card for a new Pi-unit.
- First, change the hash value of the current installment (just change one character): `sudo nano /boot/.firmware_revision`.
- Then execute the firmware update again: `sudo rpi-update`.
- And then do a reboot: `sudo reboot`.

## Keep disk-usage in control
Just as any other system, the Pi accumalates temporary and log data. This part is about keeping control of the disk-usage of the SD-card.
- Install the app tmpreaper to do this: `sudo apt-get tmpreaper`.
- Then edit the configuration file: `sudo nano /etc/tmpreaper.conf`.
- And comment (add the `#`) the following line: `SHOWWARNING=true`.
- Create a script called [pi-cleaner.sh](https://github.com/teusink/Secure-my-Pi/blob/master/scripts/pi-cleaner.sh) and place it in the Pi's scripts folder in the home-directory. Also create the folder `scripts` and `logs` in the home-directory if they don't exists yet.
- Edit your crontab to plan a regular execution of the script using `sudo crontab -u root -e`.
- Add this line: `0 4 * * * sudo bash /home/pi/scripts/pi-cleaner.sh >/home/pi/logs/pi-cleaner.log 2>&1`. This line means that it will do an update every night at 4 am and it outputs it logs (including errors!) to a log file.
- If you want an email of the log, add this line: `0 7 * * SUN sudo /usr/sbin/ssmtp dummy@example.com < /home/pi/logs/pi-cleaner.log`. This line means that the log-file created in the update above will be emailed to you every Sunday at 7 am.

This script also includes a daily reboot. Sometimes the DNS-services get cluttered somehow, and a reboot just fixes that.

## Back-up the SD-card
Once in a while backing up your SD-card might be smart. Especially when you have the tendency to tinker with it :). The steps below here can help you do this.

- Download, install and start Win32DiskImager: https://sourceforge.net/projects/win32diskimager/
- Insert the SD-card in your computer, and remember, you might need a SD-card adapter for that.
- At `Image File`, browse to your desired localtion and give it a name, in example: `yyyy-mm-dd Backup Pi.img`.
- At `Device`: Select the drive which holds the SD-card.
- Press the button `Read`.

When you need to restore it, you can reverse the process. Select the `yyyy-mm-dd Backup Pi.img` file, the SD-card as the destination and press `Write`.

# Done
- This part is done now, so do a reboot now: `sudo reboot`
