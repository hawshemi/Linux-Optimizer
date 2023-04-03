# Ubuntu Optimizer

## This Bash script automates the optimization of your Ubuntu server.
### It performs the following tasks:

<br>

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
8. Optimize ssh
    - Back up the original sshd_config file
    - Disable DNS lookups for connecting clients
    - Enable compression for SSH connections
    - Remove less efficient encryption ciphers
    - Comment out or delete the lines that set MaxAuthTries and MaxSessions
    - Enable TCP keep-alive messages
    - Configure client keep-alive messages
    - Allow agent forwarding
    - Allow TCP forwarding
    - Enable gateway ports
    - Enable tunneling
    - Restart the SSH service to apply the changes
9. Optimize the System Limits.
    - `nproc`
    - `nofile`
    
    <br>
10. Optimize `UFW` & Open Common Ports.

<br>

Reboot at the end.

<br>

## Prerequisites
- `Ubuntu` server `(16+)` with `root` access.
- `curl`

If your Ubuntu server does not have `curl`, install it first:

```
sudo apt install -y curl
```

<br>

## Run

```
bash <(curl -s https://raw.githubusercontent.com/hawshemi/Ubuntu-Optimizer/main/ubuntu-optimizer.sh)
```

<br>

## Disclaimer
This script is provided as-is, without any warranty or guarantee. Use it at your own risk.

<br>

## License
This script is licensed under the MIT License.
