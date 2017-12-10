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

# Drop everything that comes from Bogon-addresses
#ip6tables -A INPUT -s ::/0 -j DROP              # Default (can be advertised as a route in BGP to peers if desired)
#ip6tables -A INPUT -s ::/96 -j DROP             # IPv4-compatible IPv6 address – deprecated by RFC4291
#ip6tables -A INPUT -s ::/128 -j DROP            # Unspecified address
#ip6tables -A INPUT -s ::1/128 -j DROP          # Local host loopback address
#ip6tables -A INPUT -s ::ffff:0.0.0.0/96 -j DROP # IPv4-mapped addresses
#ip6tables -A INPUT -s ::224.0.0.0/100 -j DROP   # Compatible address (IPv4 format)
#ip6tables -A INPUT -s ::127.0.0.0/104 -j DROP   # Compatible address (IPv4 format)
#ip6tables -A INPUT -s ::0.0.0.0/104 -j DROP     # Compatible address (IPv4 format)
#ip6tables -A INPUT -s ::255.0.0.0/104 -j DROP   # Compatible address (IPv4 format)
#ip6tables -A INPUT -s 0000::/8 -j DROP          # Pool used for unspecified, loopback and embedded IPv4 addresses
ip6tables -A INPUT -s 0200::/7 -j DROP          # OSI NSAP-mapped prefix set (RFC4548) – deprecated by RFC4048
ip6tables -A INPUT -s 3ffe::/16 -j DROP         # Former 6bone, now decommissioned
ip6tables -A INPUT -s 2001:db8::/32 -j DROP     # Reserved by IANA for special purposes and documentation
#ip6tables -A INPUT -s 2002:e000::/20 -j DROP    # Invalid 6to4 packets (IPv4 multicast)
#ip6tables -A INPUT -s 2002:7f00::/24 -j DROP    # Invalid 6to4 packets (IPv4 loopback)
#ip6tables -A INPUT -s 2002:0000::/24 -j DROP    # Invalid 6to4 packets (IPv4 default)
#ip6tables -A INPUT -s 2002:ff00::/24 -j DROP    # Invalid 6to4 packets
#ip6tables -A INPUT -s 2002:0a00::/24 -j DROP    # Invalid 6to4 packets (IPv4 private 10.0.0.0/8 network)
#ip6tables -A INPUT -s 2002:ac10::/28 -j DROP    # Invalid 6to4 packets (IPv4 private 172.16.0.0/12 network)
#ip6tables -A INPUT -s 2002:c0a8::/32 -j DROP    # Invalid 6to4 packets (IPv4 private 192.168.0.0/16 network)
#ip6tables -A INPUT -s fc00::/7 -j DROP         # Unicast Unique Local Addresses (ULA) – RFC 4193
#ip6tables -A INPUT -s fe80::/10 -j DROP         # Link-local Unicast
ip6tables -A INPUT -s fec0::/10 -j DROP         # Site-local Unicast – deprecated by RFC 3879 (replaced by ULA)
#ip6tables -A INPUT -s ff00::/8 -j DROP         # Multicast

# Block incoming HTTPS advertisement assets (anywhere)
ip6tables -A INPUT -p tcp --dport 443 -j REJECT --reject-with tcp-reset

## REQUIRED FOR SYSTEM

# Forward VPN Traffic
ip6tables -A FORWARD -i tun0 -j ACCEPT
ip6tables -A FORWARD -o tun0 -j ACCEPT

# Allow loopback traffic
ip6tables -A INPUT -i lo -j ACCEPT
ip6tables -A OUTPUT -o lo -j ACCEPT

# Allow ICMP
ip6tables -A INPUT -p ipv6-icmp -j ACCEPT
ip6tables -A OUTPUT -p ipv6-icmp -j ACCEPT

## REQUIRED FOR SERVICES DELIVERED BY PI

# Allow DNS & DNS-over-TLS - incoming & outgoing
ip6tables -A INPUT -p tcp --match multiport --dports 53,853 -j ACCEPT
ip6tables -A INPUT -p udp --dport 53 -j ACCEPT
ip6tables -A OUTPUT -p tcp --match multiport --dports 53,853 -j ACCEPT
ip6tables -A OUTPUT -p udp --dport 53 -j ACCEPT

# Allow DHCP & DHCPv6 - incoming & outgoing
ip6tables -A INPUT -p udp --match multiport --dports 67,68,546,547 -j ACCEPT
ip6tables -A INPUT -p tcp --match multiport --dports 546,547 -j ACCEPT
ip6tables -A OUTPUT -p udp --match multiport --dports 67,68,546,547 -j ACCEPT
ip6tables -A OUTPUT -p tcp --match multiport --dports 546,547 -j ACCEPT

# Allow NTP - outgoing
ip6tables -A OUTPUT -p udp --dport 123 -j ACCEPT

# Allow OpenVPN - incoming & outgoing
ip6tables -A INPUT -p tcp --dport 1194 -j ACCEPT
ip6tables -A INPUT -p udp --dport 1194 -j ACCEPT
ip6tables -A OUTPUT -p tcp --dport 1194 -j ACCEPT
ip6tables -A OUTPUT -p udp --dport 1194 -j ACCEPT

# Allow HTTP - incoming
ip6tables -A INPUT -p tcp --dport 80 -j ACCEPT

# Allow VNC - incoming & outgoing
ip6tables -A INPUT -p tcp --match multiport --dports 5900:5903 -j ACCEPT
ip6tables -A OUTPUT -p tcp --match multiport --dports 5900:5903 -j ACCEPT

# Allow SSH - incoming & outgoing
ip6tables -A INPUT -p tcp --dport 22 -j ACCEPT
ip6tables -A OUTPUT -p tcp --dport 22 -j ACCEPT

## REQUIRED FOR SERVICES NEEDED BY PI

# Allow HTTP (LAN) - outgoing
ip6tables -A OUTPUT -o eth0 -p tcp --match multiport --dports 80,8080,8880 -j ACCEPT

# Allow HTTPS (LAN) - outgoing
ip6tables -A OUTPUT -o eth0 -p tcp --match multiport --dports 443,8443 -j ACCEPT

# Allow SMTP-over-TLS (LAN) - outgoing
ip6tables -A OUTPUT -o eth0 -p tcp --match multiport --dports 465,587 -j ACCEPT

# Allow (s)FTP(S) (LAN) - outgoing
ip6tables -A OUTPUT -o eth0 -p tcp --match multiport --dports 21,22,989,990 -j ACCEPT
ip6tables -A OUTPUT -o eth0 -p udp --match multiport --dports 989,990 -j ACCEPT

## TEST FASE

echo New ip6tables rule-set is:
echo -------------------------
ip6tables -L --line-numbers
echo -------------------------
echo
echo Now test the functionality of your Pi-Hole yourself!
echo - If anything is faulty, just restart your Pi.
echo - If all looks well, run 'sudo netfilter-persistent save' to make it persit through reboot.
