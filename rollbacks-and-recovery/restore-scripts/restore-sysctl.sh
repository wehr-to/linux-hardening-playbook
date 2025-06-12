#!/bin/bash
# restore-sysctl.sh
# Restore sysctl config from reference and reapply kernel settings

set -euo pipefail

# Define file paths
CONFIG_SRC="./references/sysctl-default.conf"
CONFIG_DEST="/etc/sysctl.d/99-sysctl-hardening.conf"
BACKUP_DIR="./rollbacks-and-recovery/backups"
mkdir -p "$BACKUP_DIR"

# Timestamped backup path
TIMESTAMP=$(date +%F-%H%M%S)
BACKUP_FILE="$BACKUP_DIR/$(basename $CONFIG_DEST).bak.$TIMESTAMP"

# Step 1: Backup current sysctl config
echo "[+] Backing up current sysctl config: $CONFIG_DEST"
sudo cp "$CONFIG_DEST" "$BACKUP_FILE"

# Step 2: Restore known-good sysctl settings
echo "[+] Restoring from reference: $CONFIG_SRC"
sudo cp "$CONFIG_SRC" "$CONFIG_DEST"

# Step 3: Reload kernel parameters
echo "[+] Reapplying sysctl settings..."
sudo sysctl --system

# Step 4: Confirm key sysctl parameters
echo "[+] Confirming example values:"
sysctl net.ipv4.ip_forward
sysctl kernel.kptr_restrict

# Completion output
echo "[✓] Sysctl config restored and applied. Backup saved to: $BACKUP_FILE"
