[Bonus](Bonus.md)
# MariaDB
## [Install](https://www.digitalocean.com/community/tutorials/how-to-install-mariadb-on-ubuntu-22-04) 
See also [orcacore.com](https://orcacore.com/install-configure-lighttpd-ubuntu-22-04/)
```bash
apt install -y mariadb-server
```
Check install
```bash
dpkg -l | grep mariadb
```
## Configure
Run the security script:
```bash
sudo mysql_secure_installation
```
Answer 'n' for root account and password and 'y' for other
## Test
```bash
sudo systemctl status mariadb
sudo mysqladmin version
sudo mysql -u root -p
```
