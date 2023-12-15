Help : [Wiki ubuntu-fr](https://doc.ubuntu-fr.org/lighttpd)
# [lighttpd](https://redmine.lighttpd.net/projects/lighttpd/wiki/TutorialConfiguration)
See also [debian.org](https://wiki.debian.org/Lighttpd)
#### [Install](https://orcacore.com/install-configure-lighttpd-ubuntu-22-04/)
```bash
sudo apt install -y lighttpd
```
 Check install
```bash
dpkg -l | grep lighttpd
sudo lighttpd -v
```

#### Manage
```bash
sudo systemctl start lighttpd
sudo systemctl enable lighttpd
```
Check
```bash
sudo systemctl status lighttpd
```

#### [Configure](https://elsefix.com/fr/como-instalar-lighttpd-en-ubuntu-22-04-lts.html)

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

#### Test
On host machine open browser in adress : http://localhost:8080
Placeholder page normally appear.

# MariaDB
#### [Install](https://www.digitalocean.com/community/tutorials/how-to-install-mariadb-on-ubuntu-22-04) 
See also [orcacore.com](https://orcacore.com/install-configure-lighttpd-ubuntu-22-04/)
```bash
apt install -y mariadb-server
```
Check install
```bash
dpkg -l | grep mariadb
```
#### Configure
Run the security script:
```bash
sudo mysql_secure_installation
```
Answer 'n' for root account and password and 'y' for other
#### Test
```bash
sudo systemctl status mariadb
sudo mysqladmin version
sudo mysql -u root -p
```
# PHP
#### [Install](https://doc.ubuntu-fr.org/php) 
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
#### [Configure](https://wiki.debian.org/Lighttpd)
```bash
sudo lighty-enable-mod fastcgi-php-fpm
sudo systemctl reload lighttpd
```
#### Test
Create test file
```bash
su -
echo "<?php phpinfo(); ?>" >> /var/www/html/test.php
```
On host machine open browser in adress : http://localhost:8080/test.php
PHP page normally appear.

# WordPress
#### Create database
See [linux.how2shout.com](https://linux.how2shout.com/install-wordpress-on-lighttpd-web-server-ubuntu/)

```bash
sudo mariadb
CREATE DATABASE wordpress_database;
CREATE USER 'svogrig'@'localhost' IDENTIFIED BY 'a4s5d6';
GRANT ALL ON wordpress_database.* TO 'svogrig'@'localhost';
FLUSH PRIVILEGES;
```
Check database
```bash
SHOW DATABASES;
exit
```

#### Install wget unzip
```bash
sudo apt install wget unzip
```
#### Install WordPress
```bash
cd /tmp
wget https://wordpress.org/latest.zip
sudo unzip /tmp/latest.zip
sudo mkdir /var/www/html/topo
sudo mv /tmp/wordpress/* /var/www/html/topo
sudo chown -R www-data:www-data /var/www/html/topo
```

#### Configure

On host machine open browser in adress : http://localhost:8080/topo
PHP page normally appear.

Titre du site : L'echo des profondeurs
Identifiant : svogrig 
Mot de passe : $Z1X2C3a4s5d6$  
Email : stephane.vogrig@gmail.com


# fail2ban
#### [Install](https://doc.ubuntu-fr.org/fail2ban)
```bash
 sudo apt install -y fail2ban 
```
Check install
```bash
dpkg -l | grep fail2ban
sudo systemctl status fail2ban
```

#### Configure
Create a copy of jail.conf
```bash
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.d/custom.conf
sudo nano /etc/fail2ban/jail.d/custom.conf
```
Edit 
```bash
sudo nano /etc/fail2ban/jail.d/custom.conf
```
Change line 92 by
>ignoreip = 127.0.0.1

Change line 101 by
>bantime  = 24h

Change line 105 by
>findtime  = 10m

Change line 108 by
>maxretry = 3

Change line 280 by
> port    = 42

Add in line 283
>enabled = true

Restart service
```bash
sudo systemctl restart fail2ban
```
#### Check
```bash
sudo fail2ban-client status
```
# VSFTP
#### [Install](https://doc.ubuntu-fr.org/vsftpd)
See also [linuxopsys.com](https://linuxopsys.com/topics/install-vsftpd-ftp-server-on-debian), [tecmint.com](https://www.tecmint.com/install-ftp-server-in-ubuntu/)
```bash
 sudo apt install -y vsftpd 
```
Check install
```bash
dpkg -l | grep vsftpd
sudo systemctl status vsftpd
```
If vsftpd service is not running
```bash
sudo systemctl start vsftpd
sudo systemctl enable vsftpd
```

#### Configure

In VirtualBox : `settings`->`Network`->`Adaptater 1`->`Advanced`->`Port Forwarding`  
Add rule : Host port 20, Guest port 20.  
Add rule : Host port 21, Guest port 21.

Start or restart vm

- UFW
```bash
sudo ufw allow 20/tcp
sudo ufw allow 21/tcp
sudo ufw reload
sudo ufw status
```

Create user ftp directory
```bash
sudo mkdir -p /home/svogrig/ftp/upload
sudo chmod 550 /home/svogrig/ftp
sudo chmod -R 750 /home/svogrig/ftp/upload
sudo chown -R svogrig: /home/svogrig/ftp
```

- SSL
```bash
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/vsftpd.pem -out /etc/ssl/private/vsftpd.pem  
```
- VSFTP

Create white list with username
```bash
echo "svogrig" | sudo tee -a /etc/vsftpd.userlist
```
Edit `/etc/vsftpd.conf`
```bash
sudo nano /etc/vsftpd.conf
```


Uncomment line 28
>local_enable=YES

Uncomment line 31
>write_enable=YES

Uncomment line 35
>local_umask=022

Uncomment line 103 and change it
>ftpd_banner=Welcome to svogrig FTP service.

Uncomment line 114
>chroot_local_user=YES

Change line line 149 to 151 by
>rsa_cert_file=/etc/ssl/private/vsftpd.pem
rsa_private_key_file=/etc/ssl/private/vsftpd.pem  
ssl_enable=YES


Add at the end
>user_sub_token=$USER  
local_root=/home/$USER/ftp  
userlist_enable=YES  
userlist_file=/etc/vsftpd.userlist  
userlist_deny=NO

```bash
sudo systemctl restart vsftpd
```
#### test
On a new terminal
```bash
sftp svogrig@localhost
```

# [Gossa](https://github.com/pldubouilh/gossa)

#### Install
```bash
wget https://github.com/pldubouilh/gossa/releases/download/v1.0.0/gossa-linux-x64
chmod + x gossa-linux-x64  
./gossa-linux-x64
./gossa-linux-x64 -verb -h 0.0.0.0 . 
```

test

in bash
```bash
./gossa-linux-x64 -h 0.0.0.0 -p 8001 /var/www/html
```
in chrome
```
localhost:8002
````

#### Configure

- VirtualBox
```bash
settings->Network->Adaptater 1->Advanced->Port Forwarding  
Add rule : Host port 8002, Guest port 8001.
```

- UFW
```bash
sudo ufw allow 8002
sudo ufw allow 8001
sudo ufw reload
sudo ufw status
```
- cron
Add line
```bash
@reboot /home/svogrig/gossa-linux-x64 -h 0.0.0.0 -verb /var/www/html >> /var/log/gossa.log
```

#### start
```bash
sudo gossa-linux-x64 -h 0.0.0.0 -verb /var/www/html >> /var/log/gossa.log
```

Pour obtenir l'IP de la machine
```bash
ip a
```

verification du service


Create [service](https://www.freedesktop.org/software/systemd/man/latest/systemd.service.html)
see also : [systemd: Template unit files](https://fedoramagazine.org/systemd-template-unit-files/)

Create file
```
/etc/systemd/system/<nom_fichier.service>
```
Write in the file
```
[Unit]
Description=<titre descriptif qui sera affihcer>

[Service]
Type=simple
ExecStart=<path to gossa> -h 0.0.0.0 -verb /var/www/html

[Install]
WantedBy=multi-user.target
```

