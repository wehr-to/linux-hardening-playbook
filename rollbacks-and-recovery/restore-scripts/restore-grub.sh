#!/bin/bash
# restore-grub.sh
# Restore GRUB configuration and custom entries from references

set -euo pipefail

# Define reference and destination paths
GRUB_SRC="./references/grub-default.conf"
GRUB_DEST="/etc/default/grub"
CUSTOM_SRC="./references/grub-custom-default"
CUSTOM_DEST="/etc/grub.d/40_custom"
BACKUP_DIR="./rollbacks-and-recovery/backups"
mkdir -p "$BACKUP_DIR"

# Timestamped backup filenames
TIMESTAMP=$(date +%F-%H%M%S)
GRUB_BACKUP="$BACKUP_DIR/$(basename $GRUB_DEST).bak.$TIMESTAMP"
CUSTOM_BACKUP="$BACKUP_DIR/$(basename $CUSTOM_DEST).bak.$TIMESTAMP"

# Step 1: Backup current GRUB config files
echo "[+] Backing up current GRUB configs"
sudo cp "$GRUB_DEST" "$GRUB_BACKUP"
sudo cp "$CUSTOM_DEST" "$CUSTOM_BACKUP"

# Step 2: Restore from reference files
echo "[+] Restoring GRUB config from: $GRUB_SRC"
sudo cp "$GRUB_SRC" "$GRUB_DEST"

echo "[+] Restoring custom entries from: $CUSTOM_SRC"
sudo cp "$CUSTOM_SRC" "$CUSTOM_DEST"

# Step 3: Regenerate grub.cfg
echo "[+] Regenerating GRUB configuration"
sudo update-grub

# Step 4: Optional UEFI check
if mount | grep -q "/boot/efi"; then
    echo "[+] Detected EFI system; ensuring bootloader integrity"
    ls -l /boot/efi/EFI/*/*.efi || echo "[!] EFI bootloader not found"
fi

# Completion message
echo "[✓] GRUB config restored and updated"
echo "[+] Backups saved to:"
echo "    $GRUB_BACKUP"
echo "    $CUSTOM_BACKUP"
