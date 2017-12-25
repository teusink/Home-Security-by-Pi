**Table of Contents**
- [Introduction](https://github.com/teusink/Home-Security-by-Pi/blob/master/README.md)
- [1 - Installation](https://github.com/teusink/Home-Security-by-Pi/blob/master/1-Installation.md)
- [2 - Configuration](https://github.com/teusink/Home-Security-by-Pi/blob/master/2-Configuration.md)
- [3 - Hardening](https://github.com/teusink/Home-Security-by-Pi/blob/master/3-Hardening.md)
- [4 - Maintenance](https://github.com/teusink/Home-Security-by-Pi/blob/master/4-Maintenance.md)
- 5- Skipped

# Skipped
There were also security configurations suggested by others on the web that I skipped. I will try to be as complete as possible on which I did not include and why. If you feel it should be included, please open an issue [here](https://github.com/teusink/Home-Security-by-Pi/issues).

| Did not include | Why not? | Source for: Why not | Source for: Why it should |
| --- | --- | --- | --- |
| No `sudo dist-upgrade` in unattended patching | The command `sudo dist-upgrade` might add or, even worse, remove packages you don't want to be added or removed. | [askubuntu.com](https://askubuntu.com/questions/601/the-following-packages-have-been-kept-back-why-and-how-do-i-solve-it) | [raspberrypi.org](https://www.raspberrypi.org/documentation/raspbian/updating.md)
| No SSH keys with remote manaagement | Generating SSH keys was a step to far in the trade-off for usability, in the context that this Pi is never ever meant to be directly connected to the Internet, other than through VPN. I would say username and password with fail2ban is good enough considering the use-case. | N/A | [Jacob Salmela, PDF](http://users.telenet.be/MySQLplaylist/pi-hole.pdf) |
| Tripwire, Host-based IDS | Although Tripwire and similar tools are cool, there are a bit to steep for the use-case of this Pi. It is not directly connected to Internet (apart from OpenVPN). | N/A | N/A |
| Using non-default TCP/UDP-ports for services | Although it is often advised, I keep using default ports (like 22 for SSH and 1194 for OpenVPN). There is no Security through Obscurity. It makes the live of a malicious hacker more difficult with non-default-ports, but that is for like 30 seconds or so. | N/A | N/A |
| Harden SSH configuration: TCPKeepAlive (YES --> NO) | By setting it to no active user sessions may occur, while they are not active. To clean up the resources automatically I choose to keep it to Yes | [SSH manual](https://www.ssh.com/ssh/config/) | [Lynis system audit](https://cisofy.com/controls/SSH-7408/) |
| Install libpam-usb to enable multi-factor authentication for PAM sessions | Due to this being MFA with physical USB-key, it is not a convient one, because you either need to put it in permanently (which in essence disables the purpose) or suffer from lack of remote management. So I did not include it. | [Debian package info](https://packages.debian.org/sid/libpam-usb) | Lynis system audit |
| Use a PAE enabled kernel when possible to gain native No eXecute/eXecute Disable support | I'd rather leave kernel management to Raspbian :) | N/A | [Lynis system audit](https://cisofy.com/controls/KRNL-5677/) |
| | | N/A | Lynis system audit |
