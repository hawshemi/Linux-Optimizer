# Linux Optimizer

## This Bash script automates the optimization of your Linux server.
### It performs the following tasks:


0. Fix & Optimize System `DNS` Settings:

    Clean the `/etc/resolv.conf` and Add:
    - _`1.1.1.1`_  - _`1.0.0.1`_  - _`8.8.8.8`_  - _`8.8.4.4`_


1. Update, Upgrade, and Clean the server:
    - _Update_
    - _Upgrade_
    - _Dist-Upgrade_
    - _AutoRemove_
    - _AutoClean_
    - _Clean_


2. Install Useful Packages:

    _`software-properties-common`_ _`build-essential`_ _`apt-transport-https`_ _`iptables`_ _`iptables-persistent`_ _`lsb-release`_ _`ca-certificates`_ _`ubuntu-keyring`_ _`gnupg2`_ _`apt-utils`_ _`cron`_ _`bash-completion`_ _`curl`_ _`git`_ _`zip`_ _`unzip`_ _`ufw`_ _`wget`_ _`preload`_ _`locales`_ _`nano`_ _`vim`_ _`python3`_ _`python3-pip`_ _`jq`_ _`qrencode`_ _`socat`_ _`busybox`_ _`net-tools`_ _`haveged`_ _`htop`_ _`libssl-dev`_ _`libsqlite3-dev`_ _`dialog`_ 

    
3. Enable Packages at Server Boot.


4. Create & Enable `SWAP` File:
    - Swap Path: `"/swapfile"`
    - Swap Size: `2Gb`


5. Enable `IPv6` Support.


6. Clean the Old `SYSCTL` Configs.


7. Optimize the `SYSCTL` Configs.
    - Optimize `SWAP`.
    - Optimize Network Settings.
    - Activate `BBR`.
    - Optimize the Kernel.

    
8. Optimize `SSH`:
    - Back up the original `sshd_config` file.
    - Disable DNS lookups for connecting clients.
    - Remove less efficient encryption ciphers.
    - Enable and Configure TCP keep-alive messages.
    - Allow agent & TCP forwarding.
    - Enable gateway ports, Tunneling & Compression.
    

9. Optimize the System Limits:
    - Soft & Hard `nproc` limits.
    - Soft & Hard `nofile` limits.
    
    
10. Optimize `UFW` & Open Common Ports.
    - Open Ports `21`, `22`, `80`, `443`.
    - With `IPv6`, `TCP` & `UDP`.

    
Reboot at the end.


## Run
### Ubuntu (16+):
```
bash <(curl -s https://raw.githubusercontent.com/hawshemi/Linux-Optimizer/main/ubuntu-optimizer.sh)
```

### Debian:
```
Coming Soon...
```

### CentOS:
```
Coming Soon...
```

### Fedora:
```
Coming Soon...
```


## Disclaimer
This script is provided as-is, without any warranty or guarantee. Use it at your own risk.


## License
This script is licensed under the MIT License.
