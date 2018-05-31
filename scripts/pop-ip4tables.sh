#!/bin/bash
### IPv4 Firewall Rules###

## tun0: OpenVPN
## Eth0: LAN

# This scripts needs to be executed with `sudo`

# Flush all current rules (comment this to disable it)
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

# Drop all ANY queries to DNS server to prevent DDOS DNS amplification attack
iptables -A INPUT -p udp --dport 53 -m string --from 50 --algo bm --hex-string '|0000FF0001|' -m recent --set --name dnsanyquery
iptables -A INPUT -p udp --dport 53 -m string --from 50 --algo bm --hex-string '|0000FF0001|' -m recent --name dnsanyquery --rcheck --seconds 60 --hitcount 1 -j DROP
iptables -A INPUT -p udp --dport 53 -m string --from 50 --algo bm --hex-string '|0000FF0001|' -j DROP

# Accept all already established connections
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

# Drop everything that comes from Bogon-addresses
#iptables -A INPUT -s 0.0.0.0/0 -j DROP        # Default (can be advertised in BGP if desired)
#iptables -A INPUT -s 0.0.0.0/8 -j DROP        # Self identification (RFC 1700)
#iptables -A INPUT -s 0.0.0.0/32 -j DROP       # Broadcast
#iptables -A INPUT -s 10.0.0.0/8 -j DROP       # Private Networks (RFC 1918)
iptables -A INPUT -s 39.0.0.0/8 -j DROP       # IANA Reserved (RFC 3330)
#iptables -A INPUT -s 127.0.0.0/8 -j DROP      # Loopback (RFC 1700)
iptables -A INPUT -s 128.0.0.0/16 -j DROP     # IANA Reserved (RFC 3330)
#iptables -A INPUT -s 169.254.0.0/16 -j DROP   # Local (RFC 3330)
iptables -A INPUT -s 172.16.0.0/12 -j DROP    # Private Networks (RFC 1918)
iptables -A INPUT -s 191.255.0.0/16 -j DROP   # IANA Reserved (RFC 3330)
iptables -A INPUT -s 192.0.0.0/24  -j DROP    # IANA Reserved (RFC 3330)
iptables -A INPUT -s 192.0.2.0/24 -j DROP     # Test-Net (RFC 3330)
#iptables -A INPUT -s 192.168.0.0/16 -j DROP   # Private Networks (RFC 1918)
iptables -A INPUT -s 198.18.0.0/15 -j DROP    # Network Interconnect Device Benchmark Testing (RFC 2544)
iptables -A INPUT -s 223.255.255.0/24 -j DROP # IANA Reserved (RFC 3330)
#iptables -A INPUT -s 224.0.0.0/4 -j DROP      # Multicast (RFC 3171)
iptables -A INPUT -s 240.0.0.0/4 -j DROP      # IANA Reserved (RFC 3330)

# Block incoming HTTPS advertisement assets (anywhere)
iptables -A INPUT -p tcp --dport 443 -j REJECT --reject-with tcp-reset

## REQUIRED FOR SYSTEM

# Forward VPN Traffic
iptables -A FORWARD -i tun0 -j ACCEPT
iptables -A FORWARD -o tun0 -j ACCEPT

# Allow loopback traffic
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow ICMP
iptables -A INPUT -p icmp -j ACCEPT
iptables -A OUTPUT -p icmp -j ACCEPT

## REQUIRED FOR SERVICES DELIVERED BY PI

# Allow DNS & DNS-over-TLS - incoming & outgoing
iptables -A INPUT -p tcp --match multiport --dports 53,853 -j ACCEPT
iptables -A INPUT -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p tcp --match multiport --dports 53,853 -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT

# Allow DHCP & DHCPv6 - incoming & outgoing
iptables -A INPUT -p udp --match multiport --dports 67,68,546,547 -j ACCEPT
iptables -A INPUT -p tcp --match multiport --dports 546,547 -j ACCEPT
iptables -A OUTPUT -p udp --match multiport --dports 67,68,546,547 -j ACCEPT
iptables -A OUTPUT -p tcp --match multiport --dports 546,547 -j ACCEPT

# Allow NTP - outgoing
iptables -A OUTPUT -p udp --dport 123 -j ACCEPT

# Allow OpenVPN - incoming & outgoing
iptables -A INPUT -p tcp --dport 1194 -j ACCEPT
iptables -A INPUT -p udp --dport 1194 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 1194 -j ACCEPT
iptables -A OUTPUT -p udp --dport 1194 -j ACCEPT

# Allow HTTP - incoming
iptables -A INPUT -p tcp --dport 80 -j ACCEPT

# Allow HTTPS - incoming
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Allow VNC - incoming & outgoing
iptables -A INPUT -p tcp --match multiport --dports 5900:5903 -j ACCEPT
iptables -A OUTPUT -p tcp --match multiport --dports 5900:5903 -j ACCEPT

# Allow SSH - incoming & outgoing
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT

## REQUIRED FOR SERVICES NEEDED BY PI

# Allow HTTP (LAN) - outgoing
iptables -A OUTPUT -o eth0 -p tcp --match multiport --dports 80,8080,8880 -j ACCEPT

# Allow HTTPS (LAN) - outgoing
iptables -A OUTPUT -o eth0 -p tcp --match multiport --dports 443,8443 -j ACCEPT

# Allow SMTP-over-TLS (LAN) - outgoing
iptables -A OUTPUT -o eth0 -p tcp --match multiport --dports 465,587 -j ACCEPT

# Allow (s)FTP(S) (LAN) - outgoing
#iptables -A OUTPUT -o eth0 -p tcp --match multiport --dports 21,22,989,990 -j ACCEPT
#iptables -A OUTPUT -o eth0 -p udp --match multiport --dports 989,990 -j ACCEPT

## TEST FASE

echo New iptables rule-set is:
echo -------------------------
iptables -L --line-numbers
echo -------------------------
echo
echo Now test the functionality of your Pi-Hole yourself!
echo - If anything is faulty, just restart your Pi.
echo - If all looks well, run 'sudo netfilter-persistent save' to make it persit through reboot.
