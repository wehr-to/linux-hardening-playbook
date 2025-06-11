#!/bin/bash
# disable-root-login.sh
# Locks root account and disables SSH root login

set -euo pipefail

timestamp() {
    date +"[%Y-%m-%d %H:%M:%S]"
}

log() {
    echo "$(timestamp) $1"
}

log "[*] Locking the root account..."
if sudo passwd -S root | grep -q ' L '; then
    log "[*] Root account already locked. Skipping."
else
    sudo passwd -l root
    log "[+] Root account locked."
fi

SSH_CONFIG="/etc/ssh/sshd_config"
BACKUP_FILE="/etc/ssh/sshd_config.bak"

log "[*] Checking SSH config for PermitRootLogin..."

if ! grep -q '^PermitRootLogin no' "$SSH_CONFIG"; then
    log "[*] Backing up SSH config to $BACKUP_FILE..."
    sudo cp "$SSH_CONFIG" "$BACKUP_FILE"

    log "[*] Updating PermitRootLogin to 'no'..."
    sudo sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin no/' "$SSH_CONFIG"
    sudo systemctl restart sshd
    log "[+] SSH root login disabled and SSH restarted."
else
    log "[*] SSH root login already disabled. Skipping."
fi

log "[✓] Root account login disabled (local + SSH)."
