#!/bin/bash

date=$(date)

# Hardware

archi=$(lscpu | grep Architecture | awk '{print $2}')
proc_phys=$(lscpu | grep 'Socket(s):' | awk '{print $2}')
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

sudo_users=$(getent group sudo | cut -d:$WHITE -f4)
sudo_used=$(grep COMMAND /var/log/sudo/sudo.log | wc -l)

# color

GREEN="\e[0;32m"
YELLOW="\e[1;33m"
WHITE="\e[0;37m"
PURPPLE="\e[1;35m"
RESET="\033[0m"

echo "$YELLOW-----------------------------------------------------------------------------"
echo ""
echo "$PURPPLE                         $date"
echo ""
echo "$YELLOW- Hardware ------------------------------------------------------------------"
echo ""
echo "$GREEN    architecture       :$WHITE$WHITE $archi"
echo "$GREEN    Physical CPUs      :$WHITE $proc_phys"
echo "$GREEN    Virtual CPUs       :$WHITE $proc_virt"
echo "$GREEN    CPU usage          :$WHITE $cpu_use"
echo "$GREEN    RAM usage          :$WHITE $ram_used/$ram_total Mo ($ram_percent)"
echo "$GREEN    Disk usage         :$WHITE $disk_used/$disk_total Go ($disk_percent)"
echo "$GREEN    LVM use            :$WHITE $lvm_use"
echo "$GREEN    Last boot          :$WHITE $last_boot"
echo ""
echo "$YELLOW- System --------------------------------------------------------------------"
echo ""
echo "$GREEN    Operating system   :$WHITE $os"
echo "$GREEN    kernel release     :$WHITE $kernel_r"
echo "$GREEN    Kernel version     :$WHITE $kernel_v"
echo ""
echo "$YELLOW- Network -------------------------------------------------------------------"
echo ""
echo "$GREEN    Hostname           :$WHITE $hostname"
echo "$GREEN    MAC adress         :$WHITE $MAC"
echo "$GREEN    IPV4 adress        :$WHITE $IPV4"
echo "$GREEN    TCP connection     :$WHITE $tcp"
echo "$GREEN    Users logged       :$WHITE $users_logged"
echo ""
echo "$YELLOW- Sudo ----------------------------------------------------------------------"
echo ""
echo "$GREEN    Users              :$WHITE $sudo_users"
echo "$GREEN    Sudo commands used :$WHITE $sudo_used"
echo ""
echo "$YELLOW-----------------------------------------------------------------------------"
echo "$RESET"
