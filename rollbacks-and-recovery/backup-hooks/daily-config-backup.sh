#!/bin/bash
# daily-config-backup.sh
# Cron-friendly script to backup critical system configs daily

set -euo pipefail

# Destination with date-based folders
DATE=$(date +%F)
BACKUP_DIR="/var/backups/linux-hardening-configs/$DATE"
mkdir -p "$BACKUP_DIR"

# Backup targets (modify as needed)
BACKUP_ITEMS=(
  /etc/ssh/sshd_config
  /etc/sysctl.d/99-sysctl-hardening.conf
  /etc/audit/auditd.conf
  /etc/audit/rules.d/hardening.rules
  /etc/rsyslog.conf
  /etc/rsyslog.d/hardening.conf
  /etc/systemd/journald.conf
  /etc/default/grub
  /etc/grub.d/40_custom
)

# Logging
LOG_FILE="/var/log/linux-hardening-daily-backup.log"
echo "[$(date)] Starting daily config backup to: $BACKUP_DIR" | tee -a "$LOG_FILE"

# Perform backups
for item in "${BACKUP_ITEMS[@]}"; do
  if [ -f "$item" ]; then
    cp "$item" "$BACKUP_DIR/"
    echo "  [+] Backed up: $item" | tee -a "$LOG_FILE"
  else
    echo "  [!] Skipped (missing): $item" | tee -a "$LOG_FILE"
  fi
done

# Rotate old backups (older than 14 days)
find /var/backups/linux-hardening-configs/ -maxdepth 1 -type d -mtime +14 -exec rm -rf {} \;
echo "[$(date)] Cleanup: Removed backups older than 14 days" | tee -a "$LOG_FILE"

echo "[$(date)] Daily config backup complete." | tee -a "$LOG_FILE"
