#!/bin/bash
# user-expiry-check.sh
# List all local users with account expiry details

set -euo pipefail

LOG_DIR="./logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/user-expiry-check-$(date +%F).log"

exec > >(tee "$LOG_FILE") 2>&1

printf "==================== USER EXPIRY REPORT ====================\n"
printf "Generated: %s\n" "$(date)"
printf "===========================================================\n"

# Get local user accounts with UID >= 1000 and not system accounts
printf "\n%-20s %-15s %-15s\n" "Username" "Expire Date" "Status"
printf "%-20s %-15s %-15s\n" "--------" "-----------" "------"

awk -F: '($3 >= 1000 && $1 != "nobody") { print $1 }' /etc/passwd | while read -r user; do
    expire_date=$(chage -l "$user" | grep "Account expires" | cut -d: -f2 | xargs)
    status="ACTIVE"
    [[ "$expire_date" == "never" ]] && status="NO-EXPIRY"
    [[ "$expire_date" != "never" && $(date -d "$expire_date" +%s) -lt $(date +%s) ]] && status="EXPIRED"
    printf "%-20s %-15s %-15s\n" "$user" "$expire_date" "$status"
done

printf "\n[+] Report saved to: $LOG_FILE\n"
