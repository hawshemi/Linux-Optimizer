# Linux Optimizer

## This Bash script automates the optimization of your Linux server.
### It performs the following tasks:
    
    
1. Set the server TimeZone to Asia/Tehran.
    

2. Update, Upgrade, and Clean the server:
    - _Update_
    - _Upgrade_
    - _Dist-Upgrade_
    - _AutoRemove_
    - _AutoClean_
    - _Clean_


3. Install Useful Packages:

    _`software-properties-common`_ _`build-essential`_ _`apt-transport-https`_ _`epel-release`_ _`nftables`_ _`iptables`_ _`iptables-persistent`_ _`lsb-release`_ _`ca-certificates`_ _`keyring`_ _`gnupg2`_ _`apt-utils`_ _`cron`_ _`bash-completion`_ _`curl`_ _`git`_ _`zip`_ _`unzip`_ _`ufw`_ _`wget`_ _`preload`_ _`locales`_ _`nano`_ _`vim`_ _`python3`_ _`python3-pip`_ _`jq`_ _`qrencode`_ _`socat`_ _`busybox`_ _`net-tools`_ _`haveged`_ _`htop`_ _`libssl-dev`_ _`libsqlite3-dev`_ _`dialog`_ _`bc`_ _`binutils`_ _`binutils-common`_ _`binutils-x86-64-linux-gnu`_ _`packagekit`_ _`make`_ _`automake`_ _`autoconf`_ _`libtool`_

    
4. Enable Packages at Server Boot.


5. Create & Enable `SWAP` File:
    - Swap Path: `"/swapfile"`
    - Swap Size: `2Gb`


6. Enable `IPv6` Support.


7. Clean the Old `SYSCTL` Configs.


8. Optimize the `SYSCTL` Configs.
    - Optimize `SWAP`.
    - Optimize Network Settings.
    - Activate `BBR`.
    - Optimize the Kernel.

    
9. Optimize `SSH`:
    - Back up the original `sshd_config` file.
    - Disable DNS lookups for connecting clients.
    - Remove less efficient encryption ciphers.
    - Enable and Configure TCP keep-alive messages.
    - Allow agent & TCP forwarding.
    - Enable gateway ports, Tunneling & Compression.
    

10. Optimize the System Limits:
    - Soft & Hard `nproc` limits.
    - Soft & Hard `nofile` limits.
    
    
11. Optimize `UFW` & Open Common Ports.
    - Open Ports `21`, `22`, `80`, `443`.
    - With `IPv6`, `TCP` & `UDP`.

    
Reboot at the end is Recommended.


## Pre-Run

### Packages `wget` and `sudo` must be installed.

- Ubuntu & Debian:
```
apt install -y sudo wget
```
- CentOS & Fedora:
```
dnf install -y sudo wget
```


## Run
#### **Tested on:** Ubuntu 18+, Debian 11+, CentOS 8+, Fedora 37+

#### Root Access is Required. If user is not root, first run:
```
sudo -i
```
#### Then:
```
wget "https://raw.githubusercontent.com/hawshemi/Linux-Optimizer/main/linux-optimizer.sh" -O linux-optimizer.sh && chmod +x linux-optimizer.sh && bash linux-optimizer.sh 
```


## Menu Image
<img width="481" title="Menu" alt="Menu" src="https://github.com/hawshemi/Linux-Optimizer/assets/16742123/64847a99-4efe-4d28-aec1-6d08a7fee335">


## Disclaimer
This script is provided as-is, without any warranty or guarantee. Use it at your own risk.


## License
This script is licensed under the MIT License.
