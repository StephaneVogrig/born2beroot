# Debian configuration
Switch user to root  
`su -`  
Update and uprade apt  
`apt-get update -y`  
`apt-get upgrade -y`

## [sudo](https://www.sudo.ws/)
#### Install
`apt install sudo`  
Add user and create group sudo  
`usermod -aG sudo svogrig`  
Verify sudo member's group  
`getent group sudo`  
Verify log as root by sudo
`sudo whoami`  
#### Configure
If the directory `/var/log/sudo` does not exist,  
`mkdir /var/log/sudo`  
If the file `/var/log/sudo/sudo.log` does not exist,  
`touch /var/log/sudo/sudo.log`  
Edit sudoers.tmp  
`sudo visudo`  
Add in file  
>Defaults  passwd_tries=3  
>Defaults  badpass_message="Sorry it's a wrong password. Try again!"  
>Defaults  logfile="/var/log/sudo/sudo.log"  
>Defaults  log_input  
>Defaults  log_output  
>Defaults  requiretty

and if not already present  
>Defaults  secure_path="/usr/local/sbin:usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

_More infos [tty](https://www.malekal.com/quest-ce-que-tty-comment-utiliser-commande-tty-sur-linux/)_  
## ssh
`apt install openssh-server`  
Verify status  
`systemctl status sshd`  
Verify open port  
`ss -lntp`  
Changing port 22 by 4242  
`nano /etc/ssh/sshd_config`  
Replace in file the line  
>#Port 22

by  
>Port 4242

Verify open port  
`ss -lntp`  

