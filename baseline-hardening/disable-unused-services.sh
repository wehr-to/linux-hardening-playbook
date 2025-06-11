To quickly disable services at once: 
systemctl disable avahi-daemon cups bluetooth

#!/bin/bash
# disable-unused-services.sh
# Disables commonly unnecessary services to reduce attack surface

set -e

SERVICES_TO_DISABLE=(
    avahi-daemon      # Zeroconf/Bonjour — rarely needed
    cups              # Printer service — not needed on servers
    bluetooth         # Not needed in VMs or most enterprise setups
    ModemManager      # For mobile broadband — typically unused
    rpcbind           # For NFS/RPC — only needed if using those services
    ufw               # Replace if using nftables/firewalld manually
)

echo "[*] Disabling unnecessary services..."
for service in "${SERVICES_TO_DISABLE[@]}"; do
    if systemctl list-unit-files | grep -q "^$service"; then
        echo "  - Disabling $service"
        sudo systemctl disable --now "$service"
    else
        echo "  - $service not installed or not managed by systemd"
    fi
done

echo "[+] Service cleanup complete."
