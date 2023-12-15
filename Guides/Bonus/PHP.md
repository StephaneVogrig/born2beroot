[Bonus](Bonus.md)
# PHP
## [Install](https://doc.ubuntu-fr.org/php) 
See also [linux.how2shout.com](https://linux.how2shout.com/install-wordpress-on-lighttpd-web-server-ubuntu/)


Official package recommanded for lighttpd is php-fpm 
```bash
sudo apt install -y php php-cgi php-cli php-fpm php-mysql php-gd php-curl php-mbstring
```
Check install (packets, version, modules)
```bash
dpkg -l |grep php
php -v
php -m
```
## [Configure](https://wiki.debian.org/Lighttpd)
```bash
sudo lighty-enable-mod fastcgi-php-fpm
sudo systemctl reload lighttpd
```
## Test
Create test file
```bash
su -
echo "<?php phpinfo(); ?>" >> /var/www/html/test.php
```
On host machine open browser in adress : http://localhost:8080/test.php
PHP page normally appear.

