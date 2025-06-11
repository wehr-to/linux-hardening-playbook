#!/bin/bash
# all-in-one-hardening.sh
# Run core Linux hardening steps using this toolkit

set -euo pipefail

LOG_DIR="./logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/all-in-one-hardening-$(date +%F).log"
exec > >(tee "$LOG_FILE") 2>&1

echo "==================== ALL-IN-ONE HARDENING ====================="
echo "Started at: $(date)"
echo "==============================================================="

# Essential Tools
echo "[+] Installing essential tools..."
bash ./scripts/essential-tools.sh

# Firewall Baseline
echo "[+] Applying firewall baseline..."
bash ./scripts/firewall-baseline.sh

# SSH Lockdown
echo "[+] Locking down SSH..."
bash ./baseline-hardening/sshd-lockdown.sh

# Disable Uncommon Kernel Modules
echo "[+] Disabling uncommon kernel modules..."
bash ./kernel-and-services/disable-uncommon-modules.sh

# Set sysctl Hardening Config
echo "[+] Applying sysctl hardening..."
cp ./kernel-and-services/sysctl-hardening.conf /etc/sysctl.d/99-sysctl-hardening.conf
sysctl --system

# Configure auditd
echo "[+] Setting up auditd..."
bash ./logging-and-auditing/auditd-config.sh

# Enable journald security config (assumes prewritten conf)
echo "[+] Configuring journald (manual step if needed)..."
echo "[!] Please review journald.conf manually and run: systemctl restart systemd-journald"

# File Permissions Checks
echo "[+] Running file permission checks..."
bash ./file-permissions/sticky-bits.sh
bash ./file-permissions/world-writable-scan.sh

# Monitoring Setup
echo "[+] Initializing AIDE..."
if command -v aideinit &>/dev/null; then sudo aideinit; fi

echo "[+] Running rkhunter update..."
if command -v rkhunter &>/dev/null; then sudo rkhunter --update && sudo rkhunter --propupd; fi

# Final Report
echo "==============================================================="
echo "[✓] All-in-one hardening complete. Logs saved to $LOG_DIR"
echo "==============================================================="

