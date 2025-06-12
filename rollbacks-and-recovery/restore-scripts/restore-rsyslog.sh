#!/bin/bash
# restore-rsyslog.sh
# Restore rsyslog config and rules from reference files

set -euo pipefail

# Define main and hardening config paths
CONFIG_SRC="./references/rsyslog-default.conf"
CONFIG_DEST="/etc/rsyslog.conf"
HARDEN_SRC="./references/rsyslog-hardening-default.conf"
HARDEN_DEST="/etc/rsyslog.d/hardening.conf"
BACKUP_DIR="./rollbacks-and-recovery/backups"
mkdir -p "$BACKUP_DIR"

# Timestamped backup filenames
TIMESTAMP=$(date +%F-%H%M%S)
CONFIG_BACKUP="$BACKUP_DIR/$(basename $CONFIG_DEST).bak.$TIMESTAMP"
HARDEN_BACKUP="$BACKUP_DIR/$(basename $HARDEN_DEST).bak.$TIMESTAMP"

# Step 1: Backup current configs
echo "[+] Backing up current rsyslog configs"
sudo cp "$CONFIG_DEST" "$CONFIG_BACKUP"
sudo cp "$HARDEN_DEST" "$HARDEN_BACKUP"

# Step 2: Restore from references
echo "[+] Restoring from references"
sudo cp "$CONFIG_SRC" "$CONFIG_DEST"
sudo cp "$HARDEN_SRC" "$HARDEN_DEST"

# Step 3: Validate syntax before restarting
echo "[+] Validating rsyslog configuration"
sudo rsyslogd -N1 || { echo "[!] Invalid config. Aborting."; exit 1; }

# Step 4: Restart service
echo "[+] Restarting rsyslog"
sudo systemctl restart rsyslog
sudo systemctl status rsyslog --no-pager

# Completion message
echo "[✓] Rsyslog config restored and service restarted"
echo "[+] Backups saved to:"
echo "    $CONFIG_BACKUP"
echo "    $HARDEN_BACKUP"
