#!/bin/bash
# Disables local login for the root user by locking the account.

set -e

echo "[*] Locking the root account..."

if sudo passwd -l root; then
    echo "[+] Root account successfully locked."
else
    echo "[!] Failed to lock the root account. Please check permissions."
    exit 1
fi

