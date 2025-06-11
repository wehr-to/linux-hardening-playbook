# IPv6 Toggle Guide

## Purpose
This guide explains how to safely **disable or enable IPv6** on Linux systems, depending on your network policy and threat model.

IPv6 is increasingly supported, but often unnecessary in local or air-gapped environments. Disabling unused protocols is a common hardening practice.

## Why Consider Disabling IPv6?
- **Attack Surface Reduction:** Limits exposure to misconfigured or unmonitored IPv6 interfaces
- **Simplifies Firewalling:** Reduces complexity in `iptables`/`nftables` rule management
- **Legacy/Isolated Systems:** IPv6 isn't required in non-Internet-facing systems

## Disable IPv6 (Temporary & Persistent)

### 1. Temporary (until reboot):
```bash
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1
```

### 2. Persistent (across reboots):
Add to `/etc/sysctl.conf` or `/etc/sysctl.d/99-sysctl.conf`:
```conf
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
```
Then reload:
```bash
sysctl -p
```

## Enable IPv6 Again
To reverse the configuration, set the values to `0` and reload:
```bash
sysctl -w net.ipv6.conf.all.disable_ipv6=0
sysctl -w net.ipv6.conf.default.disable_ipv6=0
```
Or update `sysctl.conf` accordingly.

## Important Notes
- Some applications (e.g., Postfix, systemd-resolved) rely on IPv6; test before disabling in production.
- Fully disabling IPv6 at the kernel boot level can be done via GRUB:
  ```bash
  GRUB_CMDLINE_LINUX="ipv6.disable=1"
  update-grub
  reboot
  ```
- Verify status with:
  ```bash
  cat /proc/sys/net/ipv6/conf/all/disable_ipv6
  ```

## Related
- Harden interface exposure via `ufw` or `iptables`
- Consider dual-stack firewall rules if enabling IPv6
- Audit with tools like `nmap -6` and `netstat -6`

