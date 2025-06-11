# auditd-rollback.md

## Purpose
This guide explains how to safely revert auditd settings and restore a known working configuration in case of misconfiguration, system errors, or policy rollback.

## When To Roll Back
- You applied audit rules that caused performance degradation
- auditd won't start due to syntax/config errors
- You need to revert to a previously tested baseline (lab vs production)

## Restore Steps

### 1. Stop the Audit Daemon
```bash
sudo systemctl stop auditd
```

### 2. Restore Configuration Files
If you backed up before applying new settings:
```bash
sudo cp /etc/audit/auditd.conf.bak /etc/audit/auditd.conf
sudo cp /etc/audit/rules.d/hardening.rules.bak /etc/audit/rules.d/hardening.rules
```
If you did not create a backup, use a known-good default config from your toolkit:
```bash
cp ./references/auditd-default.conf /etc/audit/auditd.conf
cp ./references/auditd-rules-default.rules /etc/audit/rules.d/hardening.rules
```

### 3. Reload and Restart
```bash
sudo augenrules --load
sudo systemctl restart auditd
```

### 4. Validate Status
```bash
sudo systemctl status auditd
sudo auditctl -l
```

## Best Practices
- Always create backups of `auditd.conf` and `rules.d/*.rules` before applying changes
- Test new rules with `auditctl` before making them persistent
- Document changes and save backup copies in `rollbacks-and-recovery/snapshots/`

## Reference Locations
- Config file: `/etc/audit/auditd.conf`
- Rules dir: `/etc/audit/rules.d/`
- CLI status: `auditctl -s`, `auditctl -l`

## 📎 Related
- See [`auditd-config.sh`](../../logging-and-auditing/auditd-config.sh)
- Use [`pre-hardening-backup.sh`](../backup-hooks/) before changes

