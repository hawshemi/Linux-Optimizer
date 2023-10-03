#!/bin/bash
# https://github.com/hawshemi/Linux-Optimizer


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
SSH_PORT=$(awk '/^Port / {print $2}' /etc/ssh/sshd_config)

# Root
check_if_running_as_root() {
    # If you want to run as another user, please modify $EUID to be owned by this user
    if [[ "$EUID" -ne '0' ]]; then
      echo 
      red_msg 'Error: You must run this script as root!'
      echo 
      sleep 0.5
      exit 1
    fi
}


# Check Root
check_if_running_as_root
sleep 0.5


# Ask Reboot
ask_reboot() {
    yellow_msg 'Reboot now? (Recommended) (y/n)'
    echo 
    while true; do
        read choice
        echo 
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
    yellow_msg 'Setting TimeZone based on VPS IP address.'
    echo
    sleep 0.5

    public_ip=$(curl -s https://ipinfo.io/ip)

    location_info=$(curl -s "http://ip-api.com/json/$public_ip")

    timezone=$(echo "$location_info" | jq -r '.timezone')

    sudo timedatectl set-timezone "$timezone"

    echo 
    green_msg "Timezone set to $timezone"
    echo
    sleep 0.5
}


# Update & Upgrade & Remove & Clean
complete_update() {
    echo 
    yellow_msg 'Updating the System. (This can take a while...)'
    echo 
    sleep 0.5

    sudo apt -qq update
    sudo apt upgrade -y > /dev/null 2>&1
    sudo apt dist-upgrade -y > /dev/null 2>&1
    sudo apt autoremove -y > /dev/null 2>&1
    sleep 0.5

    # Again :D
    sudo apt -y -qq autoclean
    sudo apt -y clean
    sudo apt -qq update
    sudo apt upgrade -y > /dev/null 2>&1
    sudo apt dist-upgrade -y > /dev/null 2>&1
    sudo apt autoremove -y > /dev/null 2>&1

    echo 
    green_msg 'System Updated Successfully.'
    echo 
    sleep 0.5
}


## Install useful packages
installations() {
    echo 
    yellow_msg 'Installing Useful Packages.'
    echo 
    sleep 0.5

    # Networking packages
    sudo apt -q -y install apt-transport-https iptables iptables-persistent nftables

    # System utilities
    sudo apt -q -y install apt-utils bash-completion busybox ca-certificates cron curl gnupg2 locales lsb-release nano preload screen software-properties-common ufw unzip vim wget xxd zip

    # Programming and development tools
    sudo apt -q -y install autoconf automake bash-completion build-essential git libtool make pkg-config python3 python3-pip

    # Additional libraries and dependencies
    sudo apt -q -y install bc binutils binutils-common binutils-x86-64-linux-gnu debian-keyring haveged jq libsodium-dev libsqlite3-dev libssl-dev packagekit qrencode socat

    # Miscellaneous
    sudo apt -q -y install dialog htop net-tools

    echo 
    green_msg 'Useful Packages Installed Succesfully.'
    echo 
    sleep 0.5
}


# Enable packages at server boot
enable_packages() {
    sudo systemctl enable cron haveged nftables preload
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


## SYSCTL Optimization
sysctl_optimizations() {
    # Make a backup of the original sysctl.conf file
    cp $SYS_PATH /etc/sysctl.conf.bak

    echo 
    yellow_msg 'Default sysctl.conf file Saved. Directory: /etc/sysctl.conf.bak'
    echo 
    sleep 1

    echo 
    yellow_msg 'Optimizing the Network.'
    echo 
    sleep 0.5

    # Replace the new sysctl.conf file.
    wget "https://raw.githubusercontent.com/hawshemi/Linux-Optimizer/main/files/sysctl.conf" -q -O $SYS_PATH 

    sysctl -p
    echo 

    green_msg 'Network is Optimized.'
    echo 
    sleep 0.5
}


# Remove old SSH config to prevent duplicates.
remove_old_ssh_conf() {
    # Make a backup of the original sshd_config file
    cp $SSH_PATH /etc/ssh/sshd_config.bak

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
    sed -i '/AllowTcpForwarding/d' $SSH_PATH
    sed -i '/GatewayPorts/d' $SSH_PATH
    sed -i '/PermitTunnel/d' $SSH_PATH
    sed -i '/X11Forwarding/d' $SSH_PATH
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

    # Allow TCP forwarding
    echo "AllowTcpForwarding yes" | tee -a $SSH_PATH

    # Enable gateway ports
    echo "GatewayPorts yes" | tee -a $SSH_PATH

    # Enable tunneling
    echo "PermitTunnel yes" | tee -a $SSH_PATH

    # Enable X11 graphical interface forwarding
    echo "X11Forwarding yes" | tee -a $SSH_PATH

    # Restart the SSH service to apply the changes
    service ssh restart

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

    # Clear old ulimits
    sed -i '/ulimit -c/d' $PROF_PATH
    sed -i '/ulimit -d/d' $PROF_PATH
    sed -i '/ulimit -f/d' $PROF_PATH
    sed -i '/ulimit -i/d' $PROF_PATH
    sed -i '/ulimit -n/d' $PROF_PATH
    sed -i '/ulimit -q/d' $PROF_PATH
    sed -i '/ulimit -u/d' $PROF_PATH
    sed -i '/ulimit -v/d' $PROF_PATH
    sed -i '/ulimit -x/d' $PROF_PATH
    sed -i '/ulimit -s/d' $PROF_PATH
    sed -i '/ulimit -l/d' $PROF_PATH

    # Add new ulimits
    # The maximum size of core files created.
    echo "ulimit -c unlimited" | tee -a $PROF_PATH

    # The maximum size of a process's data segment
    echo "ulimit -d unlimited" | tee -a $PROF_PATH

    # The maximum size of files created by the shell (default option)
    echo "ulimit -f unlimited" | tee -a $PROF_PATH

    # The maximum number of pending signals
    echo "ulimit -i unlimited" | tee -a $PROF_PATH

    # The maximum number of open file descriptors
    echo "ulimit -n 999999" | tee -a $PROF_PATH

    # The maximum POSIX message queue size
    echo "ulimit -q unlimited" | tee -a $PROF_PATH

    # The maximum number of processes available to a single user
    echo "ulimit -u unlimited" | tee -a $PROF_PATH

    # The maximum amount of virtual memory available to the process
    echo "ulimit -v unlimited" | tee -a $PROF_PATH

    # The maximum number of file locks
    echo "ulimit -x unlimited" | tee -a $PROF_PATH

    # The maximum stack size
    echo "ulimit -s 8192" | tee -a $PROF_PATH

    # The maximum size that may be locked into memory
    echo "ulimit -l unlimited" | tee -a $PROF_PATH


    # Update the limits.conf
    wget "https://raw.githubusercontent.com/hawshemi/Linux-Optimizer/main/files/limits.conf" -q -O $LIM_PATH

    echo 
    green_msg 'System Limits are Optimized.'
    echo 
    sleep 0.5
}


## UFW Optimizations
ufw_optimizations() {
    echo
    yellow_msg 'Optimizing UFW.'
    echo 
    sleep 0.5

    # Purge firewalld to install UFW.
    sudo apt -y purge firewalld

    # Install UFW if it isn't installed.
    sudo apt install -y ufw

    # Disable UFW
    sudo ufw disable

    # Open default ports.
    sudo ufw allow 21
    sudo ufw allow 21/udp
    sudo ufw allow $SSH_PORT
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
    green_msg 'UFW is Optimized.'
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
    green_msg '5 - Install Useful Packages.'
    green_msg '6 - Make SWAP (2Gb).'
    green_msg '7 - Optimize the Network, SSH & System Limits.'
    green_msg '8 - Optimize UFW.'
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
            complete_update
            installations
            sleep 0.5

            echo 
            green_msg '========================='
            green_msg  'Done.'
            green_msg '========================='

            ask_reboot
            ;;
        6)
            swap_maker
            sleep 0.5

            echo 
            green_msg '========================='
            green_msg  'Done.'
            green_msg '========================='

            ask_reboot
            ;;
        7)

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
        8)
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

    complete_update
    sleep 0.5

    installations
    sleep 0.5

    enable_packages
    sleep 0.5

    set_timezone
    sleep 0.5

    swap_maker
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
