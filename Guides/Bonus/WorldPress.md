[Bonus](Bonus.md)
# WordPress
## Create database
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

## Install wget unzip
```bash
sudo apt install wget unzip
```
## Install WordPress
```bash
cd /tmp
wget https://wordpress.org/latest.zip
sudo unzip /tmp/latest.zip
sudo mkdir /var/www/html/topo
sudo mv /tmp/wordpress/* /var/www/html/topo
sudo chown -R www-data:www-data /var/www/html/topo
```

## Configure

On host machine open browser in adress : http://localhost:8080/topo
PHP page normally appear.

Titre du site : L'echo des profondeurs
Identifiant : svogrig 
Mot de passe : $Z1X2C3a4s5d6$  
Email : stephane.vogrig@gmail.com


