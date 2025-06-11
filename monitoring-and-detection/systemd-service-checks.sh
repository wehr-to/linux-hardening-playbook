#!/bin/bash
# systemd-service-checks.sh
# Audit systemd services: failed, disabled, enabled, unusual states

set -euo pipefail

LOG_DIR="./logs"
mkdir -p "$LOG_DIR"
OUT="$LOG_DIR/systemd-service-checks-$(date +%F).log"

exec > >(tee "$OUT") 2>&1

echo "=================== SYSTEMD SERVICE CHECK ==================="
echo "Generated: $(date)"
echo "============================================================"

# List failed services
echo -e "\n[FAILED SERVICES]"
systemctl --failed || true

# List all services that are enabled to start on boot
echo -e "\n[ENABLED SERVICES]"
systemctl list-unit-files --type=service | grep enabled

# List explicitly disabled services
echo -e "\n[DISABLED SERVICES]"
systemctl list-unit-files --type=service | grep disabled

# List services in abnormal states (exited, inactive, dead)
echo -e "\n[NON-ACTIVE SERVICES]"
systemctl list-units --type=service --state=inactive,dead,failed

# Optional: look for listening sockets and the service behind them
echo -e "\n[ACTIVE LISTENING SOCKETS]"
ss -tulnp

echo -e "\n[+] systemd service audit completed. Log saved at $OUT"

