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
#### [libpam-pwquality](https://debian-facile.org/doc:securite:passwd:libpam-pwquality)
Install
```bash
sudo apt install libpam-pwquality
```
Edit `pwquality.conf`
```bash
sudo nano /etc/security/pwquality.conf
```
>\# Configuration for systemwide password quality limits  
\# Defaults:  
\#  
>\# Number of characters in the new password that must not be present in the
>\# old password.
>difok = 7
>\#
>\# Minimum acceptable size for the new password (plus one if
>\# credits are not disabled which is the default). (See pam_cracklib manual.)
>\# Cannot be set to lower value than 6.
>minlen = 10
>\#
>\# The maximum credit for having digits in the new password. If less than 0
>\# it is the minimum number of digits in the new password.
dcredit = -1
>\#
>\# The maximum credit for having uppercase characters in the new password.
>\# If less than 0 it is the minimum number of uppercase characters in the new
>\# password.
ucredit = -1
\#
\# The maximum credit for having lowercase characters in the new password.
\# If less than 0 it is the minimum number of lowercase characters in the new
\# password.
lcredit = -1
...
\# The maximum number of allowed consecutive same characters in the new password.
\# The check is disabled if the value is 0.
maxrepeat = 3
...
\# Whether to check if it contains the user name in some form.
\# The check is enabled if the value is not 0.
usercheck = 1
...
>\# Prompt user at most N times before returning with error. The default is 1.
retry = 3
>\#
>\# Enforces pwquality checks on the root user password.
>\# Enabled if the option is present.
enforce_for_root
>...
