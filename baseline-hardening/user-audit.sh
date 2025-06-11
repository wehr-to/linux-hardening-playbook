#!/bin/bash
# user-audit.sh
# Audits local user accounts, UID usage, shell access, sudo rights, and last login activity.

set -euo pipefail

timestamp() {
    date +"[%Y-%m-%d %H:%M:%S]"
}

log() {
    echo -e "\n[$(timestamp)] $1"
}

log "--- [ Users with UID 0 ] ---"
awk -F: '($3 == 0) { print $1 " (UID: "$3")" }' /etc/passwd

log "--- [ All Local Users (UID >= 1000) ] ---"
awk -F: '($3 >= 1000 && $3 < 65534) { print $1 " (UID: "$3", Shell: "$7")" }' /etc/passwd

log "--- [ Users with Login Shell Access ] ---"
awk -F: '($7 !~ /(nologin|false)$/) { print $1 " (Shell: "$7")" }' /etc/passwd

log "--- [ Users in the sudo or wheel Group ] ---"
for grp in sudo wheel; do
    getent group "$grp" 2>/dev/null | cut -d: -f4 | tr ',' '\n'
done | sort -u | sed '/^$/d'

log "--- [ Last Login for Each User ] ---"
lastlog | awk 'NR==1 || $0 !~ /Never logged in/'

log "--- [ Users with Empty Passwords ] ---"
sudo awk -F: '($2 == "") { print $1 " has an empty password!" }' /etc/shadow || echo "Unable to access /etc/shadow (need sudo?)"

log "[✓] User account audit complete."
