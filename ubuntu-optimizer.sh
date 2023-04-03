#!/bin/sh


# Intro
echo 
echo $(tput setaf 2)=======================================================$(tput sgr0)
echo "$(tput setaf 2)----- This script will automatically Optimize your Ubuntu Server.$(tput sgr0)"
echo "$(tput setaf 2)----- Root access is required.$(tput sgr0)" 
echo "$(tput setaf 2)----- Source is @ https://github.com/samsesh/ubuntu-optimizer$(tput sgr0)" 
echo $(tput setaf 2)=======================================================$(tput sgr0)
echo 

sleep 1


# Declare Paths
SYS_PATH="/etc/sysctl.conf"
LIM_PATH="/etc/security/limits.conf"
PROF_PATH="/etc/profile"
SSH_PATH="/etc/ssh/sshd_config"


# Check Root User
check_if_running_as_root() {
  # If you want to run as another user, please modify $EUID to be owned by this user
  if [[ "$EUID" -ne '0' ]]; then
    echo "$(tput setaf 1)Error: You must run this script as root!$(tput sgr0)"
    exit 1
  fi
}


# Check if OS is Ubuntu
check_ubuntu() {
  if [[ $(lsb_release -si) != "Ubuntu" ]]; then
    echo "$(tput setaf 1)Error: This script is only intended to run on Ubuntu.$(tput sgr0)"
    exit 1
  fi
}


# Update & Upgrade & Remove & Clean
complete_update() {
  sudo apt update
  sudo apt -y upgrade
  sleep 0.5
  sudo apt -y dist-upgrade
  sudo apt -y autoremove
  sudo apt -y autoclean
  sudo apt -y clean
}


## Install useful packages
installations() {
  # Purge firewalld to install UFW.
  sudo apt -y purge firewalld

  # Install
  sudo apt -y install software-properties-common apt-transport-https snapd snap iptables lsb-release ca-certificates ubuntu-keyring gnupg2 apt-utils cron bash-completion curl git unzip ufw wget preload locales nano vim python3 jq qrencode socat busybox net-tools haveged htop
  sleep 0.5

  # Snap Install & Refresh
  sudo snap install core
  sudo snap refresh core
}


# Enable packages at server boot
enable_packages() {
  sudo systemctl enable preload haveged snapd cron
}


## Swap Maker
swap_maker() {
  # 2 GB Swap Size
  SWAP_SIZE=2G

  # Default Swap Path
  SWAP_PATH="/swapfile"

  # Make Swap
  sudo fallocate -l $SWAP_SIZE $SWAP_PATH  # Allocate size
  sudo chmod 600 $SWAP_PATH                # Set proper permission
  sudo mkswap $SWAP_PATH                   # Setup swap         
  sudo swapon $SWAP_PATH                   # Enable swap
  echo "$SWAP_PATH   none    swap    sw    0   0" >> /etc/fstab # Add to fstab
  echo $(tput setaf 2)SWAP Optimized.$(tput sgr0)
  echo
  
}

