# Home-Security-by-Pi
Description on how I configured the installation and Security of my Raspberry Pi and how I keep it fit for use and purpose.

## Goal
The goal of this project is to make a secure (or at least secure within a reasonable amount of effort) Raspberry Pi with the following features: Pi-Hole DNS-resolver, DNSSEC, DHCP, and OpenVPN-server. It is possible that by gaining new insights features are either removed or added.

My other goal is to gain a good understanding on DNS, Hardening and other Security-related aspects concerning Network Security. I feel that as a Chief Information Security Officer it is important to upkeep (general) knowledge about Technology.

Anything that I create is all done under MIT-license, so please do use it as you see fit. In regard to software created under other licences, those do not change and you need to check them for yourself.

## Installation Sources
- Raspberry Pi: https://www.raspberrypi.org/downloads/raspbian/
- Pi-hole: https://pi-hole.net/ - `sudo curl -sSL https://install.pi-hole.net | bash`
- OpenVPN: http://www.pivpn.io/ - `sudo curl -L https://install.pivpn.io | bash`
- Various apps through the use of `sudo apt-get install`

## Used Informational Sources
Below is a list of sources online I used in order to come to this repo. Thanks for the contributers!
- Tips for accessing your pi-hole remotely: https://pi-hole.net/2016/09/15/tips-for-accessing-your-pi-hole-remotely/
- Block Ads Network-wide with A Raspberry Pi-hole (PDF): http://users.telenet.be/MySQLplaylist/pi-hole.pdf
- See my PiHole enabled OpenVPN Server: https://discourse.pi-hole.net/t/see-my-pihole-enabled-openvpn-server/111/2
- Commonly Whitelisted Domains: https://discourse.pi-hole.net/t/commonly-whitelisted-domains/212
- How do I remove 'Python Games' from Raspbian?: https://raspberrypi.stackexchange.com/questions/50247/how-do-i-remove-python-games-from-raspbian
- Remove Libreoffice Completely: https://www.raspberrypi.org/forums/viewtopic.php?f=91&t=126274
- Quad9 Secure DNS Resolvers: https://www.quad9.net/#/faq
- fail2ban documentation: https://www.fail2ban.org/wiki/index.php/HOWTO_fail2ban_with_OpenVPN

## Other Informational Sources
- StackExchange: https://raspberrypi.stackexchange.com/
- Raspberry Pi NOOBS: https://github.com/raspberrypi/noobs
- Pi-hole Wiki: https://github.com/pi-hole/pi-hole/wiki
- Pi-hole OpenVPN-server Wiki: https://github.com/pi-hole/pi-hole/wiki/Pi-hole---OpenVPN-server

# Installation
In this chapter I will explain the basics I undertook in order to install all the software required. In the chapter Hardening I will go more indepth on what has been changed after the installation.

## Raspberry Pi
- In regard to the base image, I choose that of Raspbian Jessie with Pixel. I am rather tech-savvy, but re-entering the Linux world with root only was a bit to much :).
- Concerning the installation itself, I followed the already online and well documented installation guide: https://www.raspberrypi.org/documentation/installation/installing-images/README.md

## Pi-hole
- Install Pi-hole with the command: `sudo curl -sSL https://install.pi-hole.net | bash`
- Follow instructions for installation here: https://github.com/pi-hole/pi-hole/#one-step-automated-install

## OpenVPN
- Install OpenVPN server with the command: `sudo curl -L https://install.pivpn.io | bash`
- Follow instructions for installation here: https://www.sitepoint.com/setting-up-a-home-vpn-using-your-raspberry-pi/

# Hardening & Configuration
Hardening is the process of disabling or uninstalling application, services and hardware which are not used. To be fair, if you really want hardening, use the minimum image without Jessie, but apart from that, you can get it safe enough. So, while you are busy with some configuration work, harden your Pi also.

## Raspberry Pi
- Make sure you set/change the following default configurations using Jessie Raspberry Pi Configuration
   - System: Change User Password
   - System: Hostname
   - Interface: Only enable the services you need (for instance SSH)
- Make sure you set/change the following default configurations using `sudo raspi-config`
   - Change User Password
   - Hostname
   - Advanced Options: Expand Filesystem
- It is nice to have a fixed IP-address for your Pi, so let's change that using: `sudo nano /etc/dhcpcd.conf`

   Change the lines below to your proper internal IP-addresses.
   ```
   interface eth0
   static ip_address=192.168.xxx.xxx/24
   static routers=192.168.xxx.xxx
   static domain_name_servers=192.168.xxx.xxx
   ```
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
- Automatically locking is a handy feature to prevent access by means of the GUI when your network is compromised. I used xscreensaver for this: xscreensaver: `sudo apt-get install xscreensaver`
- Because I live in Europe, I like to use a timeserver that resides in Europe.

   Use the lines below to replace the similar ones in the ntp.conf file: `sudo nano /etc/ntp.conf`
   ```
   server 0.europe.pool.ntp.org iburst
   server 1.europe.pool.ntp.org iburst
   server 2.europe.pool.ntp.org iburst
   server 3.europe.pool.ntp.org iburst
   ```
- Uncomment the following lines in the file sysctl.conf to enhance network security: `sudo nano /etc/sysctl.conf`
   ```net.ipv4.conf.default.rp_filter=1
   net.ipv4.conf.all.rp_filter=1
   net.ipv4.conf.all.accept_redirects = 0
   net.ipv6.conf.all.accept_redirects = 0
   net.ipv4.conf.all.send_redirects = 0
   net.ipv4.conf.all.accept_source_route = 0
   net.ipv6.conf.all.accept_source_route = 0
   ```
