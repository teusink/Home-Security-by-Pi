#!/bin/bash
### IPv4 Firewall Rules###

## tun0: OpenVPN
## Eth0: LAN

#Flush all current rules (uncomment this to disable it)
iptables -F
iptables -X

# Allow incoming DNS (OpenVPN, LAN)
iptables -A INPUT -i tun0 -p tcp --dport 53 -j ACCEPT
iptables -A INPUT -i tun0 -p udp --dport 53 -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 53 -j ACCEPT
iptables -A INPUT -i eth0 -p udp --dport 53 -j ACCEPT

# Allow incoming HTTP (OpenVPN, LAN)
iptables -A INPUT -i tun0 -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -i tun0 -p udp --dport 80 -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -i eth0 -p udp --dport 80 -j ACCEPT

# Allow incoming SSH (OpenVPN, LAN)
iptables -A INPUT -i tun0 -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 22 -j ACCEPT

# Allow incoming VNC (OpenVPN, LAN)
iptables -A INPUT -i tun0 -p tcp --dport 5900 -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 5900 -j ACCEPT

# Allow incoming OpenVPN (OpenVPN, LAN)
iptables -A INPUT -i tun0 -p tcp --dport 1194 -j ACCEPT
iptables -A INPUT -i tun0 -p udp --dport 1194 -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 1194 -j ACCEPT
iptables -A INPUT -i eth0 -p udp --dport 1194 -j ACCEPT

# Allow outgoing SMTP-over-TLS (LAN)
iptables -A OUTPUT -o eth0 -p tcp --dport 587 -j ACCEPT

# Allow outgoing HTTP(S) (LAN)
iptables -A OUTPUT -o eth0 -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --dport 443 -j ACCEPT

# Allow outgoing (s)FTP (LAN)
iptables -A OUTPUT -o eth0 -p tcp --dport 21 -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --dport 22 -j ACCEPT

# Allow outgoing DNS (LAN)
iptables -A OUTPUT -o eth0 -p tcp --dport 53 -j ACCEPT
iptables -A OUTPUT -o eth0 -p udp --dport 53 -j ACCEPT

# Allow outgoing NTP (LAN)
iptables -A OUTPUT -o eth0 -p udp --dport 123 -j ACCEPT

# Allow loopback traffic
iptables -I INPUT -i lo -j ACCEPT
iptables -I OUTPUT -o lo -j ACCEPT

# Block incoming HTTPS advertisement assets (anywhere)
iptables -R INPUT -p tcp --dport 443 -j REJECT --reject-with tcp-reset

# Allow TCP/IP three way handshakes (anywhere)
iptables -I INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

# Drop Invalid Packets
iptables -I INPUT -m conntrack --ctstate INVALID -j DROP

# Drop anything else
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Test fase
echo New iptables rule-set is:
iptables -L --line-numbers
echo
echo Now test the functionality of your Pi-Hole.
echo - If anything is faulty, just restart.
echo - If all looks well, run 'sudo iptables-save > /etc/pihole/rules.v4'.
