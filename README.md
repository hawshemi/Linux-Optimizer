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

    _`apt-transport-https`_ _`apt-utils`_ _`autoconf`_ _`automake`_ _`bash-completion`_ _`bc`_ _`binutils`_ _`binutils-common`_ _`binutils-x86-64-linux-gnu`_ _`build-essential`_ _`busybox`_ _`ca-certificates`_ _`cron`_ _`curl`_ _`dialog`_ _`epel-release`_ _`gnupg2`_ _`git`_ _`haveged`_ _`htop`_ _`iptables`_ _`iptables-persistent`_ _`jq`_ _`keyring`_ _`libssl-dev`_ _`libsqlite3-dev`_ _`libtool`_ _`locales`_ _`lsb-release`_ _`make`_ _`nano`_ _`net-tools`_ _`nftables`_ _`packagekit`_ _`preload`_ _`python3`_ _`python3-pip`_ _`qrencode`_ _`socat`_ _`screen`_ _`software-properties-common`_ _`ufw`_ _`unzip`_ _`vim`_ _`wget`_ _`zip`_


    
4. Enable Packages at Server Boot.


5. Create & Enable `SWAP` File:
    - Swap Path: `"/swapfile"`
    - Swap Size: `2Gb`


6. Enable `IPv6` Support.


7. Optimize the `SYSCTL` Configs.
    - Optimize `SWAP`.
    - Optimize Network Settings.
    - Activate `BBR`.
    - Optimize the Kernel.

    *Original file is backed up at `/etc/sysctl.conf.bak`.*

    
8. Optimize `SSH`:
    - Back up the original `sshd_config` file.
    - Disable DNS lookups for connecting clients.
    - Remove less efficient encryption ciphers.
    - Enable and Configure TCP keep-alive messages.
    - Allow agent & TCP forwarding.
    - Enable gateway ports, Tunneling & Compression.
    - Enable X11 Forwarding.

    *Original file is backed up at `/etc/ssh/sshd_config.bak`.*
   

10. Optimize the System Limits:
    - ulimit `-c -d -f -i -n -q -u -v -x -s -l` optimizations.
    - Soft & Hard `nproc` limits.
    - Soft & Hard `nofile` limits.
    
    
12. Optimize `UFW` & Open Common Ports.
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

#### Root Access is Required. If the user is not root, first run:
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
