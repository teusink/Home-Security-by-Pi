# Well-known TCP-UDP Protocols and Port-numbers

## General Network Services
- DNS: 53 (TCP/UDP)
- DHCP: 67 (UDP), 68 (UDP)
- NTP: 123 (UDP)
- DHCPv6: 546 (TCP/UDP), 547 (TCP/UDP)
- DNS-over-TLS: 853 (TCP)
- DNS-Multicast: 5353 (TCP/UDP)

## Internet Services
- FTP: 21 (TCP)
- SSH: 22 (TCP/UDP)
- SMTP: 25 (TCP/UDP)
- HTTP: 80 (TCP)
- POP3: 110 (TCP)
- NNTP: 119 (TCP/UDP)
- IMAP4: 143 (TCP/UDP)
- HTTPS: 443 (TCP)
- SMTP-using-STARTLS: 465 (TCP)
- NNTP-over-TLS: 563 (TCP/UDP)
- SMTP-over-TLS: 587 (TCP)
- FTP-data-over-TLS: 989 (TCP/UDP)
- FTP-control-over-TLS: 990 (TCP/UDP)
- IMAP4-over-SSL: 993 (TCP)
- POP3-over-SSL: 995 (TCP)
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
4501-5352
5354-8079
8081-8442
8444-8879
8881-65535

## UDP-block-list
List of UDP port-numbers to block (on the LAN-Internet interface) when opening the services mentioned above.

1-21
23-24
26-49
52-118
120-142
144-499
501-545
548-562
564-988
991-1193
1195-1292
1294-1722
1724-4499
4501-5352
5354-65535
