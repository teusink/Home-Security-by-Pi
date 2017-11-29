*Back to [Introduction page](https://github.com/teusink/Home-Security-by-Pi/blob/master/README.md)*
# Configuration

## Configuration Sources
Below is a list of sources online I used in order to come to this repo. Thanks for the contributers!
- How do I remove 'Python Games' from Raspbian?: https://raspberrypi.stackexchange.com/questions/50247/how-do-i-remove-python-games-from-raspbian
- Remove Libreoffice Completely: https://www.raspberrypi.org/forums/viewtopic.php?f=91&t=126274

## Configure Installment
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
   static ip_address=192.168.xxx.xxx
   static routers=192.168.xxx.xxx
   static domain_name_servers=192.168.xxx.xxx
   ```
- Now add IPv6 in the network interfaces by editing the interfaces file: `sudo nano /etc/network/interfaces`
   
   Add the line below after the line `iface eth0 inet manual`
   ```
   iface eth0 inet6 manual
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

## Remove Software and Games
- Now it is time to remove some unneeded software and games from Pi.

   - Remove Minecraft Pi: `sudo apt-get remove minecraft-pi`
   - Remove LibreOffice: `sudo apt-get remove libreoffice`
   - Remove Python Games: `rm -rf ~/python_games`
   - And finish it up with: `sudo apt-get autoremove` and `sudo apt-get clean`

# Done
- This part is done now, so do a reboot now: `sudo reboot`
