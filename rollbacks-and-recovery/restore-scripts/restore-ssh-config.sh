#!/bin/bash
# restore-ssh-config.sh
# Restore sshd_config from reference and restart SSH safely

set -euo pipefail

# Define variables
SERVICE_NAME="sshd"
CONFIG_SRC="./references/sshd-default.conf"
CONFIG_DEST="/etc/ssh/sshd_config"
BACKUP_DIR="./rollbacks-and-recovery/backups"
mkdir -p "$BACKUP_DIR"

# Timestamped backup filename
TIMESTAMP=$(date +%F-%H%M%S)
BACKUP_FILE="$BACKUP_DIR/sshd_config.bak.$TIMESTAMP"

# Step 1: Backup current sshd_config
echo "[+] Backing up current SSH config to: $BACKUP_FILE"
sudo cp "$CONFIG_DEST" "$BACKUP_FILE"

# Step 2: Copy reference config into place
echo "[+] Restoring reference SSH config from: $CONFIG_SRC"
sudo cp "$CONFIG_SRC" "$CONFIG_DEST"

# Step 3: Validate syntax before restarting
echo "[+] Validating sshd config syntax..."
sudo sshd -t || { echo "[!] SSH config is invalid. Aborting."; exit 1; }

# Step 4: Restart sshd service safely
echo "[+] Restarting sshd service..."
sudo systemctl restart sshd
sudo systemctl status sshd --no-pager

# Completion notice
echo "[✓] SSH config restored and service restarted."
echo "[+] Backup saved to: $BACKUP_FILE"
