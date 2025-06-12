#!/bin/bash
# restore-template.sh
# Generic restore script to safely copy a reference config into place and restart service

set -euo pipefail

SERVICE_NAME="$1"              # e.g., sshd, rsyslog, auditd
CONFIG_SRC="$2"               # e.g., ./references/sshd-default.conf
CONFIG_DEST="$3"              # e.g., /etc/ssh/sshd_config
BACKUP_DIR="./rollbacks-and-recovery/backups"
mkdir -p "$BACKUP_DIR"

TIMESTAMP=$(date +%F-%H%M%S)
BACKUP_FILE="$BACKUP_DIR/$(basename $CONFIG_DEST).bak.$TIMESTAMP"

echo "[+] Backing up current config: $CONFIG_DEST"
sudo cp "$CONFIG_DEST" "$BACKUP_FILE"

echo "[+] Restoring known-good config from: $CONFIG_SRC"
sudo cp "$CONFIG_SRC" "$CONFIG_DEST"

# Optional: Validate config (for known services)
if [[ "$SERVICE_NAME" == "sshd" ]]; then
    echo "[+] Validating sshd config with sshd -t"
    sudo sshd -t || { echo "[!] sshd config invalid. Restore aborted."; exit 1; }
fi

if [[ "$SERVICE_NAME" == "rsyslog" ]]; then
    echo "[+] Checking rsyslog syntax"
    sudo rsyslogd -N1 || { echo "[!] rsyslog config invalid."; exit 1; }
fi

echo "[+] Restarting service: $SERVICE_NAME"
sudo systemctl restart "$SERVICE_NAME"
sudo systemctl status "$SERVICE_NAME" --no-pager

echo "[✓] Restore complete. Backup saved to: $BACKUP_FILE"

