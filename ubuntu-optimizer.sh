#!/bin/sh


# Intro
echo 
echo "This script will automatically Optimize the Server."
echo "Root access is required." 
echo "Source is @ https://github.com/hawshemi/" 
echo 

sleep 2

# Update & Upgrade & Remove & Clean
sudo apt update 
sleep 1
sudo apt -y upgrade
sleep 1
sudo apt -y dist-upgrade
sleep 1
sudo apt -y autoremove
sleep 1
sudo apt -y autoclean
sleep 1

# Install useful packages
sudo apt -y install software-properties-common ufw wget snap snapd jq qrencode curl iptables lsb-release ca-certificates ubuntu-keyring gnupg2 preload locales nano apt-utils git socat cron busybox bash-completion
sleep 0.5

# Snap Install
sudo snap install core
sudo snap refresh core
sleep 1

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

SYS_PATH="/etc/sysctl.conf"
UFW_PATH="/etc/ufw/sysctl.conf"
LIM_PATH="/etc/security/limits.conf"

# Optimize Swap Settings
echo 'vm.swappiness=10' | tee -a $SYS_PATH
echo 'vm.vfs_cache_pressure=50' | tee -a $SYS_PATH

sleep 0.5

# Optimize Network Settings
echo 'fs.file-max = 51200' | tee -a $SYS_PATH | tee -a $UFW_PATH

echo 'net.core.rmem_default = 1048576' | tee -a $SYS_PATH | tee -a $UFW_PATH
echo 'net.core.rmem_max = 2097152' | tee -a $SYS_PATH | tee -a $UFW_PATH
echo 'net.core.wmem_default = 1048576' | tee -a $SYS_PATH | tee -a $UFW_PATH
echo 'net.core.wmem_max = 2097152' | tee -a $SYS_PATH | tee -a $UFW_PATH

echo 'net.core.netdev_max_backlog = 250000' | tee -a $SYS_PATH | tee -a $UFW_PATH
echo 'net.core.somaxconn = 3000' | tee -a $SYS_PATH | tee -a $UFW_PATH

echo 'net.ipv4.tcp_fastopen = 3' | tee -a $SYS_PATH | tee -a $UFW_PATH

echo 'net.ipv4.tcp_mtu_probing = 1' | tee -a $SYS_PATH | tee -a $UFW_PATH

echo 'net.core.default_qdisc = fq' | tee -a $SYS_PATH | tee -a $UFW_PATH
echo 'net.ipv4.tcp_congestion_control = bbr' | tee -a $SYS_PATH | tee -a $UFW_PATH

sleep 0.5

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

# Firewall Optimization
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
echo "Done! Server is Optimized."
echo "Reboot in 5 seconds..."
echo 
sudo sleep 5 ; reboot