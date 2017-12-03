#!/bin/bash
### IPv4 Firewall Rules###

## tun0: OpenVPN
## Eth0: LAN

#Flush all current rules (uncomment this to disable it)
iptables -F
iptables -X

## DEFAULT MODUS OPERANDI

# Drop everything (we are going for whitelisting)
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Drop Invalid Packets
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
iptables -A OUTPUT -m conntrack --ctstate INVALID -j DROP

# Accept all already established connections
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

# Block incoming HTTPS advertisement assets (anywhere)
iptables -A INPUT -p tcp --dport 443 -j REJECT --reject-with tcp-reset

## REQUIRED FOR SYSTEM

# Forward VPN Traffic
iptables -A FORWARD -i tun0 -j ACCEPT
iptables -A FORWARD -o tun0 -j ACCEPT

# Allow loopback traffic
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow PING
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
iptables -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT

## REQUIRED FOR SERVICES DELIVERED BY PI

# Allow DHCP - incoming & outgoing
iptables -A INPUT -p udp --dport 67 -j ACCEPT
iptables -A INPUT -p udp --dport 68 -j ACCEPT
iptables -A OUTPUT -p udp --dport 67 -j ACCEPT
iptables -A OUTPUT -p udp --dport 68 -j ACCEPT

# Allow DNS - incoming & outgoing
iptables -A INPUT -p tcp --dport 53 -j ACCEPT
iptables -A INPUT -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT

# Allow NTP - outgoing
iptables -A OUTPUT -p udp --dport 123 -j ACCEPT

# Allow OpenVPN - incoming & outgoing
iptables -A INPUT -p tcp --dport 1194 -j ACCEPT
iptables -A INPUT -p udp --dport 1194 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 1194 -j ACCEPT
iptables -A OUTPUT -p udp --dport 1194 -j ACCEPT

# Allow HTTP - incoming
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p udp --dport 80 -j ACCEPT

# Allow VNC - incoming & outgoing
iptables -A INPUT -p tcp -m multiport --dport 5900:5903 -j ACCEPT
iptables -A OUTPUT -p tcp -m multiport --dport 5900:5903 -j ACCEPT

# Allow SSH - incoming & outgoing
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT

## REQUIRED FOR SERVICES NEEDED BY PI

# Allow HTTP (LAN) - outgoing
iptables -A OUTPUT -o eth0 -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -o eth0 -p udp --dport 80 -j ACCEPT

# Allow HTTPS (LAN) - outgoing
iptables -A OUTPUT -o eth0 -p tcp --dport 443 -j ACCEPT
iptables -A OUTPUT -o eth0 -p udp --dport 443 -j ACCEPT

# Allow SMTP-over-TLS (LAN) - outgoing
iptables -A OUTPUT -o eth0 -p tcp --dport 465 -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --dport 587 -j ACCEPT

# Allow (s)FTP (LAN) - outgoing
iptables -A OUTPUT -o eth0 -p tcp --dport 21 -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --dport 22 -j ACCEPT

## TEST FASE

echo New iptables rule-set is:
echo -------------------------
iptables -L --line-numbers
echo -------------------------
echo
echo Now test the functionality of your Pi-Hole yourself!
echo - If anything is faulty, just restart your Pi.
echo - If all looks well, run 'sudo netfilter-persistent save' to make it persit through reboot.
