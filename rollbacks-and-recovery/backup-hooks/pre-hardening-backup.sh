#!/bin/bash
# pre-hardening-backup.sh
# Create backups of key config files before applying hardening changes

set -euo pipefail

# Backup target list (editable)
BACKUP_ITEMS=(
  /etc/ssh/sshd_config
  /etc/sysctl.d/99-sysctl-hardening.conf
  /etc/audit/auditd.conf
  /etc/audit/rules.d/hardening.rules
  /etc/rsyslog.conf
  /etc/rsyslog.d/hardening.conf
  /etc/systemd/journald.conf
  /etc/default/grub
  /etc/grub.d/40_custom
)

# Backup destination
BACKUP_DIR="./rollbacks-and-recovery/backups"
mkdir -p "$BACKUP_DIR"
TIMESTAMP=$(date +%F-%H%M%S)

# Start backup
echo "[+] Starting pre-hardening backup at $TIMESTAMP"

for item in "${BACKUP_ITEMS[@]}"; do
  if [ -f "$item" ]; then
    base_name=$(basename "$item")
    dest_name="$BACKUP_DIR/${base_name}.bak.$TIMESTAMP"
    echo "[+] Backing up: $item -> $dest_name"
    sudo cp "$item" "$dest_name"
  else
    echo "[!] Skipped (not found): $item"
  fi

done

echo "[✓] Pre-hardening backup completed. Files saved in: $BACKUP_DIR"

