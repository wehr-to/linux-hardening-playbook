#!/bin/bash
# secure-tmp-mount.sh
# Enforce secure mount options on /tmp

set -euo pipefail

BACKUP_DIR="./rollbacks-and-recovery/backups"
TIMESTAMP=$(date +%F-%H%M%S)
FSTAB="/etc/fstab"
BACKUP_FILE="$BACKUP_DIR/fstab.bak.$TIMESTAMP"
mkdir -p "$BACKUP_DIR"

# Step 1: Backup /etc/fstab
cp "$FSTAB" "$BACKUP_FILE"
echo "[+] Backed up /etc/fstab to $BACKUP_FILE"

# Step 2: Add secure /tmp entry if not present
if ! grep -q "/tmp" "$FSTAB"; then
  echo "[+] Adding secure /tmp mount entry to /etc/fstab"
  echo -e "tmpfs\t/tmp\ttmpfs\trw,noexec,nosuid,nodev,mode=1777\t0 0" | sudo tee -a "$FSTAB"
else
  echo "[!] /tmp already configured in /etc/fstab — manual review suggested."
fi

# Step 3: Mount it immediately
mount -o remount /tmp
mount | grep /tmp

echo "[✓] /tmp is now mounted securely with: noexec,nosuid,nodev"
