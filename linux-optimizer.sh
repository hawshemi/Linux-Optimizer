#!/bin/bash


# OS Detection
if [[ $(grep -oP '(?<=^NAME=").*(?=")' /etc/os-release) == "Ubuntu" ]]; then
    OS="ubuntu"
elif [[ $(grep -oP '(?<=^NAME=").*(?=")' /etc/os-release) == "Debian GNU/Linux" ]]; then
    OS="debian"
elif [[ $(grep -oP '(?<=^NAME=").*(?=")' /etc/os-release) == "CentOS Stream" ]]; then
    OS="centos"
elif [[ $(grep -oP '(?<=^NAME=").*(?=")' /etc/os-release) == "Fedora Linux" ]]; then
    OS="fedora"
else
    echo "Unknwon OS, Create an issue here: https://github.com/hawshemi/Linux-Optimizer"
    OS="unknown"
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
