#!/bin/bash
# fail2ban-setup.sh
# Configure Fail2Ban with secure defaults

set -euo pipefail

echo "[+] Installing fail2ban (if not already present)"
sudo apt update && sudo apt install -y fail2ban

CONFIG_DIR="/etc/fail2ban"
JAIL_LOCAL="$CONFIG_DIR/jail.local"
BACKUP_DIR="./rollbacks-and-recovery/backups"
mkdir -p "$BACKUP_DIR"
TIMESTAMP=$(date +%F-%H%M%S)

# Step 1: Backup existing config
if [ -f "$JAIL_LOCAL" ]; then
  cp "$JAIL_LOCAL" "$BACKUP_DIR/jail.local.bak.$TIMESTAMP"
fi

# Step 2: Create secure jail.local
cat <<EOF | sudo tee "$JAIL_LOCAL"
[DEFAULT]
ban_time = 1h
findtime = 10m
maxretry = 3
backend = systemd
banaction = iptables-multiport
ignoreip = 127.0.0.1/8 ::1

[sshd]
enabled = true
port = ssh
logpath = %(sshd_log)s
EOF

# Step 3: Restart and enable fail2ban
sudo systemctl enable fail2ban
sudo systemctl restart fail2ban

# Step 4: Show status
echo "[+] Fail2Ban status:"
sudo fail2ban-client status sshd
