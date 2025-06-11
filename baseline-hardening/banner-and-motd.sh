#!/bin/bash
# banner-and-motd.sh
# Harden system login messages and configure SSH banner

set -euo pipefail

BANNER_TEXT="**WARNING: Unauthorized access to this system is prohibited. All activity is monitored and logged.**"
BANNER_FILE_CONTENT=$(cat <<EOF
$BANNER_TEXT
EOF
)

timestamp() {
    date +"[%Y-%m-%d %H:%M:%S]"
}

log() {
    echo "$(timestamp) $1"
}

log "[*] Writing banner to /etc/issue and /etc/issue.net..."
echo "$BANNER_FILE_CONTENT" | sudo tee /etc/issue /etc/issue.net > /dev/null

log "[*] Updating /etc/motd..."
echo -e "\n$BANNER_FILE_CONTENT" | sudo tee /etc/motd > /dev/null

SSH_CONFIG="/etc/ssh/sshd_config"
BACKUP_FILE="/etc/ssh/sshd_config.bak"

if ! grep -q '^Banner /etc/issue.net' "$SSH_CONFIG"; then
    log "[*] Backing up SSH conf*]()
