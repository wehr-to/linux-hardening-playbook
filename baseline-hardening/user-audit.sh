#!/bin/bash
# user-audit.sh
# Audits local user accounts, UID usage, shell access, sudo rights, and last login activity.

set -e

echo "[*] Auditing user accounts on this system..."

echo -e "\n--- [ Users with UID 0 ] ---"
awk -F: '($3 == 0) { print $1 " (UID: "$3")" }' /etc/passwd

echo -e "\n--- [ All Local Users (UID >= 1000) ] ---"
awk -F: '($3 >= 1000 && $3 < 65534) { print $1 " (UID: "$3", Shell: "$7")" }' /etc/passwd

echo -e "\n--- [ Users with Login Shell Access ] ---"
awk -F: '($7 !~ /nologin|false/) { print $1 " (Shell: "$7")" }' /etc/passwd

echo -e "\n--- [ Users in the sudo or wheel Group ] ---"
getent group sudo wheel 2>/dev/null | cut -d: -f4 | tr ',' '\n' | sort | uniq | sed '/^$/d'

echo -e "\n--- [ Last Login for Each User ] ---"
lastlog | grep -v "Never logged in"

echo -e "\n--- [ Users with Empty Passwords ] ---"
sudo awk -F: '($2 == "") { print $1 " has an empty password!" }' /etc/shadow

echo -e "\n[+] User account audit complete."
