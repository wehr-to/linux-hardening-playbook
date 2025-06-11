#!/bin/bash
# auditd-config.sh
# Configure basic auditd rules and hardened auditd.conf settings

set -euo pipefail

LOG_DIR="./logs"
mkdir -p "$LOG_DIR"
AUDIT_LOG="$LOG_DIR/auditd-config-$(date +%F).log"

exec > >(tee "$AUDIT_LOG") 2>&1

# Ensure auditd is installed
if ! command -v auditctl &>/dev/null; then
  echo "[!] auditd not installed. Install with: sudo apt install auditd"
  exit 1
fi

# Backup existing config
cp /etc/audit/auditd.conf /etc/audit/auditd.conf.bak.$(date +%s)

# Harden auditd.conf settings
cat <<EOF > /etc/audit/auditd.conf
log_file = /var/log/audit/audit.log
log_format = RAW
max_log_file = 20
num_logs = 10
disp_qos = lossy
disp_path = /sbin/audispd
name_format = hostname
max_log_file_action = ROTATE
auto_relabel = no
audit_backlog_limit = 64
EOF

# Apply common audit rules
cat <<EOF > /etc/audit/rules.d/hardening.rules
-w /etc/passwd -p wa -k user-changes
-w /etc/shadow -p wa -k auth-files
-w /etc/group -p wa -k group-mod
-w /etc/gshadow -p wa -k group-auth
-w /etc/sudoers -p wa -k sudo-access
-w /var/log/sudo.log -p wa -k sudo-log
-w /var/run/faillock -p wa -k failed-logins
-w /var/log/faillog -p wa -k failed-logins
-e 2
EOF

# Restart and enable auditd
systemctl restart auditd
systemctl enable auditd

echo -e "\n[+] auditd configured and restarted. Log saved at: $AUDIT_LOG"
