# Debian configuration
Switch user to root  
```bash
su -
```
Update and uprade apt  
```bash
apt-get update -y
apt-get upgrade -y
```
## [sudo](https://www.sudo.ws/) setup
#### Install
```bash
apt install sudo
```
Add user and create group sudo  
```bash
usermod -aG sudo svogrig
```
Verify member's group of sudo
```bash
getent group sudo
```
Verify log as root by sudo
```bash
sudo whoami
```
#### Configure
If the directory `/var/log/sudo` does not exist,  
```bash
mkdir /var/log/sudo
```
If the file `/var/log/sudo/sudo.log` does not exist,  
```bash
touch /var/log/sudo/sudo.log
```
Edit `sudoers.tmp`
```bash
sudo visudo
```
Add in file  
>Defaults  passwd_tries=3  
>Defaults  badpass_message="Sorry it's a wrong password. Try again!"  
>Defaults  logfile="/var/log/sudo/sudo.log"  
>Defaults  log_input  
>Defaults  log_output  
>Defaults  requiretty

and if not already present  
>Defaults  secure_path="/usr/local/sbin:usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

_More infos [whoami](https://phoenixnap.com/kb/whoami-linux) [tty](https://www.malekal.com/quest-ce-que-tty-comment-utiliser-commande-tty-sur-linux/) [getent](https://manpages.ubuntu.com/manpages/mantic/en/man1/getent.1.html)_  
## ssh setup
#### Install
```bash
apt install openssh-server
```
Check status  
```bash
systemctl status sshd
```
Check open port  
`ss -lntp`
#### Configure
Changing port 22 by 4242  
```bash
nano /etc/ssh/sshd_config
```
Replace in file the line  
>#Port 22

by  
>Port 4242
 
In VirtualBox add rule to allow port 4242  
`Settings > Network > Adapter 1 > Advanced > Port Forwarding`  
Set `Host Port` to 4241 (4242 is already use on the host)  
Set `Guest Port` to 4242  
Restart ssh service  
```bash
sudo systemctl restart ssh
```
Verify open port is 4242  
```bash
ss -lntp
```
## user42 group setup
[Create group](https://linuxize.com/post/how-to-create-groups-in-linux/) `user42`
```bash
sudo groupadd user42
```
Check if group created
```bash
getent group
```
[Add user to group](https://linuxize.com/post/how-to-add-user-to-group-in-linux/)
```bash
sudo usermod -a -G user42 svogrig
```
Verify member's group of user42
```bash
getent group sudo
```
## [UFW](https://launchpad.net/ufw) setpup
#### Install
```bash
sudo apt install ufw
sudo ufw enable
```
#### Configure
```bash
sudo ufw allow ssh
sudo ufw allow 4242
```
Check UFW status  
```bash
sudo ufw status numbered
```
If an other port than 4242 is open  
```bash
sudo ufw delete <port index number>
```
#### First connection
In the host terminal
```bash
sudo ssh svogrig@localhost -p 4241
```
or
```bash
sudo ssgh svogrig@127.0.0.1 -p 4241
```
To quit
```bash 
exit
```  
## Password policy
Edit `login.defs`
```bash
sudo nano /etc/login.defs
```
Find
>\# Password aging controls:

Modify value to correspond to
>PASS_MAX_DAYS  30  
>PASS_MIN_DAYS  2  
>PASS_WARN_AGE  7  

These changes aren't automatically applied to existing users, so use [chage](https://fr.linux-console.net/?p=19667) command to modify for any users and for root:
```bash
sudo chage -M 30 <svogrig>
sudo chage -m 2 <svogrig>
sudo chage -W 7 <svogrig>
sudo chage -M 30 <root>
sudo chage -m 2 <root>
sudo chage -W 7 <root>
```  



