[Shell principales commandes](https://igm.univ-mlv.fr/~masson/Teaching/PIM-INF3/shell.pdf)  
[Apprendre à rédiger des scripts sous bash](https://debian-facile.org/doc:programmation:shells:debuter-avec-les-scripts-shell-bash)


Architecture (with [uname](https://linuxhandbook.com/uname/))
```bash
uname -a
```

Kernel (with [uname](https://linuxhandbook.com/uname/))
```bash
uname --kernel-release
```
- Architecture of the operating system (with [uname](https://linuxhandbook.com/uname/))
```bash
archi=$(uname -a)
```
- number of physical processors (with [lscpu](https://www.howtoforge.com/linux-lscpu-command/))
```bash
proc_phys=$(lscpu | grep 'CPU(s):' | awk '{print $2}') 
```
- number of virtual processors
```bash
proc_virt=$(grep '^processor' /proc/cpuinfo | wc -l)
```
- current available ram and its utilisation rate as percentage
```bash
ram_total=$(free --si --mega | grep Mem | awk '{print $2}')
ram_used=$(free --si --mega | grep Mem | awk '{print $3}')
ram_percent=$(free --si --mega |grep Mem | awk '{printf("%.2d %%", 100 * $3 / $2)}')
```
- current available memory and its utilisation rate as percentage
```bash
disk_total=$(df --si --total | grep total | awk '{print $2}')
disk_used=$(df --si --total | grep total | awk '{print $3}')
disk_percent=$(df --total | grep total | awk '{print $5}')
```
- current processor utilisation rate as percentage
```bash
cpu_use=$(top -bn1 | grep '%Cpu(s)' | awk '{printf("%.1f %%", $2 + $6)}')
```
- date and time of last reboot (WITH [who](https://www.man7.org/linux/man-pages/man1/who.1.html))
```bash
last_boot=$(who --boot | awk '{print $3 " " $4}')
```
- wheter LVM is active or not
```bash
lvm_nbr=$(lsblk | grep lvm | wc -l)
lvm_use=$(if [$lvm_nbr -eq 0]; then echo no; else echo yes; fi)
```
- number of active connection
```bash
tcp=$(ss -t | grep ESTAB | wc -l)
```
- Number of users using the server
```bash
users_logged=$(who --users | wc -l)
```
- IPv4 adress of the server
```bash
IPV4=$(hostname -I)
```
- MAC adress of the server
```bash
MAC=$(ip link show | grep 'link/ether' | awk '{print $2}')
```
- number of command executed with sudo program
```bash
sudo_used=$(grep COMMAND /var/log/sudo/sudo.log | wc -l)
```

##### Commande used :
- [uname](https://linuxhandbook.com/uname/)
- [grep](https://fr.manpages.org/grep)
- [awk](https://linux-man.fr/index.php/2020/08/08/commande-awk/)
- [free](https://www.man7.org/linux/man-pages/man1/free.1.html)
- [ifconfig](https://www.man7.org/linux/man-pages/man1/free.1.html)
- 
- [wc](https://www.man7.org/linux/man-pages/man1/wc.1.html)
- [ip](https://www.man7.org/linux/man-pages/man8/ip.8.html)
- [ss](https://www.man7.org/linux/man-pages/man8/ss.8.html), [cyberciti.biz](https://www.cyberciti.biz/tips/linux-investigate-sockets-network-connections.html)
- [wall](https://www.man7.org/linux/man-pages/man1/wall.1.html)

#### Other
- [mcombeau](https://github.com/mcombeau/Born2beroot/blob/main/monitoring.sh)
- [viruskizz](https://github.com/viruskizz/42Bangkok-Born2beroot/blob/main/monitor.sh)
- 