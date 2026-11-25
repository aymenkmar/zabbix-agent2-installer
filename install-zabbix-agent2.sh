#!/usr/bin/env bash
set -euo pipefail

# Install zabbix-agent2 (repo 8.0) on Ubuntu 22.04 / 24.04 / 26.04
# Must be run as root.

if [ "$(id -u)" -ne 0 ]; then
  echo "Must be run as root" >&2
  exit 1
fi

cd /tmp

read -rp "Zabbix server IP: " ZABBIX_SERVER
if [ -z "$ZABBIX_SERVER" ]; then
  echo "Zabbix server IP is required" >&2
  exit 1
fi

. /etc/os-release
case "$VERSION_ID" in
  22.04) PKG_SUFFIX="ubuntu22.04" ;;
  24.04) PKG_SUFFIX="ubuntu24.04" ;;
  26.04) PKG_SUFFIX="ubuntu26.04" ;;
  *)
    echo "Unsupported Ubuntu version: $VERSION_ID" >&2
    exit 1
    ;;
esac

DEB="zabbix-release_latest+${PKG_SUFFIX}_all.deb"

wget -q "https://repo.zabbix.com/zabbix/8.0/release/ubuntu/pool/main/z/zabbix-release/${DEB}"
dpkg -i "$DEB"

apt update -y
apt install zabbix-agent2 zabbix-agent2-plugin-* -y

systemctl enable zabbix-agent2

mkdir -p /etc/systemd/system/zabbix-agent2.service.d
cat > /etc/systemd/system/zabbix-agent2.service.d/override.conf <<'EOF'
[Service]
User=root
Group=root
EOF

sed -i "s/^Server=127.0.0.1/Server=${ZABBIX_SERVER}/" /etc/zabbix/zabbix_agent2.conf

NVIDIA_CONF="/etc/zabbix/zabbix_agent2.d/plugins.d/nvidia.conf"
if [ -f "$NVIDIA_CONF" ]; then
  sed -i 's/^Plugins.NVIDIA.System.Path/#Plugins.NVIDIA.System.Path/' "$NVIDIA_CONF"
fi

systemctl daemon-reload
systemctl restart zabbix-agent2.service
systemctl status zabbix-agent2 --no-pager
