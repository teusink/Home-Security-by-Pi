#!/bin/bash
### IPv4 Firewall Rules###

## tun0: OpenVPN
## Eth0: LAN

#Flush all current rules (uncomment this to disable it)
iptables -F
iptables -X

# Drop anything else
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Accept all already established connections
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

# Drop Invalid Packets
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
iptables -A OUTPUT -m conntrack --ctstate INVALID -j DROP

# Allow loopback traffic
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow PING (all)
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
iptables -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT

# Block incoming HTTPS advertisement assets (anywhere)
iptables -A INPUT -p tcp --dport 443 -j REJECT --reject-with tcp-reset

# Allow DHCP (all)
iptables -A INPUT -p udp --dport 67 -j ACCEPT
iptables -A INPUT -p udp --dport 68 -j ACCEPT
iptables -A OUTPUT -p udp --dport 67 -j ACCEPT
iptables -A OUTPUT -p udp --dport 68 -j ACCEPT

# Allow DNS (all)
iptables -A INPUT -p tcp --dport 53 -j ACCEPT
iptables -A INPUT -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT

# Allow outgoing NTP (all)
iptables -A OUTPUT -p udp --dport 123 -j ACCEPT

# Allow HTTP (all)
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p udp --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -p udp --dport 80 -j ACCEPT

# Allow incoming and outgoing VNC (all)
iptables -A INPUT -p tcp -m multiport --dport 5900:5903 -j ACCEPT
iptables -A OUTPUT -p tcp -m multiport --dport 5900:5903 -j ACCEPT

# Allow incoming and outgoing SSH (all)
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT

# Allow incoming and outgoing OpenVPN (all)
iptables -A INPUT -p tcp --dport 1194 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 1194 -j ACCEPT

# Allow outgoing SMTP-over-TLS (LAN)
iptables -A OUTPUT -o eth0 -p tcp --dport 587 -j ACCEPT

# Allow outgoing HTTPS (LAN)
iptables -A OUTPUT -o eth0 -p tcp --dport 443 -j ACCEPT
iptables -A OUTPUT -o eth0 -p udp --dport 443 -j ACCEPT

# Allow outgoing (s)FTP (LAN)
iptables -A OUTPUT -o eth0 -p tcp --dport 21 -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --dport 22 -j ACCEPT

# Test fase
echo New iptables rule-set is:
echo -------------------------
iptables -L --line-numbers
echo -------------------------
echo
echo Now test the functionality of your Pi-Hole yourself!
echo - If anything is faulty, just restart your Pi.
echo - If all looks well, run 'sudo netfilter-persistent save' to make it persit through reboot.
