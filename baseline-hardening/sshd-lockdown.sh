#!/bin/bash
# sshd-lockdown.sh
# Hardens SSH daemon configuration by enforcing secure defaults.
# Applies changes to /etc/ssh/sshd_config and restarts the SSH service.

set -e

echo "[*] Backing up current sshd_config..."
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak.$(date +%F-%H%M%S)

echo "[*] Locking down SSH settings..."

sudo sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/^#*X11Forwarding.*/X11Forwarding no/' /etc/ssh/sshd_config
sudo sed -i 's/^#*UseDNS.*/UseDNS no/' /etc/ssh/sshd_config
sudo sed -i 's/^#*MaxAuthTries.*/MaxAuthTries 3/' /etc/ssh/sshd_config
sudo sed -i 's/^#*ClientAliveInterval.*/ClientAliveInterval 300/' /etc/ssh/sshd_config
sudo sed -i 's/^#*ClientAliveCountMax.*/ClientAliveCountMax 2/' /etc/ssh/sshd_config
sudo sed -i 's/^#*LogLevel.*/LogLevel VERBOSE/' /etc/ssh/sshd_config

# Optional: Explicitly define strong key exchange and ciphers (edit per your distro)
# echo -e "\nCiphers aes256-ctr,aes192-ctr,aes128-ctr\nMACs hmac-sha2-512,hmac-sha2-256\nKexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256" | sudo tee -a /etc/ssh/sshd_config

echo "[*] Restarting SSH service..."
sudo systemctl restart sshd

echo "[+] SSH lockdown complete. Root login and password auth are disabled. Key-based auth required."
