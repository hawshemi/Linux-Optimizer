# Linux Optimizer

## This Bash script automates the optimization of your Linux server.
### It performs the following tasks:
       
0. Fix `hosts` file and DNS _(temporarily)_:
    - Check and add 127.0.1.1 and server hostname to `/etc/hosts`.
    
    *Original `hosts` file is backed up at `/etc/hosts.bak`.*
    - Add `1.1.1.1`, `1.0.0.1`, `8.8.8.8` and `8.8.4.4` to `/etc/resolv.conf`.
    
    *Original `dns` file is backed up at `/etc/resolv.conf.bak`.*


1. Update, Upgrade, and Clean the server:
    - _Update_
    - _Upgrade_
    - _Full-Upgrade_
    - _AutoRemove_
    - _AutoClean_
    - _Clean_


2. Install XanMod LTS Kernel _(Only on Ubuntu & Debian)_:
    - Enable BBRv3.
    - CloudFlare TCP Optimizations.
    - More Details: https://xanmod.org


3. Install Useful Packages:

    _`apt-transport-https`_ _`apt-utils`_ _`autoconf`_ _`automake`_ _`bash-completion`_ _`bc`_ _`binutils`_ _`binutils-common`_ _`binutils-x86-64-linux-gnu`_ _`build-essential`_ _`busybox`_ _`ca-certificates`_ _`cron`_ _`curl`_ _`dialog`_ _`epel-release`_ _`gnupg2`_ _`git`_ _`haveged`_ _`htop`_ _`iptables`_ _`iptables-persistent`_ _`jq`_ _`keyring`_ _`libssl-dev`_ _`libsqlite3-dev`_ _`libtool`_ _`locales`_ _`lsb-release`_ _`make`_ _`nano`_ _`net-tools`_ _`nftables`_ _`packagekit`_ _`preload`_ _`python3`_ _`python3-pip`_ _`qrencode`_ _`socat`_ _`screen`_ _`software-properties-common`_ _`ufw`_ _`unzip`_ _`vim`_ _`wget`_ _`zip`_


4. Enable Packages at Server Boot.

    
5. Set the server TimeZone to the VPS IP address location.

 
6. Create & Enable `SWAP` File:
    - Swap Path: `"/swapfile"`
    - Swap Size: `2Gb`


7. Enable `IPv6` Support.


8. Optimize the [SYSCTL](https://github.com/hawshemi/Linux-Optimizer/blob/main/files/sysctl.conf) Configs:
    - Optimize `SWAP`.
    - Optimize Network Settings.
    - Activate `BBR` _(`BBRv3` with XanMod)_.
    - Optimize the Kernel.

    *Original file is backed up at `/etc/sysctl.conf.bak`.*

    
9. Optimize [SSH](https://github.com/hawshemi/Linux-Optimizer/blob/main/files/sshd_config):
    - Disable DNS lookups for connecting clients.
    - Remove less efficient encryption ciphers.
    - Enable and Configure TCP keep-alive messages.
    - Allow agent & TCP forwarding.
    - Enable gateway ports, Tunneling and compression.
    - Enable X11 Forwarding.

    *Original file is backed up at `/etc/ssh/sshd_config.bak`.*
   

10. Optimize the [System Limits](https://github.com/hawshemi/Linux-Optimizer/blob/main/files/profile):
    - Soft and Hard ulimit `-c -d -f -i -l -n -q -s -u -v -x` optimizations.
    
    
11. Optimize `UFW` and open Common Ports:
    - Open Ports `SSH`, `80`, `443`.
    - With `IPv6`, `TCP` & `UDP`.

    
Reboot at the end is Recommended.


## Prerequisites

### Ensure that the `sudo`, `wget` and `jq` packages are installed on your system:

- Ubuntu & Debian:
```
apt update -q && apt install -y sudo wget jq
```
- CentOS & Fedora:
```
dnf up -y && dnf install -y sudo wget jq
```


## Run
#### **Tested on:** Ubuntu 20+, Debian 11+, CentOS Stream 8+, AlmaLinux 8+, Fedora 37+

#### Root Access is Required. If the user is not root, first run:
```
sudo -i
```
#### Then:
```
wget "https://raw.githubusercontent.com/hawshemi/Linux-Optimizer/main/linux-optimizer.sh" -O linux-optimizer.sh && chmod +x linux-optimizer.sh && bash linux-optimizer.sh 
```


## Menu Image
### Debian & Ubuntu:
![debian-based-menu](https://github.com/hawshemi/Linux-Optimizer/assets/16742123/3604470e-48ed-403d-a753-143dc934f6fd)

### CentOS, AlmaLinux & Fedora:
![rhel-based-menu](https://github.com/hawshemi/Linux-Optimizer/assets/16742123/07099e64-3864-425f-83e2-cda1e57d5b62)



## Disclaimer
This script is provided as-is, without any warranty or guarantee. Use it at your own risk.


## License
This script is licensed under the MIT License.

