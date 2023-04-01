# Ubuntu Optimizer

### This Bash script automates the optimization of your Ubuntu server. It performs the following tasks:

1. Update, upgrade, and clean the server

2. Install useful packages

3. Enable packages at server boot

4. Create a swap file

5. Enable IPv6 support

6. Optimize the sysctl settings

## Prerequisites
- `Ubuntu` server with `root` access
- `curl`

If your Ubuntu server does not have curl, install it:

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
