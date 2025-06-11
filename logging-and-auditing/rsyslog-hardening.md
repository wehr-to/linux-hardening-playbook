# Rsyslog Hardening Guide

## Purpose
This guide outlines how to securely configure `rsyslog`, a common syslog daemon, to enhance log integrity, reduce risk of tampering, and support reliable central logging.

## Why Harden `rsyslog`?
- **Protects log integrity** from tampering or unauthorized access
- **Ensures completeness** of system logs
- **Supports centralized logging** to SIEM or log aggregation

## Recommended Settings
Edit `/etc/rsyslog.conf` and files in `/etc/rsyslog.d/`

### 1. File Ownership & Permissions
```bash
chown root:adm /var/log
chmod 0750 /var/log
```
Ensure log files created by rsyslog are readable only by root/adm:
```conf
$FileOwner root
$FileGroup adm
$FileCreateMode 0640
$DirCreateMode 0750
```

### 2. Enable Rate Limiting
Protect against log flood attacks:
```conf
$SystemLogRateLimitInterval 10
$SystemLogRateLimitBurst 200
```

### 3. Disable Unused Protocols
If TCP/UDP reception is not needed, comment these out:
```conf
#module(load="imudp")
#input(type="imudp" port="514")
#module(load="imtcp")
#input(type="imtcp" port="514")
```

### 4. Forward Logs to Remote Host (Optional)
```conf
*.* @@logs.example.com:514
```
Use `@@` for TCP and ensure TLS where applicable.

## Additional Recommendations
- Use separate files for auth, sudo, audit logs (in `/etc/rsyslog.d/`)
- Enable high precision timestamps:
  ```conf
  $ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat
  ```
- Consider enabling TLS for log forwarding using `gtls` module
- Use `logrotate` to manage file sizes securely

## Validation
Check syntax:
```bash
rsyslogd -N1
```
Restart service:
```bash
systemctl restart rsyslog
```
Confirm logs are flowing to expected files or remote targets.

## References
- [man rsyslog.conf](https://man7.org/linux/man-pages/man5/rsyslog.conf.5.html)
- [rsyslog Security Modules](https://www.rsyslog.com/doc/rsyslog_tls.html)
- CIS Benchmarks logging and audit controls

