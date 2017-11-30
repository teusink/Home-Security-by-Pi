**Table of Contents**
- [Introduction](https://github.com/teusink/Home-Security-by-Pi/blob/master/README.md)
- [1 - Installation](https://github.com/teusink/Home-Security-by-Pi/blob/master/1-Installation.md)
- 2 - Configuration
- [3 - Hardening](https://github.com/teusink/Home-Security-by-Pi/blob/master/3-Hardening.md)
- [4 - Maintenance](https://github.com/teusink/Home-Security-by-Pi/blob/master/4-Maintenance.md)

# Configuration
This part is about the basic configuration of your installment. It has parts of hardening, but it is primarly aimed at configuring or removing installed software and hardware. 

## Configuration Sources
Below is a list of sources online I used in order to come to this repo. Thanks for the contributers!
- See my PiHole enabled OpenVPN Server: https://discourse.pi-hole.net/t/see-my-pihole-enabled-openvpn-server/111/2
- Commonly Whitelisted Domains: https://discourse.pi-hole.net/t/commonly-whitelisted-domains/212
- Quad9 Secure DNS Resolvers: https://www.quad9.net/#/faq
- Timeserver: https://wiki.archlinux.org/index.php/systemd-timesyncd

## Configuring Raspberry Pi
- When doing a headless configuration, make sure to create the file `ssh` in the `/boot` partition of your Pi. When booting, check your DHCP server for the Pi's IP-address and move on from there with SSH.
- Make sure you set/change the following default configurations using `sudo raspi-config`
   - Change User Password
   - Hostname
   - Advanced Options: Expand Filesystem
   - Set other settings you like to set.
- Make sure you set/change the following default configurations using Jessie Raspberry Pi Configuration
   - System: Change User Password
   - System: Hostname
   - Interface: Only enable the services you need (for instance SSH)
   - Set other settings you like to set.
- It is nice to have a fixed IP-address for your Pi, so let's change that.
   - Option for Jessie: `sudo nano /etc/dhcpcd.conf`

      Change the lines below to your proper internal IP-addresses.
      ```
      interface eth0
      static ip_address=192.168.xxx.xxx
      static routers=192.168.xxx.xxx
      static domain_name_servers=192.168.xxx.xxx
      ```
   - Option for Stretch: use the desktop for now
- Because I live in Europe, I like to use a timeserver that resides in Europe, so edit the file: `sudo nano /etc/systemd/timesyncd.conf`
   ```
   [Time]
   NTP=0.europe.pool.ntp.org 1.europe.pool.ntp.org 2.europe.pool.ntp.org 3.europe.pool.ntp.org
   #FallbackNTP=0.debian.pool.ntp.org 1.debian.pool.ntp.org 2.debian.pool.ntp.org 3.debian.pool.ntp.org
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
      archive.raspberrypi.org
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
      Note: To not cripple the Google search-engine to much (and annoy the spouse :), I have added the Google ad-servers. Google Analytics is not whitelisted though.
      
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

# Done
- This part is done now, so do a reboot now: `sudo reboot`
