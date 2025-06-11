# journald-rollback.md

## Purpose
This guide explains how to roll back `systemd-journald` logging configurations to default settings, particularly after applying performance or hardening changes.

## When To Roll Back
- Persistent logs consuming unexpected disk space
- Journald fails to start due to syntax errors
- Log rotation or retention settings too aggressive or too loose

## Restore Steps

### 1. Stop `journald` Service (Optional for Safety)
```bash
sudo systemctl stop systemd-journald
```

### 2. Restore Config File
If a backup was created:
```bash
sudo cp /etc/systemd/journald.conf.bak /etc/systemd/journald.conf
```
Otherwise, use toolkit-safe defaults:
```bash
cp ./references/journald-default.conf /etc/systemd/journald.conf
```

### 3. Restart `journald`
```bash
sudo systemctl restart systemd-journald
```

### 4. Validate Status and Settings
```bash
sudo systemctl status systemd-journald
journalctl --verify
```

## Common Defaults
```ini
[Journal]
Storage=auto
Compress=yes
SystemMaxUse=
SystemKeepFree=
SystemMaxFileSize=
MaxRetentionSec=
ForwardToSyslog=yes
```

## Key Paths
- Config: `/etc/systemd/journald.conf`
- Logs: `/var/log/journal/` (if persistent)
- Runtime logs: `/run/log/journal/`

## Best Practices
- Use `systemctl daemon-reexec` after restoring configs (if needed)
- Always validate `journald.conf` changes with `journalctl --verify`
- Store safe versions in `rollbacks-and-recovery/references/`

## Related
- See [`journald-setting.md`](../../logging-and-auditing/journald-setting.md)
- Backup before edits using [`pre-hardening-backup.sh`](../backup-hooks/)

