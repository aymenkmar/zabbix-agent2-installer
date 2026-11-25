# zabbix-agent2-installer

Installs Zabbix Agent2 (repo 8.0) on Ubuntu 22.04 / 24.04 / 26.04.

> **Must be run as root.** The script checks for this and exits otherwise.

## What it does

- Detects the Ubuntu version from `/etc/os-release` and installs the matching `zabbix-release` package.
- Installs `zabbix-agent2` plus all available plugins.
- Enables the service and overrides its systemd unit to run as `User=root`/`Group=root` (required for some check functions).
- Prompts for the Zabbix server IP and sets `Server=<ip>` in `/etc/zabbix/zabbix_agent2.conf`.
- Disables the NVIDIA plugin if present (prevents the agent from failing to start on hosts without a GPU).
- Reloads systemd and restarts `zabbix-agent2`.

## Usage

The script asks for the Zabbix server IP interactively, so it needs a real terminal — plain `curl | bash` won't work since the pipe eats stdin. Use one of these instead, as root:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/aymenkmar/zabbix-agent2-installer/master/install-zabbix-agent2.sh)
```

Or download and inspect first:

```bash
wget https://raw.githubusercontent.com/aymenkmar/zabbix-agent2-installer/master/install-zabbix-agent2.sh
bash install-zabbix-agent2.sh
```
