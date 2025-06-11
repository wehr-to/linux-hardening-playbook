## How to Use This Checklist
- Build each script to address one or more of the above checklist items.
- Document status in checklist.md
- Use an audit.sh to validate all current hardening steps
- Maintain before/after evidence for compliance audits

## 1. Filesystem & Boot
 - Set nodev, nosuid, noexec on /tmp, /var/tmp, /dev/shm
 - Disable unused filesystems: cramfs, squashfs, udf
 - Enable filesystem integrity tool: aide
 - Restrict boot loader config: /boot/grub/grub.cfg permissions

## 2. Services & Daemons
- Disable unused services: avahi, cups, bluetooth, rpcbind, ModemManager
- Configure time sync securely: chrony or systemd-timesyncd
- Enable AppArmor or SELinux (as applicable)

## 3. Network Configuration
- Disable IP forwarding
- Disable packet redirects
- Enable spoofing protection: rp_filter
- Harden /etc/sysctl.conf and /etc/sysctl.d/
- Disable IPv6 (if unused)

## 4. Logging & Auditing
- Enable and configure rsyslog or journald
- Restrict log file permissions (600)
- Install and enable auditd
- Configure audit rules (priv escalation, passwd changes, su/sudo use)

## 5. Access, Auth, Users
- Set secure umask (027)
- Lock inactive accounts after 30–35 days
- Enforce password aging and complexity (pam_pwquality)
- Disable root login (local + SSH)
- Remove/lock unused users
- Restrict cron and at to authorized users only

## 6. SSH Configuration
- Set PermitRootLogin no
- Set Protocol 2, disable legacy ciphers/MACs
- Enable SSH login banner (/etc/issue.net)
- Limit access via AllowUsers, AllowGroups (if needed)
- Set LoginGraceTime, MaxAuthTries

## 7. Account Monitoring
- Audit users with UID 0
- List users with shell access
- Detect users with empty passwords
- List sudoers, wheel members
- Review lastlog, inactive accounts

## 8. System Maintenance
- Enable automatic security updates (unattended-upgrades)
- Restrict access to compilers (e.g. gcc)
- Remove unnecessary packages (debian-goodies, nmap, etc.)
- Maintain backup copies of /etc and critical confs
