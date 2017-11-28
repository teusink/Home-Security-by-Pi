#!/bin/bash
### IPv6 Firewall Rules###

## tun0: OpenVPN
## Eth0: LAN

#Flush all current rules (uncomment this to disable it)
ip6tables -F
ip6tables -X

# Drop anything else
ip6tables -P INPUT DROP
ip6tables -P OUTPUT DROP
ip6tables -P FORWARD DROP

# Accept all already established connections
ip6tables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
ip6tables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

# Drop Invalid Packets
ip6tables -A INPUT -m conntrack --ctstate INVALID -j DROP
ip6tables -A OUTPUT -m conntrack --ctstate INVALID -j DROP

# Allow loopback traffic
ip6tables -A INPUT -i lo -j ACCEPT
ip6tables -A OUTPUT -o lo -j ACCEPT

# Allow PING (all)
ip6tables -A INPUT -p ipv6-icmp -j ACCEPT
ip6tables -A OUTPUT -p ipv6-icmp -j ACCEPT

# Block incoming HTTPS advertisement assets (anywhere)
ip6tables -A INPUT -p tcp --dport 443 -j REJECT --reject-with tcp-reset

# Allow DNS (all)
ip6tables -A INPUT -p tcp --dport 53 -j ACCEPT
ip6tables -A INPUT -p udp --dport 53 -j ACCEPT
ip6tables -A OUTPUT -p tcp --dport 53 -j ACCEPT
ip6tables -A OUTPUT -p udp --dport 53 -j ACCEPT

# Allow outgoing NTP (all)
ip6tables -A OUTPUT -p udp --dport 123 -j ACCEPT

# Allow HTTP (all)
ip6tables -A INPUT -p tcp --dport 80 -j ACCEPT
ip6tables -A INPUT -p udp --dport 80 -j ACCEPT
ip6tables -A OUTPUT -p tcp --dport 80 -j ACCEPT
ip6tables -A OUTPUT -p udp --dport 80 -j ACCEPT

# Allow incoming and outgoing VNC (all)
ip6tables -A INPUT -p tcp -m multiport --dport 5900:5903 -j ACCEPT
ip6tables -A OUTPUT -p tcp -m multiport --dport 5900:5903 -j ACCEPT

# Allow incoming and outgoing SSH (all)
ip6tables -A INPUT -p tcp --dport 22 -j ACCEPT
ip6tables -A OUTPUT -p tcp --dport 22 -j ACCEPT

# Allow incoming and outgoing OpenVPN (all)
ip6tables -A INPUT -p tcp --dport 1194 -j ACCEPT
ip6tables -A OUTPUT -p tcp --dport 1194 -j ACCEPT

# Allow outgoing SMTP-over-TLS (LAN)
ip6tables -A OUTPUT -o eth0 -p tcp --dport 587 -j ACCEPT

# Allow outgoing HTTPS (LAN)
ip6tables -A OUTPUT -o eth0 -p tcp --dport 443 -j ACCEPT
ip6tables -A OUTPUT -o eth0 -p udp --dport 443 -j ACCEPT

# Allow outgoing (s)FTP (LAN)
ip6tables -A OUTPUT -o eth0 -p tcp --dport 21 -j ACCEPT
ip6tables -A OUTPUT -o eth0 -p tcp --dport 22 -j ACCEPT

# Test fase
echo New ip6tables rule-set is:
echo -------------------------
ip6tables -L --line-numbers
echo -------------------------
echo
echo Now test the functionality of your Pi-Hole yourself!
echo - If anything is faulty, just restart your Pi.
echo - If all looks well, run 'sudo ip6tables-save'.
