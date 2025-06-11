#!/bin/bash
# update-and-upgrade.sh
# Secure and silent update/upgrade script with logging

set -euo pipefail

LOG_DIR="./logs"
mkdir -p "$LOG_DIR"
UPDATE_LOG="$LOG_DIR/update-upgrade-$(date +%F).log"

exec > >(tee "$UPDATE_LOG") 2>&1

echo "[+] Starting system update and upgrade: $(date)"

echo -e "\n[+] Updating package lists..."
apt update -y

echo -e "\n[+] Upgrading installed packages..."
apt upgrade -y

# Optional: remove unused dependencies
echo -e "\n[+] Autoremove unused packages..."
apt autoremove -y

# Optional: clean apt cache
echo -e "\n[+] Cleaning up package cache..."
apt clean

echo -e "\n[+] Update and upgrade complete. Log saved to: $UPDATE_LOG"

