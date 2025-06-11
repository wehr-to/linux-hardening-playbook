#!/bin/bash
# system-audit.sh
# Perform a basic system security audit and generate a log report

set -e

LOG_DIR="./logs"
mkdir -p "$LOG_DIR"
AUDIT_LOG="$LOG_DIR/system-audit-$(date +%F).log"

exec > >(tee "$AUDIT_LOG") 2>&1

echo "==================== SYSTEM AUDIT REPORT ===================="
echo "Generated: $(date)"
echo "Hostname: $(hostname)"
echo "OS: $(lsb_release -d | cut -f2)"
echo "Kernel: $(uname -r)"
echo "============================================================"

# Check for system updates
echo -e "\n[+] Checking for available updates..."
apt update -qq && apt list --upgradable 2>/dev/null | grep -v "Listing..."

# List current users
echo -e "\n[+] Logged-in users:"
w

# List users with UID 0 (should be only root)
echo -e "\n[+] Users with UID 0:"
awk -F: '$3 == 0 { print $1 }' /etc/passwd

# Check for passwordless accounts
echo -e "\n[+] Passwordless accounts:"
awk -F: '($2 == "" || $2 == "*" || $2 == "!" ) { print $1 }' /etc/shadow

# World-writable files
echo -e "\n[+] World-writable files:"
find / -xdev -type f -perm -0002 2>/dev/null | head -n 10

# SUID/SGID files
echo -e "\n[+] SUID/SGID files:"
find / -xdev -type f \( -perm -4000 -o -perm -2000 \) -exec ls -l {} + 2>/dev/null | head -n 10

# Firewall status
echo -e "\n[+] UFW firewall status:"
ufw status verbose

# Auditd status
echo -e "\n[+] auditd service status:"
systemctl is-active auditd || echo "auditd not active"

# Rootkit Hunter (if installed)
echo -e "\n[+] Checking for Rootkit Hunter (rkhunter):"
if command -v rkhunter &>/dev/null; then
  rkhunter --check --sk
else
  echo "[!] rkhunter not installed."
fi

echo -e "\n[+] Audit report saved to: $AUDIT_LOG"

