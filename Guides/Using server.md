# hostname
#### change
```bash
nano /etc/hostname
reboot
```

# user
#### create
```bash
useradd <username>
passwd <username>
```

More info : [useradd man](https://www.man7.org/linux/man-pages/man8/useradd.8.html), [useradd man fr](https://manpages.ubuntu.com/manpages/xenial/fr/man8/useradd.8.html), [passwd man](https://www.man7.org/linux/man-pages/man1/passwd.1.html)

#### modify
[Change username](https://www.golinuxcloud.com/how-to-change-username-on-linux/) :
```bash
usermod -l <new_username> <username>
groupmod -n <new_username> <username>
```
Change full name :
```bash
usermod 
```
Add to a group
```bash
usermod -aG <group> <username>
```
More info : [usermod man](https://www.man7.org/linux/man-pages/man8/usermod.8.html)
#### delete
```bash
userdel <username>
```
More info : [userdel man](https://www.man7.org/linux/man-pages/man8/userdel.8.html)
#### list
```bash
users
```
More infos : [users man](https://www.man7.org/linux/man-pages/man1/users.1.html)

#### pass word
Change by user
```bash
passwd
```
Change by super user
```bash
passwd <username>
```

# group
#### create
```bash
groupadd <groupname>
```

#### delete
```bash
groupdel <groupname>
```

#### list
All groups
```bash
compgen -g
```
All members of group
```bash
getent group <groupname>
```

#### modify
Change name
```bash
groupmod -n <new_groupname> <groupname>
```
Add user
```bash
gpasswd -a <username> <group>
```
Delete user
```bash
gpasswd -d <username> <group>
```
More infos : [usermod man](https://www.man7.org/linux/man-pages/man8/usermod.8.html)

# ufw
Enable ufw
```bash
ufw enable
```

Disable ufw
```bash
ufw disable
```
Add new rule
```bash
ufw allow <port/protocol>
```
Delete rule
```bash
ufw delete <port/protocol>