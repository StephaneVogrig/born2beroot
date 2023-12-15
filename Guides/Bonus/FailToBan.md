[Bonus](Bonus.md)
# fail2ban
## [Install](https://doc.ubuntu-fr.org/fail2ban)
```bash
 sudo apt install -y fail2ban 
```
Check install
```bash
dpkg -l | grep fail2ban
sudo systemctl status fail2ban
```

## Configure
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
## Check
```bash
sudo fail2ban-client status
```