- Time to install mail-services to make sure that an email after important events are sent.

   - Install mail-services: `sudo apt-get -y install ssmtp mailutils mpack`
   - Edit the ssmtp.conf file: `sudo nano /etc/ssmtp/ssmtp.conf` and add/edit the lines below
      ```
      root=<your_account_name>@domain.tld
      mailhub=smtp.domain.tld:587
      hostname=<Your Raspberry pi’s name should already be here>
      AuthUser=<your_account_name>@domain.tld
      AuthPass=<your_password>
      useTLS=YES
      useSTARTTLS=YES
      FromLineOverride=NO 
      ```
      
   - Edit the aliases: `sudo nano /etc/ssmtp/revaliases`
      ```
      # Port 587 for STARTTLS
      # Port 465 for TLS
      root:<your_account_name>@domain.tld:smtp.domain.tld:465
      pi:<your_account_name>@domain.tld:smtp.domain.tld:465
      ```
- Now install fail2ban to add some security to SSH and OpenVPN.

   - Install it with: `sudo apt-get install fail2ban`
   - Create the jail.local file: `sudo nano /etc/fail2ban/jail.local` and add the lines below
      ```
      # Custom settings for jail.conf
      ignoreip = 127.0.0.1/8 192.168.xxx.1/24
      destemail = <your_account_name>@domain.tld
      sender = <your_account_name>@domain.tld
      ```
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
   - SSH is enabled by default :).
- Now it is time to remove some unneeded software and games from Pi.

   - Remove Minecraft Pi: `sudo apt-get remove minecraft-pi`
   - Remove LibreOffice: `sudo apt-get remove libreoffice`
   - Remove Python Games: `rm -rf ~/python_games`
   - And finish it up with: `sudo apt-get autoremove` and `sudo apt-get clean`
- This part is done now, so do a reboot now: `sudo reboot`

## Pi-hole & OpenVPN
I did some additional configuration to get the Pi-hole and OpenVPN up-and-running. My focus here is to replace as many features on my router with the Pi as possible. Therefore, the Pi-hole takes over all DNS requests and serves as a DHCP-server.

- Go to your admin panel of Pi-hole: `http://192.168.xxx.xxx/admin/`

   - Go to Settings.
   - Enable DHCP and under Advanced DHCP settings, enable IPv6 DHCP.
   - Under Upstream DNS Servers and then Advanced DNS settings enable DNSSEC. This requires a modern DNS resolver by the way.
   - Fill in custom IPv4 DNS (Quad9): 9.9.9.9
   - Fill in custom IPv6 DNS (Quad9): 2620:fe::fe
   - Make sure that the following domainnames are in the whitelist:
   
      ```
      ad.doubleclick.net
      clickserve.dartsearch.net
      googleads.g.doubleclick.net
      hosts-file.net
      ipv6.msftncsi.com
      mirror1.malwaredomains.com
      msftncsi.com
      pubads.g.doubleclick.net
      raw.githubusercontent.com
      s.youtube.com
      s3.amazonaws.com
      sysctl.org
      www.googleadservices.com
      www.googletagmanager.com
      www.googletagservices.com
      www.malwaredomainlist.com
      www.msftncsi.com
      zeustracker.abuse.ch
      ```
      - Add the following source to Pi-Hole's Block Lists: `https://www.malwaredomainlist.com/hostslist/hosts.txt`

- Now we need to do some stuff to configure OpenVPN (so make sure it is installed) in such a way that it uses the Pi-hole as a DNS-resolver, and therefore utilizing the Pi-hole capabilities.

   - Create new file: `sudo nano /etc/dnsmasq.d/02-addint.conf`
   - Add line: `interface=tun0`, save and exit
   - Edit the file: `sudo nano /etc/dnsmasq.d/01-pihole.conf`
   - Add line: `interface=tun0` below the line: `interface=eth0`, save and exit
   - Edit the file: `sudo nano /etc/openvpn/server.conf`
   - Add line: `dev tun` at te top
   - Add the following lines after the `push "route` lines:
   
      ```
      push "dhcp-option DNS 192.168.xxx.xxx"
      push "redirect-gateway def1"
      ```
   - Save and exit
- This part is done now, so do a reboot now: `sudo reboot`

# Keeping it updated
Ultimally, the core practice of Security is just to install all (security) updates. This is not different from your Pi. Below I will explain how I did that.

## Raspberry Pi & Pi-hole
Your Pi and all software installed through `apt-get` can be updated with a single script, and you can incorporate additional commands to update additional sources.

- Create a script called `pi-update.sh` and place it in the Pi's home folder. You can find the contents of the script here: https://github.com/teusink/Secure-my-Pi/blob/master/pi-update.sh
- Edit your crontab to plan a regular execution of the script using `crontab -e`.
- Add this line: `0 5 * * SUN sudo sh /home/pi/pi-update.sh >/home/pi/pi-update.log`. This line means that it will do an update every Sunday at 5 am and it outputs it logs to a log file.
- Add this line: `0 6 * * SUN sudo /usr/sbin/ssmtp your_account_name@domain.tld < /home/pi/pi-update.log `. This line means that the log-file created in the update above will be emailed to you every Sunday at 6 am.

## OpenVPN
OpenVPN has unattended upgrades and it upgrades itself. No further configuration required here.
