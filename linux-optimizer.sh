#!/bin/bash

# Check the OS and store the result in the variable 'OS'
if [[ $(grep -oP '(?<=^NAME=").*(?=")' /etc/os-release) == "Ubuntu" ]]; then
    OS="ubuntu"
elif [[ $(grep -oP '(?<=^NAME=").*(?=")' /etc/os-release) == "CentOS Linux" ]]; then
    OS="centos"
elif [[ $(grep -oP '(?<=^NAME=").*(?=")' /etc/os-release) == "Debian GNU/Linux" ]]; then
    OS="debian"
elif [[ $(grep -oP '(?<=^NAME=").*(?=")' /etc/os-release) == "Fedora" ]]; then
    OS="fedora"
else
    echo "Unsupported OS, please create an issue to add support for this OS."
    OS="unknown"
fi

# Execute different commands depending on which OS is running
case $OS in
ubuntu)
    # Code for Ubuntu goes here
    bash <(curl -s https://raw.githubusercontent.com/hawshemi/Linux-Optimizer/main/ubuntu-optimizer.sh)
    ;;
debian)
    # Code for Debian goes here
    bash <(curl -s https://raw.githubusercontent.com/hawshemi/Linux-Optimizer/main/debian-optimizer.sh)
    ;;
centos)
    # Code for CentOS goes here
    bash <(curl -s https://raw.githubusercontent.com/hawshemi/Linux-Optimizer/main/centos-optimizer.sh)
    ;;
fedora)
    # Code for Fedora goes here
    bash <(curl -s https://raw.githubusercontent.com/hawshemi/Linux-Optimizer/main/fedora-optimizer.sh)
    ;;
unknown)
    # Code for unknown OS goes here
    exit 
    ;;
esac
