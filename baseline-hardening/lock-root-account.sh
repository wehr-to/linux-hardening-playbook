#!/bin/bash
# lock-root-account.sh
# Disables local login for the root user by locking the account

set -euo pipefail

timestamp() {
    date +"[%Y-%m-%d %H:%M:%S]"
}

log() {
    echo "$(timestamp) $1"
}

log "[*] Checking root account status..."

if sudo passwd -S root | grep -q ' L '; then
    log "[*] Root account is already locked."
else
    log "[*] Locking the root account..."
    sudo passwd -l root
    log "[+] Root account successfully locked."
fi
