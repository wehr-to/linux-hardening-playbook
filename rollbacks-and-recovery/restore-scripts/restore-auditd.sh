#!/bin/bash
# restore-auditd.sh
# Restore auditd configuration and rules from references safely

set -euo pipefail

# Define paths for main config and rules
CONFIG_SRC="./references/auditd-default.conf"
CONFIG_DEST="/etc/audit/auditd.conf"
RULES_SRC="./references/auditd-rules-default.rules"
RULES_DEST="/etc/audit/rules.d/hardening.rules"
BACKUP_DIR="./rollbacks-and-recovery/backups"
mkdir -p "$BACKUP_DIR"

# Timestamp for versioning backups
TIMESTAMP=$(date +%F-%H%M%S)
CONFIG_BACKUP="$BACKUP_DIR/$(basename $CONFIG_DEST).bak.$TIMESTAMP"
RULES_BACKUP="$BACKUP_DIR/$(basename $RULES_DEST).bak.$TIMESTAMP"

# Step 1: Backup existing configs
echo "[+] Backing up current auditd config and rules"
sudo cp "$CONFIG_DEST" "$CONFIG_BACKUP"
sudo cp "$RULES_DEST" "$RULES_BACKUP"

# Step 2: Restore default/reference configs
echo "[+] Restoring from references"
sudo cp "$CONFIG_SRC" "$CONFIG_DEST"
sudo cp "$RULES_SRC" "$RULES_DEST"

# Step 3: Reload audit rules and restart auditd
echo "[+] Reloading audit rules and restarting service"
sudo augenrules --load
sudo systemctl restart auditd

# Step 4: Confirm status
echo "[+] Verifying auditd status and active rules"
sudo systemctl status auditd --no-pager
sudo auditctl -l | head

# Completion summary
echo "[✓] Auditd config and rules restored"
echo "[+] Backups saved to:"
echo "    $CONFIG_BACKUP"
echo "    $RULES_BACKUP"