enable_ipv6_support() {
    if [[ $(sysctl -a | grep 'disable_ipv6.*=.*1') || $(cat /etc/sysctl.{conf,d/*} | grep 'disable_ipv6.*=.*1') ]]; then
        sed -i '/disable_ipv6/d' /etc/sysctl.{conf,d/*}
        echo 'net.ipv6.conf.all.disable_ipv6 = 0' >/etc/sysctl.d/ipv6.conf
        sysctl -w net.ipv6.conf.all.disable_ipv6=0
    fi
}

# Remove Old SYSCTL Config to prevent duplicates.
remove_old_sysctl() {
  sed -i '/fs.file-max/d' $SYS_PATH
  sed -i '/fs.inotify.max_user_instances/d' $SYS_PATH

  sed -i '/net.ipv4.tcp_syncookies/d' $SYS_PATH
  sed -i '/net.ipv4.tcp_fin_timeout/d' $SYS_PATH
  sed -i '/net.ipv4.tcp_tw_reuse/d' $SYS_PATH
  sed -i '/net.ipv4.ip_local_port_range/d' $SYS_PATH
  sed -i '/net.ipv4.tcp_max_syn_backlog/d' $SYS_PATH
  sed -i '/net.ipv4.tcp_max_tw_buckets/d' $SYS_PATH
  sed -i '/net.ipv4.route.gc_timeout/d' $SYS_PATH

  sed -i '/net.ipv4.tcp_syn_retries/d' $SYS_PATH
  sed -i '/net.ipv4.tcp_synack_retries/d' $SYS_PATH
  sed -i '/net.core.somaxconn/d' $SYS_PATH
  sed -i '/net.core.netdev_max_backlog/d' $SYS_PATH
  sed -i '/net.ipv4.tcp_timestamps/d' $SYS_PATH
  sed -i '/net.ipv4.tcp_max_orphans/d' $SYS_PATH
  #IPv6
  sed -i '/net.ipv6.conf.all.disable_ipv6/d' $SYS_PATH
  sed -i '/net.ipv6.conf.default.disable_ipv6/d' $SYS_PATH
  sed -i '/net.ipv6.conf.all.forwarding/d' $SYS_PATH
  # System Limits.
  sed -i '/soft/d' $LIM_PATH
  sed -i '/hard/d' $LIM_PATH
  # BBR
  sed -i '/net.core.default_qdisc/d' $SYS_PATH
  sed -i '/net.ipv4.tcp_congestion_control/d' $SYS_PATH
  sed -i '/net.ipv4.tcp_ecn/d' $SYS_PATH
  # uLimit
  sed -i '/1000000/d' $PROF_PATH
  #SWAP
  sed -i '/vm.swappiness/d' $SYS_PATH
  sed -i '/vm.vfs_cache_pressure/d' $SYS_PATH

}


## SYSCTL Optimization
sysctl_optimizations() {
  # Optimize Swap Settings
  echo 'vm.swappiness=10' >> $SYS_PATH
  echo 'vm.vfs_cache_pressure=50' >> $SYS_PATH
  sleep 0.5

  # Optimize Network Settings
  echo 'fs.file-max = 1000000' >> $SYS_PATH

  echo 'net.core.rmem_default = 1048576' >> $SYS_PATH
  echo 'net.core.rmem_max = 2097152' >> $SYS_PATH
  echo 'net.core.wmem_default = 1048576' >> $SYS_PATH
  echo 'net.core.wmem_max = 2097152' >> $SYS_PATH
  echo 'net.core.netdev_max_backlog = 16384' >> $SYS_PATH
  echo 'net.core.somaxconn = 32768' >> $SYS_PATH
  echo 'net.ipv4.tcp_fastopen = 3' >> $SYS_PATH
  echo 'net.ipv4.tcp_mtu_probing = 1' >> $SYS_PATH

  echo 'net.ipv4.tcp_retries2 = 8' >> $SYS_PATH
  echo 'net.ipv4.tcp_slow_start_after_idle = 0' >> $SYS_PATH

  echo 'net.ipv6.conf.all.disable_ipv6 = 0' >> $SYS_PATH
  echo 'net.ipv6.conf.default.disable_ipv6 = 0' >> $SYS_PATH
  echo 'net.ipv6.conf.all.forwarding = 1' >> $SYS_PATH

  # Use BBR
  echo 'net.core.default_qdisc = fq' >> $SYS_PATH 
  echo 'net.ipv4.tcp_congestion_control = bbr' >> $SYS_PATH

  sysctl -p
  echo 
  echo $(tput setaf 2)Network Optimized.$(tput sgr0)
  echo 
}


# Remove old SSH config to prevent duplicates.
remove_old_ssh_conf() {
  # Make a backup of the original sshd_config file
  cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

  echo 
  echo "$(tput setaf 2)Default SSH Config file Saved. Directory: /etc/ssh/sshd_config.bak$(tput sgr0)"
  echo 
  sleep 1
  
  # Disable DNS lookups for connecting clients
  sed -i 's/#UseDNS yes/UseDNS no/' $SSH_PATH

  # Enable compression for SSH connections
  sed -i 's/#Compression no/Compression yes/' $SSH_PATH

  # Remove less efficient encryption ciphers
  sed -i 's/Ciphers .*/Ciphers aes256-ctr,chacha20-poly1305@openssh.com/' $SSH_PATH

  # Remove these lines
  sed -i '/MaxAuthTries/d' $SSH_PATH
  sed -i '/MaxSessions/d' $SSH_PATH
  sed -i '/TCPKeepAlive/d' $SSH_PATH
  sed -i '/ClientAliveInterval/d' $SSH_PATH
  sed -i '/ClientAliveCountMax/d' $SSH_PATH
  sed -i '/AllowAgentForwarding/d' $SSH_PATH
  sed -i '/AllowTcpForwarding/d' $SSH_PATH
  sed -i '/GatewayPorts/d' $SSH_PATH
  sed -i '/PermitTunnel/d' $SSH_PATH

}


## Update SSH config
update_sshd_conf() {
  # Enable TCP keep-alive messages
  echo "TCPKeepAlive yes" | tee -a $SSH_PATH

  # Configure client keep-alive messages
  echo "ClientAliveInterval 3000" | tee -a $SSH_PATH
  echo "ClientAliveCountMax 100" | tee -a $SSH_PATH

  # Permit Root Login
  echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

  # Allow agent forwarding
  echo "AllowAgentForwarding yes" | tee -a $SSH_PATH

  # Allow TCP forwarding
  echo "AllowTcpForwarding yes" | tee -a $SSH_PATH

  # Enable gateway ports
  echo "GatewayPorts yes" | tee -a $SSH_PATH

  # Enable tunneling
  echo "PermitTunnel yes" | tee -a $SSH_PATH

  # Restart the SSH service to apply the changes
  service ssh restart

  echo 
  echo $(tput setaf 2)SSH Optimized Successfully!$(tput sgr0)
  echo 
}


# System Limits Optimizations
limits_optimizations() {
  echo '* soft     nproc          655350' >> $LIM_PATH
  echo '* hard     nproc          655350' >> $LIM_PATH
  echo '* soft     nofile         655350' >> $LIM_PATH
  echo '* hard     nofile         655350' >> $LIM_PATH

  echo 'root soft     nproc          655350' >> $LIM_PATH
  echo 'root hard     nproc          655350' >> $LIM_PATH
  echo 'root soft     nofile         655350' >> $LIM_PATH
  echo 'root hard     nofile         655350' >> $LIM_PATH

  sudo sysctl -p
  echo 
  echo $(tput setaf 2)System Limits Optimized.$(tput sgr0)
  echo 
}


## UFW Optimizations
ufw_optimizations() {
  # Open default ports.
  sudo ufw allow 21
  sudo ufw allow 21/udp
  sudo ufw allow 22
  sudo ufw allow 22/udp
  sudo ufw allow 80
  sudo ufw allow 80/udp
  sudo ufw allow 443
  sudo ufw allow 443/udp
  sleep 0.5
  # Change the UFW config to use System config.
  sed -i 's+/etc/ufw/sysctl.conf+/etc/sysctl.conf+gI' /etc/default/ufw
  # Reload
  ufw reload
  ufw status
  echo 
  echo $(tput setaf 2)Firewall Optimized.$(tput sgr0)
  echo 
}


# RUN BABY, RUN
check_if_running_as_root
sleep 0.5

check_ubuntu
sleep 0.5

complete_update
sleep 0.5

installations
sleep 0.5

enable_packages
sleep 0.5

swap_maker
sleep 0.5

enable_ipv6_support
sleep 0.5

remove_old_sysctl
sleep 0.5

sysctl_optimizations
sleep 0.5

remove_old_ssh_conf
sleep 0.5

update_sshd_conf
sleep 0.5

limits_optimizations
sleep 1

ufw_optimizations
sleep 0.5


# Outro
echo 
echo $(tput setaf 2)=========================$(tput sgr0)
echo "$(tput setaf 2)----- Done! Server is Optimized.$(tput sgr0)"
echo "$(tput setaf 3)----- Reboot the system to apply one...$(tput sgr0)"
echo $(tput setaf 2)=========================$(tput sgr0)
sudo sleep 5 ;
echo 
echo 
