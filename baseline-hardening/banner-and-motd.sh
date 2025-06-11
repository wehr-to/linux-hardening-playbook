#!/bin/bash
# banner-and-motd.sh
# Sets a warning banner for legal and security notice

set -e

BANNER_TEXT="**WARNING: Unauthorized access to this system is prohibited. All activity is monitored and logged.**"

echo "[*] Setting /etc/issue and /etc/issue.net..."
echo "$BANNER_TEXT" | sudo tee /etc/issue /etc/issue.net > /dev/null

echo "[*] Updating /etc/motd..."
echo -e "\n$BANNER_TEXT" | sudo tee /etc/motd > /dev/null

echo "[*] Configuring SSH to show the banner..."
sudo sed -i 's|^#Banner.*|Banner /etc/issue.net|' /etc/ssh/sshd_config
sudo systemctl restart sshd

echo "[+] Banner and MOTD setup complete."
