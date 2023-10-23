#!/bin/bash


clear


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


# Paths
HOST_PATH="/etc/hosts"
DNS_PATH="/etc/resolv.conf"


# Intro
echo 
green_msg '================================================================='
green_msg 'This script will automatically Optimize your Linux Server.'
green_msg 'Tested on: Ubuntu 20+, Debian 11+, CentOS stream 8+, AlmaLinux 8+, Fedora 37+'
green_msg 'Root access is required.' 
green_msg 'Source is @ https://github.com/hawshemi/linux-optimizer' 
green_msg '================================================================='
echo 


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


# Install dependencies
install_dependencies_debian_based() {
  echo 
  yellow_msg 'Installing Dependencies...'
  echo 
  sleep 0.5
  
  apt update -q
  apt install -y wget curl sudo jq

  echo
  green_msg 'Dependencies Installed.'
  echo 
  sleep 0.5
}


# Install dependencies
install_dependencies_rhel_based() {
  echo 
  yellow_msg 'Installing Dependencies...'
  echo 
  sleep 0.5

  # dnf up -y
  dnf install -y wget curl sudo jq
  
  echo
  green_msg 'Dependencies Installed.'
  echo 
  sleep 0.5
}


# Fix Hosts file
fix_etc_hosts(){ 
  echo 
  yellow_msg "Fixing Hosts file."
  sleep 0.5

  cp $HOST_PATH /etc/hosts.bak
  yellow_msg "Default hosts file saved. Directory: /etc/hosts.bak"
  sleep 0.5

  if ! grep -q $(hostname) $HOST_PATH; then
    echo "127.0.1.1 $(hostname)" | sudo tee -a $HOST_PATH > /dev/null
    green_msg "Hosts Fixed."
    echo 
    sleep 0.5
  else
    green_msg "Hosts OK. No changes made."
    echo 
    sleep 0.5
  fi
}


# Fix DNS
fix_dns(){
    echo 
    yellow_msg "Fixing DNS Temporarily."
    sleep 0.5

    cp $DNS_PATH /etc/resolv.conf.bak
    yellow_msg "Default resolv.conf file saved. Directory: /etc/resolv.conf.bak"
    sleep 0.5

    sed -i '/nameserver/d' $DNS_PATH

    echo "nameserver 1.1.1.1" >> $DNS_PATH
    echo "nameserver 1.0.0.1" >> $DNS_PATH
    echo "nameserver 8.8.8.8" >> $DNS_PATH
    echo "nameserver 8.8.4.4" >> $DNS_PATH

    green_msg "DNS Fixed Temporarily."
    echo 
    sleep 0.5
}


# Timezone
set_timezone() {
    echo
    yellow_msg 'Setting TimeZone based on VPS IP address...'
    sleep 0.5

    get_public_ip() {
        local ip_sources=("https://ipv4.icanhazip.com" "https://api.ipify.org" "https://ipv4.ident.me/")
        local ip

        for source in "${ip_sources[@]}"; do
            ip=$(curl -s "$source")
            if [ -n "$ip" ]; then
                echo "$ip"
                return 0
            fi
        done

        red_msg "Error: Failed to fetch public IP address from known sources. Moving on..."
        return 1
    }

    public_ip=$(get_public_ip)

    if [ $? -eq 0 ]; then
        location_info=$(curl -s "http://ip-api.com/json/$public_ip")
        timezone=$(echo "$location_info" | jq -r '.timezone')

        sudo timedatectl set-timezone "$timezone"

        green_msg "Timezone set to $timezone"
    else
        red_msg "Error: Failed to fetch public IP address from known sources. Moving on..."
    fi

    echo
    sleep 0.5
}


# OS Detection
if [[ $(grep -oP '(?<=^NAME=").*(?=")' /etc/os-release) == "Ubuntu" ]]; then
    OS="ubuntu"
    echo 
    sleep 0.5
    yellow_msg "OS: Ubuntu"
    echo 
    sleep 0.5
elif [[ $(grep -oP '(?<=^NAME=").*(?=")' /etc/os-release) == "Debian GNU/Linux" ]]; then
    OS="debian"
    echo 
    sleep 0.5
    yellow_msg "OS: Debian"
    echo 
    sleep 0.5
elif [[ $(grep -oP '(?<=^NAME=").*(?=")' /etc/os-release) == "CentOS Stream" ]]; then
    OS="centos"
    echo 
    sleep 0.5
    yellow_msg "OS: Centos Stream"
    echo 
    sleep 0.5
elif [[ $(grep -oP '(?<=^NAME=").*(?=")' /etc/os-release) == "AlmaLinux" ]]; then
    OS="almalinux"
    echo 
    sleep 0.5
    yellow_msg "OS: AlmaLinux"
    echo 
    sleep 0.5
elif [[ $(grep -oP '(?<=^NAME=").*(?=")' /etc/os-release) == "Fedora Linux" ]]; then
    OS="fedora"
    echo 
    sleep 0.5
    yellow_msg "OS: Fedora"
    echo 
    sleep 0.5
else
    echo 
    sleep 0.5
    red_msg "Unknown OS, Create an issue here: https://github.com/hawshemi/Linux-Optimizer"
    OS="unknown"
    echo 
    sleep 2
fi


## Run

# Install dependencies
if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
    install_dependencies_debian_based
elif [[ "$OS" == "centos" || "$OS" == "fedora" || "$OS" == "almalinux" ]]; then
    install_dependencies_rhel_based
fi


# Fix Hosts file
fix_etc_hosts
sleep 0.5

# Fix DNS
fix_dns
sleep 0.5

# Timezone
set_timezone
sleep 0.5


# Run Script based on Distros
case $OS in
ubuntu)
    # Ubuntu
    wget "https://raw.githubusercontent.com/hawshemi/Linux-Optimizer/main/scripts/ubuntu-optimizer.sh" -q -O ubuntu-optimizer.sh && chmod +x ubuntu-optimizer.sh && bash ubuntu-optimizer.sh 
    ;;
debian)
    # Debian
    wget "https://raw.githubusercontent.com/hawshemi/Linux-Optimizer/main/scripts/debian-optimizer.sh" -q -O debian-optimizer.sh && chmod +x debian-optimizer.sh && bash debian-optimizer.sh 
    ;;
centos)
    # CentOS
    wget "https://raw.githubusercontent.com/hawshemi/Linux-Optimizer/main/scripts/centos-optimizer.sh" -q -O centos-optimizer.sh && chmod +x centos-optimizer.sh && bash centos-optimizer.sh 
    ;;
almalinux)
    # AlmaLinux
    wget "https://raw.githubusercontent.com/hawshemi/Linux-Optimizer/main/scripts/centos-optimizer.sh" -q -O almalinux-optimizer.sh && chmod +x almalinux-optimizer.sh && bash almalinux-optimizer.sh 
    ;;
fedora)
    # Fedora
    wget "https://raw.githubusercontent.com/hawshemi/Linux-Optimizer/main/scripts/fedora-optimizer.sh" -q -O fedora-optimizer.sh && chmod +x fedora-optimizer.sh && bash fedora-optimizer.sh 
    ;;
unknown)
    # Unknown
    exit 
    ;;
esac

