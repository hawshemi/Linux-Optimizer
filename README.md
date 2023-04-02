# Ubuntu Optimizer

## This Bash script automates the optimization of your Ubuntu server.
### It performs the following tasks:

1. Update, Upgrade, and Clean the server.

2. Install Useful Packages.

3. Enable Packages at Server Boot.

4. Create & Enable `SWAP` File. (Default is `2Gb`)

5. Enable `IPv6` Support.

6. Clean the Old `SYSCTL` Settings.

7. Optimize the `SYSCTL` Settings.
    - SWAP
    - Network
    - BBR
    - Kernel

    <br>
8. Optimize the System Limits.

9. Optimize `UFW` & Open Common Ports.

Reboot at the end.


## Prerequisites
- `Ubuntu` server `(16+)` with `root` access.
- `curl`

If your Ubuntu server does not have curl, install it first:

```
sudo apt install -y curl
```


## Run

```
bash <(curl -s https://raw.githubusercontent.com/hawshemi/Ubuntu-Optimizer/main/ubuntu-optimizer.sh)
```

## Disclaimer
This script is provided as-is, without any warranty or guarantee. Use it at your own risk.


## License
This script is licensed under the MIT License.
