#!/bin/bash
# ad-audit-checks.sh
# Audit Linux-AD integration: realm, Kerberos, SSSD, and sudo access

set -euo pipefail

DOMAIN="corp.example.com"
TEST_USER="testuser@$DOMAIN"
LOG="./logs/ad-hardening.log"

mkdir -p ./logs
exec > >(tee -a "$LOG") 2>&1

echo "=== [AD AUDIT CHECKS — $(date)] ==="

# 1. Realm membership
printf "\n[+] Realm info:\n"
realm list || echo "[!] Realm not joined or misconfigured"

# 2. Kerberos ticket status
printf "\n[+] Kerberos test with kinit:\n"
kdestroy || true
if echo "FakePassword" | kinit "$TEST_USER" 2>/dev/null; then
  echo "[✓] Kerberos login test passed"
else
  echo "[!] Kerberos login failed or ticket not issued"
fi

# 3. klist validation
printf "\n[+] klist output:\n"
klist || echo "[!] No valid ticket in cache"

# 4. SSSD user lookup
printf "\n[+] SSSD id lookup:\n"
id "$TEST_USER" || echo "[!] id lookup failed"

# 5. getent check
printf "\n[+] getent passwd lookup:\n"
getent passwd "$TEST_USER" || echo "[!] getent failed"

# 6. sudo test (read-only command)
printf "\n[+] sudo access test:\n"
echo "exit" | sudo -u "$TEST_USER" sudo -l || echo "[!] Sudo test failed"

# 7. Service health
printf "\n[+] Service status check:\n"
systemctl is-active sssd && echo "[✓] sssd active" || echo "[!] sssd inactive"
systemctl is-active realmd && echo "[✓] realmd active" || echo "[!] realmd inactive"

# 8. DNS and time sync
printf "\n[+] NTP and DNS:\n"
timedatectl status | grep -E "Time zone|NTP synchronized"
cat /etc/resolv.conf | grep nameserver

# Done
echo "\n=== AD Audit Complete ===\nLog saved: $LOG"
