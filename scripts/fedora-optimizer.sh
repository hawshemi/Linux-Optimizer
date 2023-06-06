#!/bin/bash
# https://github.com/hawshemi/Linux-optimizer


# Green, Yellow & Red Messages.
green_msg() {
    tput setaf 2
    echo "[*] ----- $1"
    tput sgr0
}

yellow_msg() {
    tput setaf 3
    echo "[*] ----- $1"
    tput sgr0
}

red_msg() {
    tput setaf 1
    echo "[*] ----- $1"
    tput sgr0
}


# Declare Paths & Settings.
SYS_PATH="/etc/sysctl.conf"
LIM_PATH="/etc/security/limits.conf"
PROF_PATH="/etc/profile"
SSH_PATH="/etc/ssh/sshd_config"
SWAP_PATH="/swapfile"
SWAP_SIZE=2G


# Ask Reboot
ask_reboot() {
    yellow_msg 'Reboot now? (Recommended) (y/n)'
    while true; do
        read choice
        if [[ "$choice" == 'y' || "$choice" == 'Y' ]]; then
            sleep 0.5
            reboot
            exit 0
        fi
        if [[ "$choice" == 'n' || "$choice" == 'N' ]]; then
            break
        fi
    done
}


# Timezone
set_timezone() {
    echo 
    yellow_msg 'Setting TimeZone to Asia/Tehran.'
    echo
    sleep 0.5

    timedatectl set-timezone Asia/Tehran

    echo 
    green_msg 'TimeZone set to Asia/Tehran.'
    echo
    sleep 0.5
}


# Update & Upgrade & Remove & Clean
complete_update() {
    echo 
    yellow_msg 'Updating the System.'
    echo 
    sleep 0.5

    sudo dnf -y upgrade
    sudo dnf -y autoremove
    sudo dnf -y clean all
    sleep 0.5
    
    # Again :D
    sudo dnf -y upgrade
    sudo dnf -y autoremove
    
    echo 
    green_msg 'System Updated Successfully.'
    echo 
    sleep 0.5
}


## Install useful packages
installations() {
    echo 
    yellow_msg 'Installing Useful Packeges.'
    echo 
    sleep 0.5

    # Purge firewalld to install UFW.
    sudo dnf -y remove firewalld

    # Install
    sudo dnf -y install nftables iptables iptables-services ca-certificates gnupg2 bash-completion 
    sudo dnf -y install ufw curl git zip unzip wget nano vim python3 python3-pip jq qrencode haveged socat net-tools dialog htop
    sudo dnf -y install bc binutils PackageKit make automake autoconf libtool
    
    echo 
    green_msg 'Useful Packages Installed Succesfully.'
    echo 
    sleep 0.5
}


# Enable packages at server boot
enable_packages() {
    sudo systemctl enable haveged
    echo 
    green_msg 'Packages Enabled Succesfully.'
    echo
    sleep 0.5
}


## Swap Maker
swap_maker() {
    echo 
    yellow_msg 'Making SWAP Space.'
    echo 
    sleep 0.5

    # Make Swap
    sudo fallocate -l $SWAP_SIZE $SWAP_PATH  # Allocate size
    sudo chmod 600 $SWAP_PATH                # Set proper permission
    sudo mkswap $SWAP_PATH                   # Setup swap         
    sudo swapon $SWAP_PATH                   # Enable swap
    echo "$SWAP_PATH   none    swap    sw    0   0" >> /etc/fstab # Add to fstab
    echo 
    green_msg 'SWAP Created Successfully.'
    echo
    sleep 0.5
}


# Remove Old SYSCTL Config to prevent duplicates.
remove_old_sysctl() {
    sed -i '/fs.file-max/d' $SYS_PATH
    sed -i '/fs.inotify.max_user_instances/d' $SYS_PATH

    sed -i '/net.ipv4.tcp_window_scaling/d' $SYS_PATH
    sed -i '/net.ipv4.tcp_fastopen/d' $SYS_PATH

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
    sed -i '/net.ipv4.ip_forward/d' $SYS_PATH

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
    echo 
    yellow_msg 'Optimizing the Network.'
    echo 
    sleep 0.5

    # Optimize Swap Settings
    echo 'vm.swappiness=10' >> $SYS_PATH
    echo 'vm.vfs_cache_pressure=50' >> $SYS_PATH

    # Optimize Network Settings
    echo 'fs.file-max = 1000000' >> $SYS_PATH
    
    echo 'net.ipv4.tcp_window_scaling = 1' >> $SYS_PATH
    echo 'net.ipv4.tcp_fastopen = 3' >> $SYS_PATH

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
    echo 'net.ipv4.ip_forward = 1' | tee -a $SYS_PATH

    echo 'net.ipv6.conf.all.disable_ipv6 = 0' >> $SYS_PATH
    echo 'net.ipv6.conf.default.disable_ipv6 = 0' >> $SYS_PATH
    echo 'net.ipv6.conf.all.forwarding = 1' >> $SYS_PATH

    # Use BBR
    echo 'net.core.default_qdisc = fq' >> $SYS_PATH 
    echo 'net.ipv4.tcp_congestion_control = bbr' >> $SYS_PATH

    sysctl -p
    echo 
    green_msg 'Network is Optimized.'
    echo 
    sleep 0.5
}


