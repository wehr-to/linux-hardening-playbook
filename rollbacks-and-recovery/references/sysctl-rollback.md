# sysctl-rollback.md

## Purpose
This guide explains how to revert hardened `sysctl` settings that affect kernel-level security and networking. Use it when a misapplied or incompatible `sysctl` policy causes service disruption or instability.

## When To Roll Back
- System performance degrades after applying sysctl hardening
- Kernel networking features break (e.g., ICMP, IPv6, routing)
- A previous working config is needed to restore default behavior

## Restore Steps

### 1. Identify the Source File
Sysctl settings may be in:
- `/etc/sysctl.conf`
- `/etc/sysctl.d/*.conf`
- Applied directly with `sysctl -w`

### 2. Restore Config Files
If you backed up:
```bash
cp /etc/sysctl.d/99-sysctl-hardening.conf.bak /etc/sysctl.d/99-sysctl-hardening.conf
```
Or use toolkit reference:
```bash
cp ./references/sysctl-default.conf /etc/sysctl.d/99-sysctl-hardening.conf
```

### 3. Reapply Sysctl Settings
```bash
sysctl --system
```
Or apply specific file only:
```bash
sysctl -p /etc/sysctl.d/99-sysctl-hardening.conf
```

### 4. Confirm Key Settings
```bash
sysctl net.ipv4.ip_forward
sysctl kernel.kptr_restrict
```

## Defaults (Safe Examples)
```conf
net.ipv4.ip_forward = 0
net.ipv6.conf.all.forwarding = 0
kernel.kptr_restrict = 0
fs.suid_dumpable = 1
```

## 📎 Key Paths
- `/etc/sysctl.conf`
- `/etc/sysctl.d/*.conf`
- Runtime values: `/proc/sys/*`

## Best Practices
- Back up all custom `.conf` files in `/etc/sysctl.d/`
- Never use `sysctl -w` for persistent changes
- Validate with `sysctl --system` and reboot if needed

## 📎 Related
- See [`sysctl-hardening.conf`](../../kernel-and-services/sysctl-hardening.conf)
- Use [`pre-hardening-backup.sh`](../backup-hooks/) before changes

