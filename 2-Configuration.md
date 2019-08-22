**Table of Contents**
- [Introduction](https://github.com/teusink/Home-Security-by-Pi/blob/master/README.md)
- [1 - Installation](https://github.com/teusink/Home-Security-by-Pi/blob/master/1-Installation.md)
- 2 - Configuration
   - [2.1 - Raspberry Pi](#raspberry-pi)
   - [2.2 - Pi-hole](#pi-hole)
   - [2.3 - Cloudflared](#cloudflared-dns-over-https)
   - [2.4 - PiVPN (OpenVPN)](#pivpn-openvpn)
   - [2.5 - DNS-server](#dns-server)
   - [2.6 - Random Number Generator](#random-number-generator)
- [3 - Hardening](https://github.com/teusink/Home-Security-by-Pi/blob/master/3-Hardening.md)
- [4 - Maintenance](https://github.com/teusink/Home-Security-by-Pi/blob/master/4-Maintenance.md)
- [5 - Skipped](https://github.com/teusink/Home-Security-by-Pi/blob/master/5-Skipped.md)
- [6 - Common issues](https://github.com/teusink/Home-Security-by-Pi/blob/master/6-Common-issues.md)

# Configuration
This part is about the basic configuration of your installment. It has parts of hardening, but it is primarly aimed at configuring or removing installed software and hardware. 

>Important note: everywhere xxx is mentioned in an IP-address and everywhere where an example email-address is mentioned, use your own details!

## Information Sources
Below is a list of sources online I used in order to come to this repo. Thanks for the contributers!
- See my PiHole enabled OpenVPN Server: https://discourse.pi-hole.net/t/see-my-pihole-enabled-openvpn-server/111/2
- Commonly Whitelisted Domains: https://discourse.pi-hole.net/t/commonly-whitelisted-domains/212
- Quad9 Secure DNS Resolvers: https://www.quad9.net/#/faq
- Timeserver: https://wiki.archlinux.org/index.php/systemd-timesyncd
- DNS-server Capability: https://discourse.pi-hole.net/t/howto-using-pi-hole-as-lan-dns-server/533/6
- DNS-over-HTTPS: https://docs.pi-hole.net/guides/dns-over-https/
- DNS-over-HTTPS (IPv6 lookup): https://bendews.com/posts/implement-dns-over-https/

## Raspberry Pi
This part is about the basic configuration of your Raspberry Pi.

- Make sure you set/change the following default configurations using `sudo raspi-config`
   - Change password of the user `pi`
   - Change the hostname
   - Advanced Options: Expand Filesystem
   - Set other settings you like to set.
- Make sure you set/change the following default configurations using Jessie Raspberry Pi Configuration
   - Interface: Only enable the services you need (for instance SSH and VNC)
   - Set other settings you like to set.
- It is nice to have a fixed IP-address for your Pi, so let's change that.
   - Option for Stretch: use the desktop for now
   - Option avaiable after installation of OpenVPN: `sudo nano /etc/dhcpcd.conf`

      Change the lines below to your proper internal IP-addresses.
      ```
      interface eth0
      static ip_address=192.168.xxx.xxx
      static routers=192.168.xxx.xxx
      static domain_name_servers=192.168.xxx.xxx
      static domain_search=local
      static ip6_address=<your_ipv6_address>
      ```
- Because I live in Europe, I like to use a timeserver that resides in Europe, so edit the file: `sudo nano /etc/systemd/timesyncd.conf`
   
   Change / add the lines below:
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

## Pi-hole
I did some additional configuration to get the Pi-hole up-and-running in a secure way. My focus here is to replace as many features (apart from routing and firewalling!) on my router with the Pi as possible. Therefore, the Pi-hole takes over all DNS requests and serves as a DHCP-server.

- Go to your admin panel of Pi-hole: `http://192.168.xxx.xxx/admin/`

   - Go to Settings.
   - Enable DHCP and under Advanced DHCP settings, enable IPv6 DHCP.
   - Under Upstream DNS Servers and then Advanced DNS settings enable DNSSEC. This requires a modern DNS resolver by the way.
   - Select preferred upstream DNS servers for both IPv4 and IPv6 (such as Quad9, Cloudflare or Google). When using Cloudflared (see further down below) you will change the DNS upstream to the local resolver.
   - Make sure you update your [whitelisted domains](https://github.com/teusink/Home-Security-by-Pi/blob/master/2-appendix-PiHole-whitelist.md) (if you want/need).   
   - Make sure you update your [blocklists](https://github.com/teusink/Home-Security-by-Pi/blob/master/2-appendix-PiHole-blocklists.md) (if you want/need).
   - Change the short random generated password with a longer random generated one: `sudo pihole -a -p`.
   - Create the file `pihole-FTL.conf` with `sudo touch /etc/pihole/pihole-FTL.conf` to suppress a daily cron-error in your email (see the commit here to permanently fix it: https://github.com/pi-hole/pi-hole/commit/82d5afe9961a7964bc22e70f44ec8fdd504fa855)

## Cloudflared DNS-over-HTTPS
It is possible to encrypt DNS-look-ups upstream using DNS-over-HTTPS. The 'downside' of this is that it requires Cloudflare DNS (https://1.1.1.1/). It is private and secure, but does not block malicious domains like Quad9 does. So it is a choice you have to make, whether or not you want to trust Cloudflare.

- Execute the following commands to install Cloudflared:
   - `wget https://bin.equinox.io/c/VdrWdbjqyF/cloudflared-stable-linux-arm.tgz`
   - `tar -xvzf cloudflared-stable-linux-arm.tgz`
   - `sudo cp ./cloudflared /usr/local/bin`
   - `sudo chmod +x /usr/local/bin/cloudflared`
   - `sudo cloudflared -v`
- Create a cloudflared user for running the daemon: `sudo useradd -s /usr/sbin/nologin -r -M cloudflared`.
- Create the configuration file with `sudo nano /etc/default/cloudflared` and add the contents below.
	```# Commandline args for cloudflared
	CLOUDFLARED_OPTS=--port 5053 --upstream https://1.1.1.1/dns-query --upstream https://1.0.0.1/dns-query --upstream https://2606:4700:4700::1111/dns-query --upstream https://2606:4700:4700::1001/dns-query
	```
- Permissions needs updating with the cloudflared user:
	- `sudo chown cloudflared:cloudflared /etc/default/cloudflared`
	- `sudo chown cloudflared:cloudflared /usr/local/bin/cloudflared`
- Create the systemd file with `sudo nano /lib/systemd/system/cloudflared.service` and add the contents below.
	```[Unit]
	Description=cloudflared DNS over HTTPS proxy
	After=syslog.target network-online.target

	[Service]
	Type=simple
	User=cloudflared
	EnvironmentFile=/etc/default/cloudflared
	ExecStart=/usr/local/bin/cloudflared proxy-dns $CLOUDFLARED_OPTS
	Restart=on-failure
	RestartSec=10
	KillMode=process

	[Install]
	WantedBy=multi-user.target
	```
- Enable the systemd service to run on startup and validate if its working:
	- `sudo systemctl enable cloudflared`
	- `sudo systemctl start cloudflared`
	- `sudo systemctl status cloudflared`
- Run two tests and see if it gives a response:
	- `dig @127.0.0.1 -p 5053 google.com A`
	- `dig @127.0.0.1 -p 5053 google.com AAAA`
- Now change the Upstream DNS Servers in the Pi-Hole admin-panel. Only select IPv4 and fill in `127.0.0.1#5053`

## PiVPN (OpenVPN)
Now we need to do some stuff to configure PiVPN (so make sure it is installed) in such a way that it uses the Pi-hole as a DNS-resolver, and therefore utilizing the Pi-hole capabilities.

- Create new file: `sudo nano /etc/dnsmasq.d/02-addint.conf`
- Add line: `interface=tun0`, save and exit
- Edit the file: `sudo nano /etc/openvpn/server.conf`
- Add line: `dev tun` at te top
- Add the following lines after the `push "route` lines:

   ```
   push "dhcp-option DNS 192.168.xxx.xxx"
   push "redirect-gateway def1"
   ```
- Save and exit
- Add a new client with: `pivpn add`

   - Enter an username
   - Enter a password
   - Open the generated `.ovpn`
   - Add the following lines: `block-outside-dns` and `auth-nocache` before the `<ca>` tag.
   - Copy the file from your Pi to your device on which you want to have VPN
   - Use it in combination with the password
   - Make sure to disable compression, and to always use TLS 1.2

## DNS-server
This part is about setting up a DNS-server on the Pi, so you can have your own internal DNS-server. This prevent leaning on hosts-files on individual computers in your lan.
- First, create a second dnsmasq file with: `echo "addn-hosts=/etc/pihole/lan.list" | sudo tee /etc/dnsmasq.d/02-lan.conf`.
- Then create the list of IPs with domain-names to resolve: `sudo nano /etc/pihole/lan.list`.

   Add in that file the following lines in the format: `IPv4/IPv6  dns-name hostname`
   ```
   192.168.xxx.xxx                      dnsname.domain.tld  hostname
   2001:0DB8:1337:1337:1337:1337:1337   dnsname.domain.tld  hostname
   ```
   Note: replace domain.tld with your own imagined domain-name!
- Make sure you have added your own `domain.tld` in the search list with: `sudo nano /etc/dhcpcd.conf`
   - And check for the line `static domain_search=local` and make sure that `local` matches your own choosen `domain.tld`.
- For better privacy, add the line below to prevent DNS-look-ups going upstream with: `sudo nano /etc/dnsmasq.d/02-lan.conf`.
   - Add the line: `local=/domain.tld/`

## Random Number Generator
The rngd daemon acts as a bridge between a Hardware TRNG (true random number generator) such as the ones in some Intel/AMD/VIA chipsets, and the kernel's PRNG (pseudo-random number generator) used in (for instance) encryption algoritms. Also according to Jacob Salmela it can help prevent weird erros in your logs.
- Install it with this command: `sudo apt-get install rng-tools`
- Edit the configuration file: `sudo nano /etc/default/rng-tools`
   - Add make sure the the lines below are in it the file:
   
      ```
      #HRNGDEVICE=/dev/hwrng
      #HRNGDEVICE=/dev/null
      HRNGDEVICE=/dev/urandom
      ```

# Done
- This part is done now, so do a reboot now: `sudo reboot`
