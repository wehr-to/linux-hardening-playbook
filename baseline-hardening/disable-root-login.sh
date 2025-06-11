#!/bin/bash
# disable-root-login.sh
# Locks root account and disables SSH root login

set -e

echo "[*] Locking the root account..."
sudo passwd -l root

echo "[*] Disabling SSH root login in /etc/ssh/sshd_config..."
sudo sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config

echo "[*] Restarting SSH service..."
sudo systemctl restart sshd

echo "[+] Root account login disabled (local + SSH)."
