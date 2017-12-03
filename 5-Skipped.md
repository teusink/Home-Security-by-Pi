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
| Did not include `sudo dist-upgrade` in unattended patching | The command `sudo dist-upgrade` might add or, even worse, remove packages you don't want to be added or removed. | [askubuntu.com](https://askubuntu.com/questions/601/the-following-packages-have-been-kept-back-why-and-how-do-i-solve-it) | [raspberrypi.org](https://www.raspberrypi.org/documentation/raspbian/updating.md)
| SSH keys | Generating SSH keys was a step to far in the trade-off for usability, in the context that this Pi is never ever meant to be directly connected to the Internet, other than through VPN. I would say username and password with fail2ban or good enough. | N/A | [Jacob Salmela, PDF](http://users.telenet.be/MySQLplaylist/pi-hole.pdf) |
