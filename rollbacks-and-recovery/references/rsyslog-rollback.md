# rsyslog-rollback.md

## Purpose
This guide provides rollback procedures for restoring `rsyslog` to a default or known-good state, especially after misconfiguration or connectivity loss to remote log targets.

## When To Roll Back
- Logging stops unexpectedly after `rsyslog.conf` edits
- System boot is delayed due to socket or rule misconfig
- Remote forwarding breaks due to TLS or port changes

## Restore Steps

### 1. Stop rsyslog (Optional but Safe)
```bash
sudo systemctl stop rsyslog
```

### 2. Restore Configuration File
If backed up:
```bash
sudo cp /etc/rsyslog.conf.bak /etc/rsyslog.conf
sudo cp /etc/rsyslog.d/hardening.conf.bak /etc/rsyslog.d/hardening.conf
```
Or, use default from the toolkit:
```bash
cp ./references/rsyslog-default.conf /etc/rsyslog.conf
cp ./references/rsyslog-hardening-default.conf /etc/rsyslog.d/hardening.conf
```

### 3. Validate Syntax
```bash
sudo rsyslogd -N1
```
This checks for syntax errors without starting the daemon.

### 4. Restart the Service
```bash
sudo systemctl restart rsyslog
```

### 5. Confirm Logs Are Flowing
```bash
logger "[test] rsyslog recovery test"
sudo tail /var/log/syslog
```

## Key Files
- Main config: `/etc/rsyslog.conf`
- Drop-in rules: `/etc/rsyslog.d/*.conf`
- Default logs: `/var/log/syslog`, `/var/log/auth.log`, etc.

## Best Practices
- Always back up `/etc/rsyslog.*` before hardening
- Use `rsyslogd -N1` after changes
- Store safe templates in `rollbacks-and-recovery/references/`

## Related
- See [`rsyslog-hardening.md`](../../logging-and-auditing/rsyslog-hardening.md)
- Use [`pre-hardening-backup.sh`](../backup-hooks/) for automated backups
