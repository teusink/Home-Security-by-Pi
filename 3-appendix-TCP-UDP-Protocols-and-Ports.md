# Well-known TCP-UDP Protocols and Port-numbers
The list of the TCP and UDP protocols and their port-numbers listed below are aimed at home and small-office use. It is likely that in larger networks other services (such as databases and the like) are present which might, or might not, impact the list below.

The ports should only be opened from the client perspective to the outside world. The other way around should always be blocked, unless needed for a specific service.

## Network Services
- DNS: 53 (TCP/UDP)
- DHCP: 67 (UDP), 68 (UDP)
- NTP: 123 (UDP)
- DHCPv6: 546 (TCP/UDP), 547 (TCP/UDP)
- DNS-over-TLS: 853 (TCP)

## Internet Services
- FTP: 21 (TCP)
- SSH: 22 (TCP/UDP)
- SMTP: 25 (TCP/UDP)
- HTTP: 80 (TCP)
- POP3: 110 (TCP)
- NNTP: 119 (TCP/UDP)
- NTP: 123 (UDP)
- IMAP4: 143 (TCP/UDP)
- HTTPS: 443 (TCP)
- SMTP-using-STARTLS: 465 (TCP)
- NNTP-over-TLS: 563 (TCP/UDP)
- SMTP-over-TLS: 587 (TCP)
- FTP-data-over-TLS: 989 (TCP/UDP)
- FTP-control-over-TLS: 990 (TCP/UDP)
- IMAP4-over-SSL: 993 (TCP)
- POP3-over-SSL: 995 (TCP)
- Session Initiation Protocol (SIP): 5060 (TCP/UDP)
- Session Initiation Protocol (SIP) over TLS: 5061 (TCP)
- HTTP-alternative: 8080 (TCP), 8880 (TCP)
- HTTPS-alternative: 8443 (TCP)

## VPN Services
- IPsec-tunnel: 50 (TCP/UDP), 51 (TCP/UDP), 500 (TCP/UDP), 1293 (TCP/UDP) 4500 (TCP/UDP)
- SSTP-tunnel: 443 (TCP)
- OpenVPN-tunnel: 1194 (TCP/UDP)
- L2TP-tunnel: 1701 (TCP)
- PPTP-tunnel: 1723 (TCP/UDP)

## TCP-block-list
List of TCP port-numbers to block (on the LAN-Internet interface) when opening the services mentioned above.

1-20
23-24
26-49
52-79
81-109
111-118
120-142
144-442
444-464
466-499
501-545
548-562
564-586
588-852
854-988
991-992
994
996-1193
1195-1292
1294-1700
1702-1722
1724-4499
4501-5059
5062-8079
8081-8442
8444-8879
8881-65535

## UDP-block-list
List of UDP port-numbers to block (on the LAN-Internet interface) when opening the services mentioned above.

1-21
23-24
26-49
52-118
120-122
124-142
144-499
501-545
548-562
564-988
991-1193
1195-1292
1294-1722
1724-4499
4501-5059
5061-65535

## Information Sources
- List of TCP and UDP port numbers (Wikipedia): https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers
- List of Well-Known TCP Port Numbers (Webopedia): https://www.webopedia.com/quick_ref/portnumbers.asp
- TCP/IP Ports and Protocols (Pearsons): http://www.pearsonitcertification.com/articles/article.aspx?p=1868080
- Ports Database (Speed Guide): https://www.speedguide.net/ports.php

# Well-known TCP-UDP Protocols and Port-numbers that really needs to be blocked
The list of ports below are often vulnerable to attack due to vulnerable services behind them. Make sure that you really block or do not allow them, unless really explicitly needed.

The ports should at least be blocked to the client from the outside world. It should really only be opened unless its needed for a specific service. Some services outbound (such as SMTP and NTP) can safely be done.

## Dangerous ports
- Reserved Port: 0 (TCP/UDP) - often abused by malicious software
- Chargen: 19 (TCP/UDP) - used as amplifier in DoS-attacks
- Telnet: 23 (TCP/UDP) - often vulnerable services
- SMTP: 25 (TCP/UDP) - often vulnerable services and misuse for spam propagation
- NTP: 123 (UDP) - often vulnerable services
- Microsoft NetBIOS: 135-139 (TCP/UDP) - potential data-leakages due to file and print sharing
- SNMP: 161-162 (TCP/UDP) - often vulnerable services
- SMB: 445 (TCP/UDP) - potential data-leakages due to file and print sharing and spreading malware
- RIP: 520 (UDP) - vulnerable to DoS-attacks and backdoors
- SOCKS: 1080 (TCP) - potential spam relay point
- Microsoft SQL Server: 1433-1434 (TCP/UDP) - vulnerable to DoS-attacks and malware infections
- SSDP & UPnP: 1900 (TCP/UDP) - vulnerable to DoS-attacks
- DNS-Multicast, Zeroconfig, Bonjour: 5353 (TCP/UDP) - vulnerable to DoS-attacks

## Information Sources
- Networking, Firewall, Vulnerable Networking Ports Blocked - https://answers.uillinois.edu/illinois/page.php?id=47646
- XS4ALL poort beveiliging - https://www.xs4all.nl/service/diensten/beveiliging-en-veiligheid/installeren/hoe-zet-ik-poortbeveiliging-aan.htm