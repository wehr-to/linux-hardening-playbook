# Hardened `journald` Settings Guide

## Purpose
This guide provides a secure configuration baseline for `systemd-journald`, the logging service used in modern Linux distributions.

`journald` logs are crucial for incident response and system visibility. Poor retention or insecure permissions can compromise audit trails.

## Why Harden `journald`?
- **Preserve forensic logs** during reboots or tampering
- **Limit excessive disk usage** with size and rotation controls
- **Control access** to sensitive logs from unauthorized users

## Configuration File
Edit: `/etc/systemd/journald.conf`

### Suggested Secure Settings:
```ini
[Journal]
Storage=persistent
Compress=yes
Seal=yes
SplitMode=uid
SystemMaxUse=500M
SystemKeepFree=100M
SystemMaxFileSize=50M
MaxRetentionSec=2week
ForwardToSyslog=yes
ForwardToWall=no
```

### Key Directives Explained:
- `Storage=persistent`: ensures logs survive reboot (in `/var/log/journal/`)
- `Seal=yes`: cryptographically seals logs against tampering
- `SystemMaxUse=500M`: limit total journal space
- `SystemKeepFree=100M`: always keep free disk space
- `MaxRetentionSec=2week`: auto-rotate after 2 weeks

## Permissions Best Practices
```bash
chmod 2755 /var/log/journal
chown root:systemd-journal /var/log/journal
```
Ensure only `root` and journal group can access persistent logs.

## 🛠 Apply Changes
```bash
systemctl restart systemd-journald
```

## Related Tips
- Use `journalctl --verify` to check log integrity
- Regularly backup `/var/log/journal` to immutable storage
- Consider forwarding to remote syslog for tamper-proof archival

## 📎 Reference
- [man journald.conf](https://www.freedesktop.org/software/systemd/man/journald.conf.html)
- CIS Linux Benchmark logging requirements

