# AIDE Setup Guide (Advanced Intrusion Detection Environment)

## Purpose
This guide walks through installing, initializing, and using AIDE — a lightweight host-based intrusion detection system (HIDS) — to monitor file integrity changes.

AIDE detects unauthorized modifications to critical files and system binaries, a key control in CIS, NIST, and PCI-DSS.

## Why Use AIDE?
- Detects rootkits, unauthorized file edits, or tampering
- Provides cryptographic checksums for file verification
- Lightweight and suitable for servers and endpoint monitoring

## Installation (Debian/Ubuntu)
```bash
sudo apt update && sudo apt install aide -y
```

## Initial Configuration
### 1. Customize Rule File:
Edit `/etc/aide/aide.conf` or drop-in config at `/etc/aide/aide.conf.d/`

Example monitored paths:
```conf
/etc    NORMAL
/bin    NORMAL
/sbin   NORMAL
/usr    NORMAL
/boot   NORMAL
```
Use `LOG_MD5`, `RMD160`, `SHA512` for high-integrity checks.

### 2. Initialize Database
```bash
sudo aideinit
```
Copy the generated DB:
```bash
sudo cp /var/lib/aide/aide.db.new /var/lib/aide/aide.db
```

## Running AIDE Integrity Checks
Run periodically or via cron:
```bash
sudo aide.wrapper --check
```

### Typical output:
- Modified files listed with old/new hash
- Missing or new files flagged

## Automate Checks
Example crontab entry (daily at 1AM):
```cron
0 1 * * * /usr/bin/aide.wrapper --check | mail -s "AIDE Report $(hostname)" root
```

## Tips for Hardening
- Store baseline DB in a read-only location (`/root/aide-backups/`, CD-ROM, or offline backup)
- Review changes carefully; unexpected deltas = red flags
- Integrate with SIEM for alerting

## References
- [AIDE Project](https://aide.github.io/)
- [man aide.conf](https://man7.org/linux/man-pages/man5/aide.conf.5.html)
- CIS Controls 5 & 7: Inventory & File Integrity Monitoring

