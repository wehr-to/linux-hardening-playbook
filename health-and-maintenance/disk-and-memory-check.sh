#!/bin/bash
# disk-and-memory-check.sh
# Basic health check for disk space and memory usage

LOG_DIR="./logs"
mkdir -p "$LOG_DIR"

HEALTH_LOG="$LOG_DIR/health-check.log"
echo "[+] Health Check - $(date)" > "$HEALTH_LOG"

# Disk Usage Summary (all mount points)
echo -e "\n[Disk Usage]" >> "$HEALTH_LOG"
df -hT | grep -vE '^tmpfs|^udev' >> "$HEALTH_LOG"

# Detect File Systems Over 90%
df -h | awk 'NR>1 { if ($5+0 >= 90) print "WARNING: " $6 " is at " $5 }' >> "$HEALTH_LOG"

# Memory Usage
echo -e "\n[Memory Usage]" >> "$HEALTH_LOG"
free -h >> "$HEALTH_LOG"

# Top 5 Memory-Consuming Processes
echo -e "\n[Top 5 Memory-Hungry Processes]" >> "$HEALTH_LOG"
ps aux --sort=-%mem | head -n 6 >> "$HEALTH_LOG"

# Output location
cat "$HEALTH_LOG"
echo "\n[+] Report saved to: $HEALTH_LOG"

