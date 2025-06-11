# `logrotate` Security Best Practices

## Purpose
This guide documents secure practices for configuring `logrotate` to manage Linux log files responsibly. Proper rotation and permissions help prevent log-based DoS and protect sensitive audit trails.

## Why Harden `logrotate`?
- **Prevent disk exhaustion** from uncontrolled log growth
- **Avoid sensitive log exposure** via insecure file permissions
- **Ensure audit integrity** with secure rotation and archival

## Recommended Settings
Edit or create files in `/etc/logrotate.d/` or update `/etc/logrotate.conf`

### Example Secure Block:
```conf
/var/log/auth.log
{
    weekly
    rotate 4
    compress
    delaycompress
    missingok
    notifempty
    create 0600 root adm
    postrotate
        systemctl reload rsyslog >/dev/null 2>&1 || true
    endscript
}
```

### Explanation:
- `weekly`: rotates once a week
- `rotate 4`: keeps last 4 logs (1 month)
- `compress`: enables gzip compression
- `delaycompress`: avoids compressing the latest log file
- `create 0600 root adm`: sets restrictive permissions on new log files
- `postrotate`: safely reloads logging daemon

## General Security Tips
- Always use `create` with `0600` or `0640` and correct ownership
- Use `copytruncate` **only** if the service can’t reopen logs
- Avoid `sharedscripts` unless absolutely needed
- Place sensitive log rules (e.g., `/var/log/audit/audit.log`) in `/etc/logrotate.d/` with dedicated configs

## Validation
Manually test with:
```bash
logrotate -d /etc/logrotate.conf      # dry-run
logrotate -f /etc/logrotate.conf      # force rotate
```

Check rotated logs:
```bash
ls -l /var/log/*.gz
```

## 📎 References
- [man logrotate](https://man7.org/linux/man-pages/man8/logrotate.8.html)
- [CIS Benchmarks Logging Controls](https://www.cisecurity.org/)

## Related
- Harden `rsyslog` or `journald` to match logrotate retention
- Include logrotate status in system audit scripts

