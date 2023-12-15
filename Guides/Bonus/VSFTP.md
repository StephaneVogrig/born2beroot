[Bonus](Bonus.md)
# VSFTP
## [Install](https://doc.ubuntu-fr.org/vsftpd)
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

## Configure

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
## test
On a new terminal
```bash
sftp svogrig@localhost
```
