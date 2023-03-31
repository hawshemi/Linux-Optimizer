#!/bin/sh


# Intro
echo 
echo "This script will automatically Optimize the Ubuntu Server."
echo "Root access is required." 
echo "Source is @ https://github.com/hawshemi/" 
echo 
sleep 2


# Check Root User
check_if_running_as_root() {
  # If you want to run as another user, please modify $EUID to be owned by this user
  if [[ "$EUID" -ne '0' ]]; then
    echo "Error: You must run this script as root!"
    exit 1
  fi
}

# Detect if OS is Ubuntu
ID= grep -ioP '^ID=\K.+' /etc/os-release
if ! [[ $ID = "ubuntu" ]]; then
    echo "Not Ubuntu"
    exit 1
fi

# Update & Upgrade & Remove & Clean
sudo apt update 
sleep 0.5
sudo apt -y upgrade
sleep 0.5
sudo apt -y dist-upgrade
sleep 0.5
sudo apt -y autoremove
sleep 0.5
sudo apt -y autoclean
sleep 1


# Install useful packages
sudo apt -y install software-properties-common ufw wget snap snapd jq qrencode curl iptables lsb-release ca-certificates ubuntu-keyring gnupg2 preload locales nano apt-utils git socat cron busybox bash-completion
sleep 0.5


# Snap Install
sudo snap install core
sudo snap refresh core
sleep 1


## SWAP
# 2 GB Swap Size
SWAP_SIZE=2G

# Default Swap Path
SWAP_PATH="/swapfile"

# Run
sudo fallocate -l $SWAP_SIZE $SWAP_PATH  # Allocate size
sudo chmod 600 $SWAP_PATH                # Set proper permission
sudo mkswap $SWAP_PATH                   # Setup swap         
sudo swapon $SWAP_PATH                   # Enable swap
echo "$SWAP_PATH   none    swap    sw    0   0" | sudo tee -a /etc/fstab # Add to fstab
sleep 1


## SYSCTL Optimize
# Paths
SYS_PATH="/etc/sysctl.conf"
LIM_PATH="/etc/security/limits.conf"

# Optimize Swap Settings
echo 'vm.swappiness=10' | tee -a $SYS_PATH
echo 'vm.vfs_cache_pressure=50' | tee -a $SYS_PATH
sleep 0.5

# Optimize Network Settings
echo 'fs.file-max = 51200' | tee -a $SYS_PATH

echo 'net.core.rmem_default = 1048576' | tee -a $SYS_PATH
echo 'net.core.rmem_max = 2097152' | tee -a $SYS_PATH
echo 'net.core.wmem_default = 1048576' | tee -a $SYS_PATH
echo 'net.core.wmem_max = 2097152' | tee -a $SYS_PATH

echo 'net.core.netdev_max_backlog = 250000' | tee -a $SYS_PATH
echo 'net.core.somaxconn = 3000' | tee -a $SYS_PATH

echo 'net.ipv4.tcp_fastopen = 3' | tee -a $SYS_PATH

echo 'net.ipv4.tcp_mtu_probing = 1' | tee -a $SYS_PATH

echo 'net.core.default_qdisc = fq' | tee -a $SYS_PATH
echo 'net.ipv4.tcp_congestion_control = bbr' | tee -a $SYS_PATH


# Changing the UFW config to use System config.
sed -i 's+/etc/ufw/sysctl.conf+/etc/sysctl.conf+gI' /etc/default/ufw
sleep 0.5


# Optimize the Limits
echo '* soft     nproc          655350' | tee -a $LIM_PATH
echo '* hard     nproc          655350' | tee -a $LIM_PATH
echo '* soft     nofile         655350' | tee -a $LIM_PATH
echo '* hard     nofile         655350' | tee -a $LIM_PATH

echo 'root soft     nproc          655350' | tee -a $LIM_PATH
echo 'root hard     nproc          655350' | tee -a $LIM_PATH
echo 'root soft     nofile         655350' | tee -a $LIM_PATH
echo 'root hard     nofile         655350' | tee -a $LIM_PATH

sudo sysctl -p
sleep 1


# Firewall Allow
sudo ufw allow 21
sudo ufw allow 21/udp
sudo ufw allow 22
sudo ufw allow 22/udp
sudo ufw allow 80
sudo ufw allow 80/udp
sudo ufw allow 443
sudo ufw allow 443/udp


# Outro
echo 
echo 
echo "Done! Server is Optimized."
echo "Reboot in 5 seconds..."
sudo sleep 5 ; reboot
echo 
echo 
