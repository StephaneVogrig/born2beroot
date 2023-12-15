[Bonus](Bonus.md)
# [lighttpd](https://redmine.lighttpd.net/projects/lighttpd/wiki/TutorialConfiguration)
Help : [Wiki ubuntu-fr](https://doc.ubuntu-fr.org/lighttpd)  
See also [debian.org](https://wiki.debian.org/Lighttpd)
## [Install](https://orcacore.com/install-configure-lighttpd-ubuntu-22-04/)
```bash
sudo apt install -y lighttpd
```
 Check install
```bash
dpkg -l | grep lighttpd
sudo lighttpd -v
```

## Manage
```bash
sudo systemctl start lighttpd
sudo systemctl enable lighttpd
```
Check
```bash
sudo systemctl status lighttpd
```

## [Configure](https://elsefix.com/fr/como-instalar-lighttpd-en-ubuntu-22-04-lts.html)

Firwall
```bash
sudo ufw allow 80
sudo ufw allow 443
```
Check
```bash
sudo ufw status
```
Poweroff vm
```bash
sudo poweroff
```

In VirtualBox : `settings`->`Network`->`Adaptater 1`->`Advanced`->`Port Forwarding`
Add rule : Host port 8080, Guest port 80.

Start vm

## Test
On host machine open browser in adress : http://localhost:8080
Placeholder page normally appear.

