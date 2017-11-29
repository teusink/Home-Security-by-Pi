**Table of Contents**
- [Introduction](https://github.com/teusink/Home-Security-by-Pi/blob/master/README.md)
- [1 - Installation](https://github.com/teusink/Home-Security-by-Pi/blob/master/1-Installation.md)
- [2 - Configuration](https://github.com/teusink/Home-Security-by-Pi/blob/master/2-Configuration.md)
- [3 - Hardening](https://github.com/teusink/Home-Security-by-Pi/blob/master/3-Hardening.md)
- [4 - Maintenance](https://github.com/teusink/Home-Security-by-Pi/blob/master/4-Maintenance.md)

# Hardening
Hardening is the process of disabling or uninstalling application, services and hardware which are not used. To be fair, if you really want hardening, use the minimum image without Jessie, but apart from that, you can get it safe enough. So, while you are busy with some configuration work, harden your Pi also.

## Hardening Sources
Below is a list of sources online I used in order to come to this repo. Thanks for the contributers!
- Tips for accessing your pi-hole remotely: https://pi-hole.net/2016/09/15/tips-for-accessing-your-pi-hole-remotely/
- Block Ads Network-wide with A Raspberry Pi-hole (PDF): http://users.telenet.be/MySQLplaylist/pi-hole.pdf
- See my PiHole enabled OpenVPN Server: https://discourse.pi-hole.net/t/see-my-pihole-enabled-openvpn-server/111/2
- Commonly Whitelisted Domains: https://discourse.pi-hole.net/t/commonly-whitelisted-domains/212
- Quad9 Secure DNS Resolvers: https://www.quad9.net/#/faq
- fail2ban documentation: https://www.fail2ban.org/wiki/index.php/HOWTO_fail2ban_with_OpenVPN
- Firewall configuration: https://github.com/pi-hole/pi-hole/wiki/OpenVPN-server:-Firewall-configuration-(using-iptables)

## Raspberry Pi

### Screenlock
- Automatically locking is a handy feature to prevent access by means of the GUI when your network is compromised. I used xscreensaver for this: xscreensaver: `sudo apt-get install xscreensaver`

### E-mail
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

### fail2ban
- Now install fail2ban to add some security to SSH and OpenVPN.

   - Install it with: `sudo apt-get install fail2ban`
   - Create the jail.local file: `sudo nano /etc/fail2ban/jail.local` and add the lines below
      ```
      # Custom settings for jail.conf

      [DEFAULT]
      ignoreip = 127.0.0.1/8 192.168.178.0/24
      destemail = security@teusink.eu
      sender = joram@teusink.eu
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

### iptables & ip6tables
Hardening is not complete without proper firewalling. On Linux this can be done using iptables for IPv4 and ip6tables for IPv6.

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
- Drop all invalid packets.
- Forward all VPN traffic on tun0 interface.
- Allow all local loopback traffic (127.0.0.0/8).
- Allow ping (ICMP-request) to go in and out.
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
- Allow outgoing (s)FTP.

### Done
- This part is done now, so do a reboot now: `sudo reboot`

## Pi-hole & OpenVPN
I did some additional configuration to get the Pi-hole and OpenVPN up-and-running in a secure way. My focus here is to replace as many features on my router with the Pi as possible. Therefore, the Pi-hole takes over all DNS requests and serves as a DHCP-server.

### Pi-hole
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

### OpenVPN
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

### Done
- This part is done now, so do a reboot now: `sudo reboot`
