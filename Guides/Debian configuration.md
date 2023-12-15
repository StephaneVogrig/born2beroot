# Debian configuration
Switch user to root  
```bash
su -
```
Update and uprade apt  
```bash
apt-get update
apt-get upgrade -y
```
## [sudo](https://www.sudo.ws/) setup
#### Install
```bash
apt install sudo -y
```
If user svogrig does not exist create user svogrig
```bash
useradd svogrig
passwd svogrig
```
Add user to group sudo  
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
sudo mkdir /var/log/sudo
```
If the file `/var/log/sudo/sudo.log` does not exist,  
```bash
sudo touch /var/log/sudo/sudo.log
```
Edit `sudoers`
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
sudo apt install openssh-server
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
sudo nano /etc/ssh/sshd_config
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
sudo usermod -aG user42 svogrig
```
Verify member's group of user42
```bash
getent group sudo
```
## [UFW](https://launchpad.net/ufw) setup
#### Install
```bash
sudo apt install ufw -y
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
Start service
```bash
sudo ufw enable
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
\# Number of characters in the new password that must not be present in the  
\# old password.  
difok = 7  
\#  
\# Minimum acceptable size for the new password (plus one if  
\# credits are not disabled which is the default). (See pam_cracklib manual.)  
\# Cannot be set to lower value than 6.  
minlen = 10  
\#  
\# The maximum credit for having digits in the new password. If less than 0  
\# it is the minimum number of digits in the new password.  
dcredit = -1  
\#  
\# The maximum credit for having uppercase characters in the new password.  
\# If less than 0 it is the minimum number of uppercase characters in the new    
\# password.  
ucredit = -1  
\#  
\# The maximum credit for having lowercase characters in the new password.  
\# If less than 0 it is the minimum number of lowercase characters in the new  
\# password.  
lcredit = -1  
/.../  
\# The maximum number of allowed consecutive same characters in the new password.  
\# The check is disabled if the value is 0.  
maxrepeat = 3  
/.../  
\# Whether to check if it contains the user name in some form.  
\# The check is enabled if the value is not 0.  
usercheck = 1  
/.../  
\# Prompt user at most N times before returning with error. The default is 1.  
retry = 3  
\#  
\# Enforces pwquality checks on the root user password.  
\# Enabled if the option is present.  
enforce_for_root  
/...

Set timezone to Paris with [timedatectl](https://www.malekal.com/commande-timedatectl-changer-heure-date-fuseau-horaire-linux/)
```bash
sudo timedatectl set-timezone Europe/Paris
```

## Monitoring setup
### Create script
Create file
```
touch /root/monitoring.sh
```
Add in file
```bash
#!/bin/bash

date=$(date)

# Hardware

archi=$(lscpu | grep Architecture | awk '{print $2}')
proc_phys=$(lscpu | grep '^CPU(s):' | awk '{print $2}')
proc_virt=$(nproc --all)
cpu_use=$(top -bn1 | grep '%Cpu(s)' | awk '{printf("%.1f %%", $2 + $6)}')

ram_total=$(free --si --mega | grep Mem | awk '{print $2}')
ram_used=$(free --si --mega | grep Mem | awk '{print $3}')
ram_percent=$(free --si --mega |grep Mem | awk '{printf("%.2d %%", 100 * $3 / $2)}')

disk_total=$(df --si --total | grep total | awk '{print $2}')
disk_used=$(df --si --total | grep total | awk '{print $3}')
disk_percent=$(df --total | grep total | awk '{print $5}')

lvm_nbr=$(lsblk | grep lvm | wc -l)
lvm_use=$(if [ $lvm_nbr -gt 0 ]; then echo no; else echo yes; fi)
last_boot=$(who --boot | awk '{print $3 " " $4}')

# system

os=$(uname --operating-system)
kernel_r=$(uname --kernel-release)
kernel_v=$(uname --kernel-version)

# network

hostname=$(uname --nodename)
MAC=$(ip link show | grep 'link/ether' | awk '{print $2}')
IPV4=$(hostname -I)
tcp=$(ss -t | grep ESTAB | wc -l)
users_logged=$(who --users | wc -l)

# sudo

sudo_users=$(getent group sudo | cut -d: -f4)
sudo_used=$(grep COMMAND /var/log/sudo/sudo.log | wc -l)


wall --nobanner "

$date

- Hardware ------------------------------------------------------------------

    architecture       : $archi
    Physical CPUs      : $proc_phys
    Virtual CPUs       : $proc_virt
    CPU usage          : $cpu_use
    RAM usage          : $ram_used/$ram_total Mo ($ram_percent)
    Disk usage         : $disk_used/$disk_total Go ($disk_percent)
    LVM use            : $lvm_use
    Last boot          : $last_boot

- System --------------------------------------------------------------------

    Operating system   : $os
    kernel release     : $kernel_r
    Kernel version     : $kernel_v

- Network -------------------------------------------------------------------

    Hostname           : $hostname
    MAC adress         : $MAC
    IPV4 adress        : $IPV4
    TCP connection     : $tcp
    Users logged       : $users_logged

- Sudo ----------------------------------------------------------------------

    Users              : $sudo_users
    Sudo commands used : $sudo_used

-----------------------------------------------------------------------------"
```

### Timer by systemd methode
For systemd services see [systemd.service](https://www.freedesktop.org/software/systemd/man/latest/systemd.service.html)

- Create a script
create file  
```
touch /root/monitoring_display.sh
```
Add in file
```
#!/bin/bash
usuers=$(who | awk '{print $2}')
for user in users; do
	bash /root/monitoring.sh > /dev/$user
done
```
- create a timer  
create file  
```
touch /etc/systemd/system/monitoring.timer
```
write in the file  
see example : [systemd/Timers](https://wiki.archlinux.org/title/Systemd/Timers)
```
[Unit]
Description=Display monitoring every 10 minutes

[Timer]
OnUnitActiveSec=10m
Unit=monitoring.service

[Install]
WantedBy=timers.target
```
- create display service
create file
```
touch /etc/systemd/system/monitoring.service
```
write in the file
```
[Unit]
Description=Display monitoring to all connected user

[Service]
Type=simple
ExecStart=bash /root/monitoring.sh

[Install]
WantedBy=multi-user.target
```
- Enable service
```bash
systemctl enable monitoring.timer
systemctl enable monitoring.service
```
- start service
```bash
systemctl start monitoring.timer
systemctl start monitoring.service
```
- check services
```bash
systemctl status monitoring.timer
systemctl status monitoring.service
```

### Timer by [cron](https://www.man7.org/linux/man-pages/man8/cron.8.html) methode

#### Install
```bash
sudo apt install cron
sudo systemctl enable cron
```
#### Configure cron
```bash
sudo crontab -u root -e
```
Add a the end of file
>*/10 * * * * sh /root/monitoring.sh

Check root's scheduled cron job
```bash
sudo crontab -u root -l
```
