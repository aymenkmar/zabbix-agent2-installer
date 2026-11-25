# zabbix-agent2-installer

Installs Zabbix Agent2 (repo 8.0) on Ubuntu 22.04 / 24.04 / 26.04, configured to report to `141.94.78.105`.

## What it does

- Detects the Ubuntu version from `/etc/os-release` and installs the matching `zabbix-release` package.
- Installs `zabbix-agent2` plus all available plugins.
- Enables the service and overrides its systemd unit to run as `User=root`/`Group=root` (required for some check functions).
- Sets `Server=141.94.78.105` in `/etc/zabbix/zabbix_agent2.conf`.
- Disables the NVIDIA plugin if present (prevents the agent from failing to start on hosts without a GPU).
- Reloads systemd and restarts `zabbix-agent2`.

## Usage

Run as root on the target host:

```bash
curl -fsSL https://raw.githubusercontent.com/aymenkmar/zabbix-agent2-installer/master/install-zabbix-agent2.sh | sudo bash
```

Or download and inspect first:

```bash
wget https://raw.githubusercontent.com/aymenkmar/zabbix-agent2-installer/master/install-zabbix-agent2.sh
sudo bash install-zabbix-agent2.sh
```
