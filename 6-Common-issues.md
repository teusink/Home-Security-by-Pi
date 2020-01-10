**Table of Contents**
- [Introduction](https://github.com/teusink/Home-Security-by-Pi/blob/master/README.md)
- [1 - Installation](https://github.com/teusink/Home-Security-by-Pi/blob/master/1-Installation.md)
- [2 - Configuration](https://github.com/teusink/Home-Security-by-Pi/blob/master/2-Configuration.md)
- [3 - Hardening](https://github.com/teusink/Home-Security-by-Pi/blob/master/3-Hardening.md)
- [4 - Maintenance](https://github.com/teusink/Home-Security-by-Pi/blob/master/4-Maintenance.md)
- [5 - Skipped](https://github.com/teusink/Home-Security-by-Pi/blob/master/5-Skipped.md)
- 6 - Common issues
  - [6.1 - Repair Pi-hole](#repair-pi-hole)
  - [6.2 - Removed packages not purged yet](#removed-packages-not-purged-yet)
  - [6.3 - Package kept back](#package-kept-back)
  - [6.4 - Package integrity issues](#package-integrity-issues)
  - [6.5 - VPN CRL expired](#vpn-crl-expired)
  - [6.6 - Pi-greeter config file modified](#pi-greeter-config-file-modified)
  - [6.7 - DNS does not resolve](#dns-does-not-resolve)

# Common issues
In this part of the guide there are common issues (and solutions) mentioned you might run in to.

## Information Sources
- Regenerate CRL for VPN: https://github.com/pivpn/pivpn/issues/343

## Repair Pi-hole
If for some reason your Pi-hole gives errors (for instance with updating) try repairing first.
- If you use Cloudflared: Change the nameserver to `1.1.1.1` as the resolver with `sudo nano /etc/resolv.conf`.
- Execute repair with `sudo pihole -r`.
- If you use Cloudflared: Change the nameserver back to `127.0.0.1` as the resolver with `sudo nano /etc/resolv.conf`.
- And then do a reboot: `sudo reboot`. 

## Removed packages not purged yet
Sometimes (dependency) packages can be left behind when removed. You still can purge them.
- Check with this if there are any packages needed to be purged: `dpkg --get-selections | grep deinstall`.

  - You can remove the listed packages with: `sudo apt-get purge <package-name>`.
  - After following this guide, it is likely that a good set of packages can be purged. Do that automated with the following command:
  
     ```
     sudo apt-get purge -y $(dpkg -l | grep '^rc' | awk '{print $2}')
     ```

## Package kept back
Sometimes you will see in your log that a package has been kepted back with the command `sudo apt-get upgrade`. Best is to manually fix this with the following command:
- `sudo apt-get install <packagename>`

This could be automated with `sudo dist-upgrade`, but read it [here](https://github.com/teusink/Home-Security-by-Pi/blob/master/5-Skipped.md) why I did not opt-in for that (it is an option in the pi-update.sh script though).

## Package integrity issues
I faced some package integrity issues after an upgrade. You can fix thos with the following command:
- `sudo apt-get install --reinstall <packagename>`

That way the package are reinstalled, no matter you have the latest version or not.

## VPN CRL expired
It is possible that you face connection issues with your VPN after an upgrade of your system. Execute the steps below in your terminal to fix that.
- Check service status: `sudo systemctl status openvpn@server.service`
- Verify following error: `VERIFY ERROR: depth=0, error=CRL has expired: CN=xxx`
- Go to directory: `cd /etc/openvpn/easy-rsa`
- Generate new CRL: `sudo ./easyrsa gen-crl`
- Verify that folder is correct (`/etc/openvpn/crl.pem`): `sudo cat ../server.conf | grep "crl-verify"`
- Copy new CRL to directory: `sudo cp /etc/openvpn/easy-rsa/pki/crl.pem ../crl.pem `
- Reboot service: `sudo systemctl restart openvpn@server.service`

New VPN-connections can be initiated again.

## Pi-greeter config file modified
An update to the system might give this message when using apt-get:

```
Setting up pi-greeter (0.9) ...

Configuration file '/etc/lightdm/pi-greeter.conf'
 ==> Modified (by you or by a script) since installation.
 ==> Package distributor has shipped an updated version.
   What would you like to do about it ?  Your options are:
    Y or I  : install the package maintainer's version
    N or O  : keep your currently-installed version
      D     : show the differences between the versions
      Z     : start a shell to examine the situation
 The default action is to keep your current version.
*** pi-greeter.conf (Y/I/N/O/D/Z) [default=N] ?
```

In this case it was about the wallpaper that has been changed. Either keeping your own or the maintainer's would suffice.

## DNS does not resolve
This might be the cause to the system time being out-of-sync, due to ,for instance, it being switched off for some time. And when that happens, the DNS to the time-servers also doesn't work. This can be done by doing the following in CLI: `sudo date --set '2018-12-31 23:59:00` (obviously change the date and time with your present date and time). Then reboot after `sudo reboot`.

Resolving should work now again.

# Done
- This part is done.
