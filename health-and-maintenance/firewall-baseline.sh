#!/bin/bash
# firewall-baseline.sh
# Configure a secure baseline firewall policy using ufw

set -e

LOG_DIR="./logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/firewall-baseline.log"

# Ensure ufw is installed
if ! command -v ufw &>/dev/null; then
  echo "[!] ufw not found. Install it with: sudo apt install ufw" | tee "$LOG_FILE"
  exit 1
fi

# Start logging
{
  echo "[+] Configuring UFW Firewall Baseline - $(date)"

  echo "[+] Resetting UFW to default..."
  ufw --force reset

  echo "[+] Setting default deny policy (incoming)..."
  ufw default deny incoming

  echo "[+] Setting default allow policy (outgoing)..."
  ufw default allow outgoing

  echo "[+] Allowing essential services..."
  ufw allow ssh
  ufw allow 80/tcp   # HTTP
  ufw allow 443/tcp  # HTTPS

  echo "[+] Enabling UFW..."
  ufw --force enable

  echo "[+] Current firewall status:"
  ufw status verbose
} | tee "$LOG_FILE"

echo "\n[+] Firewall baseline configuration complete. Log saved at $LOG_FILE"

