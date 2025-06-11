#!/bin/bash
# disable-unused-services.sh
# Disables unnecessary services to harden the system

set -euo pipefail

timestamp() {
    date +"[%Y-%m-%d %H:%M:%S]"
}

log() {
    echo "$(timestamp) $1"
}

SERVICES_TO_DISABLE=(
    avahi-daemon
    cups
    bluetooth
    ModemManager
    rpcbind
    ufw
)

log "[*] Disabling unused services..."

for service in "${SERVICES_TO_DISABLE[@]}"; do
    if systemctl list-unit-files | grep -q "^$service"; then
        STATUS=$(systemctl is-enabled "$service" 2>/dev/null || echo "disabled")
        if [[ "$STATUS" == "enabled" ]]; then
            log "  - Disabling $service..."
            sudo systemctl disable --now "$service"
            log "    > $service disabled."
        else
            log "  - $service already disabled."
        fi
    else
        log "  - $service not found or not managed by systemd."
    fi
done

log "[✓] Unused services processed."
