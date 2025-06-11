#!/bin/bash
# essential-tools.sh
# Install essential security and admin tools for Linux hardening

set -e

LOG_DIR="./logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/essential-tools-install.log"

# Define essential tools
TOOLS=(
  vim
  curl
  wget
  net-tools
  htop
  ufw
  fail2ban
  auditd
  rsyslog
  logrotate
  debsums
  lynis
)

# Update package list
echo "[+] Updating package list..." | tee "$LOG_FILE"
apt update -y >> "$LOG_FILE" 2>&1

# Install tools
for pkg in "${TOOLS[@]}"; do
  echo "[+] Installing $pkg..." | tee -a "$LOG_FILE"
  apt install -y "$pkg" >> "$LOG_FILE" 2>&1 || echo "[!] Failed to install $pkg" | tee -a "$LOG_FILE"
done

# Final output
echo -e "\n[+] Essential tools installation completed. Log saved at $LOG_FILE"

