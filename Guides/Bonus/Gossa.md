[Bonus](Bonus.md)
# [Gossa](https://github.com/pldubouilh/gossa)

## Install
```bash
wget https://github.com/pldubouilh/gossa/releases/download/v1.0.0/gossa-linux-x64
chmod +x gossa-linux-x64  
./gossa-linux-x64
./gossa-linux-x64 -verb -h 0.0.0.0 . 
```

## Configure

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

## start
```bash
sudo gossa-linux-x64 -h 0.0.0.0 -verb /var/www/html >> /var/log/gossa.log
```

Pour obtenir l'IP de la machine
```bash
ip a
```

## Test

in bash
```bash
./gossa-linux-x64 -h 0.0.0.0 -p 8001 /var/www/html
```
in chrome
```
localhost:8002
```

## Create [service](https://www.freedesktop.org/software/systemd/man/latest/systemd.service.html)
see also : [systemd: Template unit files](https://fedoramagazine.org/systemd-template-unit-files/)

Create file
```
/etc/systemd/system/gossa.service
```
Write in the file
```
[Unit]
Description=Gossa: navigation fichier par le web

[Service]
Type=simple
ExecStart=<path to gossa> -h 0.0.0.0 -verb /var/www/html

[Install]
WantedBy=multi-user.target
```

