**Table of Contents**
- [Introduction](https://github.com/teusink/Home-Security-by-Pi/blob/master/README.md)
- [1 - Installation](https://github.com/teusink/Home-Security-by-Pi/blob/master/1-Installation.md)
- [2 - Configuration](https://github.com/teusink/Home-Security-by-Pi/blob/master/2-Configuration.md)
- [3 - Hardening](https://github.com/teusink/Home-Security-by-Pi/blob/master/3-Hardening.md)
- 4 - Maintenance
- [5 - Skipped](https://github.com/teusink/Home-Security-by-Pi/blob/master/5-Skipped.md)

# Maintenance
Ultimally, the core practice of Security is just to install all (security) updates. This is not different from your Pi. Below I will explain how I did that.

## Patching Raspberry Pi & Pi-hole
Your Pi and all software installed through `apt-get` can be updated with a single script, and you can incorporate additional commands to update additional sources.

- Create a script called `pi-update.sh` and place it in the Pi's home folder. You can find the contents of the script here: https://github.com/teusink/Secure-my-Pi/blob/master/pi-update.sh
- Edit your crontab to plan a regular execution of the script using `crontab -e`.
- Add this line: `0 5 * * SUN sudo sh /home/pi/pi-update.sh >/home/pi/pi-update.log`. This line means that it will do an update every Sunday at 5 am and it outputs it logs to a log file.
- Add this line: `0 6 * * SUN sudo /usr/sbin/ssmtp your_account_name@domain.tld < /home/pi/pi-update.log `. This line means that the log-file created in the update above will be emailed to you every Sunday at 6 am.

## Patching PiVPN
OpenVPN has unattended upgrades and it upgrades itself. No further configuration required here.

## Back-up the SD-card
Place-holder for future info on how to make a back-up of the SD-card.

## Package Integrity issues
I faced some package integrity issues after an upgrade. You can fix thos with the following command:
- `sudo apt-get install --reinstall <packagename> <packagename>`

That way the package are reinstalled, no matter you have the latest version or not.

# Done
- This part is done now, so do a reboot now: `sudo reboot`
