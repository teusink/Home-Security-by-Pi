#!/bin/bash
### IPv6 Firewall Rules###

## tun0: OpenVPN
## Eth0: LAN

#Flush all current rules (uncomment this to disable it)
ip6tables -F
ip6tables -X

## DEFAULT MODUS OPERANDI

# Drop everything (we are going for whitelisting)
ip6tables -P INPUT DROP
ip6tables -P OUTPUT DROP
ip6tables -P FORWARD DROP

# Drop Invalid Packets
ip6tables -A INPUT -m conntrack --ctstate INVALID -j DROP
ip6tables -A OUTPUT -m conntrack --ctstate INVALID -j DROP

# Accept all already established connections
ip6tables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
ip6tables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

# Block incoming HTTPS advertisement assets (anywhere)
ip6tables -A INPUT -p tcp --dport 443 -j REJECT --reject-with tcp-reset

## REQUIRED FOR SYSTEM

# Forward VPN Traffic
ip6tables -A FORWARD -i tun0 -j ACCEPT
ip6tables -A FORWARD -o tun0 -j ACCEPT

# Allow loopback traffic
ip6tables -A INPUT -i lo -j ACCEPT
ip6tables -A OUTPUT -o lo -j ACCEPT

# Allow PING
ip6tables -A INPUT -p ipv6-icmp -j ACCEPT
ip6tables -A OUTPUT -p ipv6-icmp -j ACCEPT

## REQUIRED FOR SERVICES DELIVERED BY PI

# Allow DHCP - incoming & outgoing
ip6tables -A INPUT -p udp --dport 67 -j ACCEPT
ip6tables -A INPUT -p udp --dport 68 -j ACCEPT
ip6tables -A OUTPUT -p udp --dport 67 -j ACCEPT
ip6tables -A OUTPUT -p udp --dport 68 -j ACCEPT

# Allow DNS - incoming & outgoing
ip6tables -A INPUT -p tcp --dport 53 -j ACCEPT
ip6tables -A INPUT -p udp --dport 53 -j ACCEPT
ip6tables -A OUTPUT -p tcp --dport 53 -j ACCEPT
ip6tables -A OUTPUT -p udp --dport 53 -j ACCEPT

# Allow NTP - outgoing
ip6tables -A OUTPUT -p udp --dport 123 -j ACCEPT

# Allow Allow OpenVPN - incoming & outgoing
ip6tables -A INPUT -p tcp --dport 1194 -j ACCEPT
ip6tables -A INPUT -p udp --dport 1194 -j ACCEPT
ip6tables -A OUTPUT -p tcp --dport 1194 -j ACCEPT
ip6tables -A OUTPUT -p udp --dport 1194 -j ACCEPT

# Allow HTTP - incoming
ip6tables -A INPUT -p tcp --dport 80 -j ACCEPT
ip6tables -A INPUT -p udp --dport 80 -j ACCEPT

# Allow VNC - incoming & outgoing
ip6tables -A INPUT -p tcp -m multiport --dport 5900:5903 -j ACCEPT
ip6tables -A OUTPUT -p tcp -m multiport --dport 5900:5903 -j ACCEPT

# Allow SSH - incoming & outgoing
ip6tables -A INPUT -p tcp --dport 22 -j ACCEPT
ip6tables -A OUTPUT -p tcp --dport 22 -j ACCEPT

## REQUIRED FOR SERVICES NEEDED BY PI

# Allow HTTP (LAN) - outgoing
ip6tables -A OUTPUT -o eth0 -p tcp --dport 80 -j ACCEPT
ip6tables -A OUTPUT -o eth0 -p udp --dport 80 -j ACCEPT

# Allow HTTPS (LAN) - outgoing
ip6tables -A OUTPUT -o eth0 -p tcp --dport 443 -j ACCEPT
ip6tables -A OUTPUT -o eth0 -p udp --dport 443 -j ACCEPT

# Allow SMTP-over-TLS (LAN) - outgoing
ip6tables -A OUTPUT -o eth0 -p tcp --dport 465 -j ACCEPT
ip6tables -A OUTPUT -o eth0 -p tcp --dport 587 -j ACCEPT

# Allow (s)FTP (LAN) - outgoing
ip6tables -A OUTPUT -o eth0 -p tcp --dport 21 -j ACCEPT
ip6tables -A OUTPUT -o eth0 -p tcp --dport 22 -j ACCEPT

## TEST FASE

echo New ip6tables rule-set is:
echo -------------------------
ip6tables -L --line-numbers
echo -------------------------
echo
echo Now test the functionality of your Pi-Hole yourself!
echo - If anything is faulty, just restart your Pi.
echo - If all looks well, run 'sudo netfilter-persistent save' to make it persit through reboot.
