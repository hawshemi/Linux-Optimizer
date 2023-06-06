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


# Intro
echo 
green_msg '======================================================='
green_msg 'This script will automatically Optimize your Linux Server.'
green_msg 'Tested on: Ubuntu 16+, Debian 11+, CentOS 8+, Fedora 37+'
green_msg 'Root access is required.' 
green_msg 'Source is @ https://github.com/hawshemi/linux-optimizer' 
green_msg '======================================================='
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


# OS Detection
if [[ $(grep -oP '(?<=^NAME=").*(?=")' /etc/os-release) == "Ubuntu" ]]; then
    OS="ubuntu"
    echo 
    sleep 0.5
    yellow_msg "OS: Ubuntu"
    echo 
    sleep 2
elif [[ $(grep -oP '(?<=^NAME=").*(?=")' /etc/os-release) == "Debian GNU/Linux" ]]; then
    OS="debian"
    echo 
    sleep 0.5
    yellow_msg "OS: Debian"
    echo 
    sleep 2
elif [[ $(grep -oP '(?<=^NAME=").*(?=")' /etc/os-release) == "CentOS Stream" ]]; then
    OS="centos"
    echo 
    sleep 0.5
    yellow_msg "OS: Centos"
    echo 
    sleep 2
elif [[ $(grep -oP '(?<=^NAME=").*(?=")' /etc/os-release) == "Fedora Linux" ]]; then
    OS="fedora"
    echo 
    sleep 0.5
    yellow_msg "OS: Fedora"
    echo 
    sleep 2
else
    echo 
    sleep 0.5
    red_msg "Unknwon OS, Create an issue here: https://github.com/hawshemi/Linux-Optimizer"
    OS="unknown"
    echo 
    sleep 1
fi


# Run Script based on Distros
case $OS in
ubuntu)
    # Ubuntu
    bash <(curl -s https://raw.githubusercontent.com/hawshemi/Linux-Optimizer/main/scripts/ubuntu-optimizer.sh)
    ;;
debian)
    # Debian
    bash <(curl -s https://raw.githubusercontent.com/hawshemi/Linux-Optimizer/main/scripts/debian-optimizer.sh)
    ;;
centos)
    # CentOS
    bash <(curl -s https://raw.githubusercontent.com/hawshemi/Linux-Optimizer/main/scripts/centos-optimizer.sh)
    ;;
fedora)
    # Fedora
    bash <(curl -s https://raw.githubusercontent.com/hawshemi/Linux-Optimizer/main/scripts/fedora-optimizer.sh)
    ;;
unknown)
    # Unknown
    exit 
    ;;
esac
