#!/bin/bash
# world-writable-scan.sh
# Scan and log all world-writable files and directories

LOG_DIR="./logs"
mkdir -p "$LOG_DIR"

WW_DIR_LOG="$LOG_DIR/world-writable-dirs.log"
WW_FILE_LOG="$LOG_DIR/world-writable-files.log"

# Find world-writable directories (excluding /proc, /sys, etc.)
find / -xdev -type d -perm -0002 -exec ls -ld {} + 2>/dev/null | tee "$WW_DIR_LOG"

# Find world-writable files
find / -xdev -type f -perm -0002 -exec ls -l {} + 2>/dev/null | tee "$WW_FILE_LOG"

printf "\n[+] Results saved in: $LOG_DIR\n"
printf "  - World-writable directories: $WW_DIR_LOG\n"
printf "  - World-writable files: $WW_FILE_LOG\n"

# Optional flag to alert on findings
if [[ -s "$WW_FILE_LOG" || -s "$WW_DIR_LOG" ]]; then
  echo "[!] WARNING: World-writable files or directories found. Review immediately."
else
  echo "[+] No world-writable files or directories found."
fi