# Remove old SSH config to prevent duplicates.
remove_old_ssh_conf() {
    # Make a backup of the original sshd_config file
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

    echo 
    yellow_msg 'Default SSH Config file Saved. Directory: /etc/ssh/sshd_config.bak'
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
    sed -i '/PermitRootLogin/d' $SSH_PATH
    sed -i '/AllowTcpForwarding/d' $SSH_PATH
    sed -i '/GatewayPorts/d' $SSH_PATH
    sed -i '/PermitTunnel/d' $SSH_PATH
}


## Update SSH config
update_sshd_conf() {
    echo 
    yellow_msg 'Optimizing SSH.'
    echo 
    sleep 0.5

    # Enable TCP keep-alive messages
    echo "TCPKeepAlive yes" | tee -a $SSH_PATH

    # Configure client keep-alive messages
    echo "ClientAliveInterval 3000" | tee -a $SSH_PATH
    echo "ClientAliveCountMax 100" | tee -a $SSH_PATH

    # Allow agent forwarding
    echo "AllowAgentForwarding yes" | tee -a $SSH_PATH

    #Permit Root Login
    echo "PermitRootLogin yes" | tee -a $SSH_PATH

    # Allow TCP forwarding
    echo "AllowTcpForwarding yes" | tee -a $SSH_PATH

    # Enable gateway ports
    echo "GatewayPorts yes" | tee -a $SSH_PATH

    # Enable tunneling
    echo "PermitTunnel yes" | tee -a $SSH_PATH

    # Restart the SSH service to apply the changes
    systemctl restart sshd

    echo 
    green_msg 'SSH is Optimized.'
    echo 
    sleep 0.5
}


# System Limits Optimizations
limits_optimizations() {
    echo
    yellow_msg 'Optimizing System Limits.'
    echo 
    sleep 0.5

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
    green_msg 'System Limits Optimized.'
    echo 
    sleep 0.5
}


## UFW Optimizations
ufw_optimizations() {
    echo
    yellow_msg 'Optimizing UFW.'
    echo 
    sleep 0.5

    # Disable UFW
    sudo ufw disable

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

    # Enable & Reload
    echo "y" | sudo ufw enable
    sudo ufw reload
    echo 
    green_msg 'Firewall is Optimized.'
    echo 
    sleep 0.5
}


# Show the Menu
show_menu() {
    echo 
    yellow_msg 'Choose One Option: '
    echo 
    green_msg '1 - Apply Everything. (RECOMMENDED)'
    echo 
    green_msg '2 - Everything Without Useful Packages.'
    green_msg '3 - Everything Without Useful Packages & UFW Optimizations.'
    green_msg '4 - Update the OS.'
    green_msg '5 - Make SWAP (2Gb).'
    green_msg '6 - Optimize the Network, SSH & System Limits.'
    green_msg '7 - Optimize UFW.'
    echo 
    red_msg 'q - Exit.'
    echo 
}


# Choosing Program
main() {
    while true; do
        show_menu
        read -p 'Enter Your Choice: ' choice
        case $choice in
        1)
            apply_everything

            echo 
            green_msg '========================='
            green_msg  'Done.'
            green_msg '========================='

            ask_reboot
            ;;
        2)
            complete_update
            sleep 0.5

            swap_maker
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
            sleep 0.5

            ufw_optimizations
            sleep 0.5

            echo 
            green_msg '========================='
            green_msg  'Done.'
            green_msg '========================='

            ask_reboot
            ;;
        3)
            complete_update
            sleep 0.5

            swap_maker
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
            sleep 0.5

            echo 
            green_msg '========================='
            green_msg  'Done.'
            green_msg '========================='

            ask_reboot
            ;;
        4)
            complete_update
            sleep 0.5


            echo 
            green_msg '========================='
            green_msg  'Done.'
            green_msg '========================='

            ask_reboot
            ;;
        5)
            swap_maker
            sleep 0.5

            echo 
            green_msg '========================='
            green_msg  'Done.'
            green_msg '========================='

            ask_reboot
            ;;
        6)
            remove_old_sysctl
            sleep 0.5

            sysctl_optimizations
            sleep 0.5

            remove_old_ssh_conf
            sleep 0.5

            update_sshd_conf
            sleep 0.5

            limits_optimizations
            sleep 0.5

            echo 
            green_msg '========================='
            green_msg  'Done.'
            green_msg '========================='

            ask_reboot
            ;;
        7)
            ufw_optimizations
            sleep 0.5

            echo 
            green_msg '========================='
            green_msg  'Done.'
            green_msg '========================='

            ask_reboot
            ;;
        q)
            exit 0
            ;;

        *)
            red_msg 'Wrong input!'
            ;;
        esac
    done
}


# Apply Everything
apply_everything() {

    set_timezone
    sleep 0.5

    complete_update
    sleep 0.5

    installations
    sleep 0.5

    enable_packages
    sleep 0.5

    swap_maker
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
    sleep 0.5

    ufw_optimizations
    sleep 0.5
}


main
