#!/bin/bash
# sticky-bits.sh
# Scan for insecure file permissions: sticky bit, SUID, SGID

LOG_DIR="./logs"
mkdir -p "$LOG_DIR"

STICKY_LOG="$LOG_DIR/world-writable-no-sticky.log"
SUID_LOG="$LOG_DIR/suid-files.log"
SGID_LOG="$LOG_DIR/sgid-files.log"

# Scan for world-writable dirs without sticky bit
find / -xdev -type d \( -perm -0002 -a ! -perm -1000 \) -exec ls -ld {} + 2>/dev/null | tee "$STICKY_LOG"

# Scan for SUID files
find / -xdev -type f -perm -4000 -exec ls -l {} + 2>/dev/null | tee "$SUID_LOG"

# Scan for SGID files
find / -xdev -type f -perm -2000 -exec ls -l {} + 2>/dev/null | tee "$SGID_LOG"

printf "\n[+] Results saved in: $LOG_DIR\n"
printf "  - World-writable dirs (no sticky): $STICKY_LOG\n"
printf "  - SUID files: $SUID_LOG\n"
printf "  - SGID files: $SGID_LOG\n"

# Optional auto-fix example (safe public dirs)
read -rp $'\n[?] Add sticky bit to /tmp and /var/tmp? (y/N): ' fix_choice
if [[ "$fix_choice" =~ ^[Yy]$ ]]; then
    chmod +t /tmp /var/tmp
    echo "[+] Sticky bit added to /tmp and /var/tmp"
fi

