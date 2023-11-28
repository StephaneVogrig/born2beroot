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


