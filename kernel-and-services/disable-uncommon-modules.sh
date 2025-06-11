#!/bin/bash
# disable-uncommon-modules.sh
# Blacklist uncommon and potentially dangerous kernel modules

set -euo pipefail

LOG_DIR="./logs"
mkdir -p "$LOG_DIR"
MOD_LOG="$LOG_DIR/blacklisted-modules-$(date +%F).log"

BLACKLIST_FILE="/etc/modprobe.d/hardening-blacklist.conf"

# Define uncommon or high-risk modules to blacklist
MODULES=(
  cramfs
  freevxfs
  jffs2
  hfs
  hfsplus
  squashfs
  udf
  vfat
  dccp
  sctp
  rds
  tipc
)

echo "[+] Writing blacklist to $BLACKLIST_FILE"
echo "# Kernel module blacklist for system hardening" > "$BLACKLIST_FILE"

for mod in "${MODULES[@]}"; do
  echo "blacklist $mod" >> "$BLACKLIST_FILE"
  echo "install $mod /bin/true" >> "$BLACKLIST_FILE"
  echo "[+] Blacklisted: $mod" | tee -a "$MOD_LOG"
done

# Regenerate initramfs if needed
if command -v update-initramfs &>/dev/null; then
  echo "[+] Regenerating initramfs..."
  update-initramfs -u
fi

# Check applied config
echo -e "\n[+] Final blacklist entries in: $BLACKLIST_FILE"
cat "$BLACKLIST_FILE"

echo "\n[+] Kernel module blacklist applied. Log saved to: $MOD_LOG"

