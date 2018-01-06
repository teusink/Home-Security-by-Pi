**Table of Contents**
- [Introduction](https://github.com/teusink/Home-Security-by-Pi/blob/master/README.md)
- [1 - Installation](https://github.com/teusink/Home-Security-by-Pi/blob/master/1-Installation.md)
- [2 - Configuration](https://github.com/teusink/Home-Security-by-Pi/blob/master/2-Configuration.md)
- 3 - Hardening
   - [3.1 - Disabling hardware](#disabling-hardware)
   - [3.2 - Removing Software and Games](#removing-software-and-games)
   - [3.3 - Screenlock protection with xscreensaver](#screenlock-protection-with-xscreensaver)
   - [3.4 - PAM sessions tempory files with libpam-tmpdir](#pam-sessions-tempory-files-with-libpam-tmpdir)
   - [3.5 - E-mail capabilities](#e-mail-capabilities)
   - [3.6 - Brute-force protection with fail2ban](#brute-force-protection-with-fail2ban)
   - [3.7 - Firewalling with iptables & ip6tables](#firewalling-with-iptables--ip6tables)
   - [3.8 - Hardening of OpenSSH](#hardening-of-openssh)
   - [3.9 - Anti-exploit & -rootkit solutions](#anti-exploit---rootkit-solutions)
- [4 - Maintenance](https://github.com/teusink/Home-Security-by-Pi/blob/master/4-Maintenance.md)
- [5 - Skipped](https://github.com/teusink/Home-Security-by-Pi/blob/master/5-Skipped.md)

# Hardening
Hardening is the process of disabling or uninstalling application, services and hardware which are not used. To be fair, if you really want hardening, use the minimum image without Jessie, but apart from that, you can get it safe enough. So, while you are busy with some configuration work, harden your Pi also.

>Important note: everywhere xxx is mentioned in an IP-address and everywhere where an example email-address is mentioned, use your own details!

## Information Sources
Below is a list of sources online I used in order to come to this repo. Thanks for the contributers!
- Tips for accessing your pi-hole remotely: https://pi-hole.net/2016/09/15/tips-for-accessing-your-pi-hole-remotely/
- Block Ads Network-wide with A Raspberry Pi-hole (PDF): http://users.telenet.be/MySQLplaylist/pi-hole.pdf
- fail2ban documentation: https://www.fail2ban.org/wiki/index.php/HOWTO_fail2ban_with_OpenVPN
- Firewall configuration: https://github.com/pi-hole/pi-hole/wiki/OpenVPN-server:-Firewall-configuration-(using-iptables)
- fail2ban VNC: https://github.com/fail2ban/fail2ban/issues/1008
- How do I remove 'Python Games' from Raspbian?: https://raspberrypi.stackexchange.com/questions/50247/how-do-i-remove-python-games-from-raspbian
- Remove Libreoffice Completely: https://www.raspberrypi.org/forums/viewtopic.php?f=91&t=126274
- Remove software (Full Guide): http://www.howtoptec.com/2016/08/delete-pre-installed-applications-on.html
- Bogon IPv4 and IPv6 addresses: https://6session.wordpress.com/2009/04/08/ipv6-martian-and-bogon-filters/
- Rootkit Hunter update issues: http://cybersec.linuxhorizon.ro/2017/09/the-rkhunter-142-update-issue.html
- Rkhunter resources: https://raspberrytips.nl/raspberry-pi-virus-malware-scanner/
- Slimming down Raspbian Pi: https://blog.samat.org/2015/02/05/slimming-an-existing-raspbian-install/
- Package libpam-tmpdir: https://packages.debian.org/sid/libpam-tmpdir

## Disabling hardware
- Wifi and Bluetooth are two hardware components that I do not use and which could allow remote access. Therefore, I disabled both.

   Add the lines below in the config.txt file: `sudo nano /boot/config.txt`
   ```
   # Uncomment this to disable WiFi and Bluetooth
   dtoverlay=pi3-disable-wifi
   dtoverlay=pi3-disable-bt
   ```
   Add the lines below in the raspi-blacklist.conf file: `sudo nano /etc/modprobe.d/raspi-blacklist.conf`
   ```
   # disable WLAN
   blacklist brcmfmac
   blacklist brcmutil
   blacklist cfg80211
   blacklist rfkill
   
   # disable Bluetooth
   blacklist btbcm
   blacklist hci_uart
   ```
   And then run this command to disable the Bluetooth service: `sudo systemctl disable hciuart`

## Removing Software and Games
- Now it is time to remove some unneeded software and games from Pi.

   - The software that is going to be removed: Integrated Development Editors, Non-Chromium browsers, LibreOffice, Claws Mail client, PDF-Viewer, Emulators, Samba-protocol and all the Games.
   - Remove stuff not needed on a server:
   
      ```
      sudo apt-get remove --purge bluej claws-mail claws-mail-i18n dillo epiphany-browser geany greenfoot libreoffice* minecraft-pi netsurf-gtk nodered nuscratch python-pygame python3-pygame python-sense-emu python3-sense-emu python-sense-emu-doc sense-emu-tools scratch scratch2 sonic-pi timidity wolfram-engine idle-python2.7 idle-python3.5 python3-thonny python3-jedi cups-bsd cups-client gsfonts gsfonts-x11 libcupsfilters1 libcupsimage2 libmotif-common libpoppler64 libxm4 poppler-data poppler-utils xpdf samba-common chromium-browser
      ```
   - Remove Python Games: `rm -rf ~/python_games`
   - And finish it up with: `sudo apt-get autoremove --purge` and `sudo apt-get clean`

## Screenlock protection with xscreensaver
Automatically locking is an important feature to prevent access by means of the GUI (i.e. when using VNC). I used xscreensaver for this.
- Install it using: `sudo apt-get install xscreensaver`
- Than configure it using `xscreensaver-command -prefs` and enable on the tab `Display` the setting `Lock Screen After` and set it to 5 minutes.

## PAM sessions tempory files with libpam-tmpdir
Many programs use $TMPDIR for storing temporary files. Not all of them are good at securing the permissions of those files. libpam-tmpdir sets $TMPDIR and $TMP for PAM sessions and sets the permissions quite tight. This helps system security by having an extra layer of security, making such symlink attacks and other /tmp based attacks harder or impossible.
- Install it using: `sudo apt-get install libpam-tmpdir`

## E-mail capabilities
- Time to install mail-services to make sure that an email after important events can be sent. Important for the detection and response part of the Security.

   - Install mail-services: `sudo apt-get -y install ssmtp mailutils mpack`
   - Edit the ssmtp.conf file: `sudo nano /etc/ssmtp/ssmtp.conf` and add/edit the lines below
      ```
      root=dummy@example.com
      mailhub=smtp.domain.tld:587
      hostname=<your_hostname>
      AuthUser=dummy@example.com
      AuthPass=<your_password>
      useTLS=YES
      useSTARTTLS=YES
      FromLineOverride=NO 
      ```
      
   - Edit the aliases: `sudo nano /etc/ssmtp/revaliases`
      ```
      # Port 587 for STARTTLS
      # Port 465 for TLS
      root:dummy@example.com:smtp.example.com:587
      pi:dummy@example.com:smtp.example.com:587
      ```
   
   - Change the default email-address (add the line below) used by Cron: `sudo nano /etc/default/cron`
      ```
      MAILTO=dummy@example.com
      ```

   - Change the email-address (add the line below) used by the user Pi: `crontab -e`
      ```
      MAILTO=dummy@example.com
      ```

## Brute-force protection with fail2ban
- Now install fail2ban to add some security to SSH and OpenVPN by blocking brute-force password guesses.

   - Install it with: `sudo apt-get install fail2ban`
   - Create the jail.local file: `sudo nano /etc/fail2ban/jail.local` and add the lines below
      ```
      # Custom settings for jail.conf

      [DEFAULT]
      ignoreip = 127.0.0.1/8 192.168.xxx.0/24
      destemail = dummy@example.com
      sender = dummy@example.com
      ```

### fail2ban for PiVPN (OpenVPN)
   - Create the openvpn.local file: `sudo nano /etc/fail2ban/filter.d/openvpn.local` and add the lines below
      ```
      # Fail2Ban filter for selected OpenVPN rejections
      #
      #
      
      [Definition]
      
      # Example messages (other matched messages not seen in the testing server's logs):
      # Fri Sep 23 11:55:36 2016 TLS Error: incoming packet authentication failed from [AF_INET]59.90.146.160:51223
      # Thu Aug 25 09:36:02 2016 117.207.115.143:58922 TLS Error: TLS handshake failed
      
      failregex = ^ TLS Error: incoming packet authentication failed from \[AF_INET\]<HOST>:\d+$
                  ^ <HOST>:\d+ Connection reset, restarting
                  ^ <HOST>:\d+ TLS Auth Error
                  ^ <HOST>:\d+ TLS Error: TLS handshake failed$
                 ^ <HOST>:\d+ VERIFY ERROR
      
      ignoreregex = 
      ```
   - Create the openvpn.local file: `sudo nano /etc/fail2ban/jail.d/openvpn.local` and add the lines below
      ```
      # Fail2Ban configuration fragment for OpenVPN

      [openvpn]
      enabled  = true
      port     = 1194
      protocol = udp
      filter   = openvpn
      logpath  = /var/log/openvpn.log
      maxretry = 3
      ```
### fail2ban for VNC
   - Create the vnc.local file: `sudo nano /etc/fail2ban/filter.d/vnc.local` and add the lines below
      ```
      # Fail2Ban filter for vnc or screensharingd
      #
      
      [INCLUDES]
      before = common.conf
      
      [Definition]
      _daemon = (?:screensharingd|vnc)
      
      failregex = ^%(__prefix_line)sAuthentication: FAILED :: User Name: .*? :: Viewer Address: <HOST> :: Type: (?:DH|.*?)$
      
      ignoreregex = 

      # Author: Peter Franzén, 2015
      ```
   - Create the vnc.local file: `sudo nano /etc/fail2ban/jail.d/vnc.local` and add the lines below
      ```
      # Fail2Ban configuration fragment for VNC

      [vnc]
      enabled  = true
      port     = 5900
      filter   = vnc
      logpath  = /var/log/auth.log
      maxretry = 3
      ```

### fail2ban for SSH
   - SSH is enabled by default :).

## Firewalling with iptables & ip6tables
Hardening is not complete without proper local firewalling. On Linux this can be done using iptables for IPv4 and ip6tables for IPv6.

I have created two scripts:
- Populate IPv4 tables: https://github.com/teusink/Home-Security-by-Pi/blob/master/pop-ip4tables.sh
- Populate IPv6 tables: https://github.com/teusink/Home-Security-by-Pi/blob/master/pop-ip6tables.sh

The file can be created in your homefolder and run with the following commands:
- `sudo bash ./pop-ip4tables.sh`
- `sudo bash ./pop-ip6tables.sh`

It is important to test what has been set. Obviously I tested it also and are using it now. When it does not work, you can reboot to gain access or restore functionality again. If you are certainly that it works, you can execute the following command to make the firewall rules persistent after reboot: `sudo netfilter-persistent save`.

Things I considered with building these firewall rules:
- Default drop on all incoming, outgoing and forwarded traffic.
- Default allowing all connections that already have been setup (for performance reasons!).
- Drop packets from most Bogon-address-types.
- Drop all invalid packets.
- Forward all VPN traffic on tun0 interface.
- Allow all local loopback traffic.
- Allow ICMP-traffic to go in and out.
- Block all incoming https advertisement assets.
- Allow incoming and outgoing DHCP traffic.
- Allow incoming and outgoing DNS traffic.
- Allow outgoing NTP traffic.
- Allow incoming and outgoing HTTP traffic.
- Allow incoming and outgoing VNC traffic.
- Allow incoming and outgoing SSH traffic.
- Allow incoming and outgoing OpenVPN traffic.
- Allow outgoing SMTP-over-TLS (for email).
- Allow outgoing HTTPS.
- Do not allow Dynamic ports (also called private ports) that range from 49152 to 65535. A random port is being used by the avahi-daemon (DNS services), but due to it not being a reserved port number, it is disabled for now.
- See a list of [Well-known TCP-UDP Protocols and Port-numbers](https://github.com/teusink/Home-Security-by-Pi/blob/master/Well-known-TCP-UDP-Protocols-and-Port-numbers.md)

## Hardening of OpenSSH
To disallow root-login and the use of old SSH-protocol versions, do the steps below.
- Edit the config file of ssh using `sudo nano /etc/ssh/sshd_config`.
- Add/uncomment (and change) the lines:

   ```
   PermitRootLogin no
   Protocol 2
   AllowAgentForwarding no
   AllowTcpForwarding no
   X11Forwarding no
   ClientAliveCountMax 2
   Compression no
   LogLevel VERBOSE
   MaxAuthTries 1
   MaxSessions 2
   ```
- Edit the other config file of ssh using `sudo nano /etc/ssh/ssh_config`.
- Uncomment the lines:

   ```
   Protocol 2
   ```
## Anti-exploit & -rootkit solutions
In order to protect yourself from an attack, or in order to prevent infection from spreading to other vulnerable systems, it is key to utilize solutions against malicious software. Classic anti-virus is skipped, because file-sharing is not done on this system. And in order to fight off rootkits and other nasty things, RootKit Hunter and chkrootkit is going to be used.

- Install chkrootkit using: `sudo apt-get install chkrootkit`.
- Install Rootkit Hunter using: `sudo apt-get install rkhunter`
- Create a local config file of rkhunter using `sudo nano /etc/rkhunter.conf.local`

   - Add the lines below:
   ```
   UPDATE_MIRRORS=1
   MIRRORS_MODE=0
   WEB_CMD=""
   PKGMGR=NONE
   SCRIPTWHITELIST=/usr/bin/lwp-request
   ALLOWHIDDENFILE=/etc/.fstab
   SHARED_LIB_WHITELIST=/usr/lib/arm-linux-gnueabihf/libarmmem.so
   ALLOWHIDDENDIR=/etc/.java
   ALLOWHIDDENDIR=/etc/.pihole
   ALLOWHIDDENDIR=/etc/.pivpn
   PORT_PATH_WHITELIST="/usr/sbin/openvpn"
   PORT_PATH_WHITELIST="/usr/sbin/dnsmasq"
   PORT_PATH_WHITELIST="/sbin/dhcpcd5"
   PORT_PATH_WHITELIST="/usr/sbin/avahi-daemon"
   PORT_PATH_WHITELIST="/usr/bin/vncagent"
   ```
- Create a script called pi-security-scan.sh and place it in the Pi's home folder. You can find the contents of the script here: https://github.com/teusink/Secure-my-Pi/blob/master/pi-security-scan.sh
- Configure a daily scans using crontab: `crontab -e`
- Add this line: `0 2 * * * sudo bash /home/pi/pi-security-scan.sh >/home/pi/pi-security-scan.log 2>&1`. This line means that it will do an update of the definition files and scan the entire Pi every night at 2 am and it outputs it logs (including errors!) to a log file.
- Add this line: `0 7 * * * sudo /usr/sbin/ssmtp dummy@example.com < /home/pi/pi-security-scan.log`. This line means that the log-file created in the work above will be emailed to you every morning at 7 am.

Note: the script pi-security-scan.sh has one option (parameter):
- `no-scan`: To prevent the script from executing the rather long-taking scan. It just updates the security tools.
- Example: `sudo bash /home/pi/pi-security-scan.sh no-scan`
   
# Done
- This part is done now, so do a reboot now: `sudo reboot`
