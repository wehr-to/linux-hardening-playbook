# sshd-rollback.md

## Purpose
This guide explains how to roll back changes made to the SSH daemon (`sshd`) configuration, especially after hardening edits that cause service failures or user lockouts.

## When To Roll Back
- SSH service fails to start after editing `sshd_config`
- Remote access is broken due to overly restrictive settings
- Configured options (e.g., `PermitRootLogin`, `PasswordAuthentication`) block valid auth methods

## Restore Steps

### 1. Gain Access
- Use physical access, console, recovery boot, or alternate root access
- Mount and chroot if needed using Live CD:
```bash
mount /dev/sdXn /mnt
mount --bind /dev /mnt/dev && mount --bind /proc /mnt/proc && mount --bind /sys /mnt/sys
chroot /mnt
```

### 2. Restore sshd_config
If you made a backup:
```bash
cp /etc/ssh/sshd_config.bak /etc/ssh/sshd_config
```
Otherwise, use toolkit-safe defaults:
```bash
cp ./references/sshd-default.conf /etc/ssh/sshd_config
```

### 3. Test Configuration
```bash
sshd -t
```
Should return nothing if valid.

### 4. Restart SSH Service
```bash
systemctl restart sshd
```

### 5. Confirm Listening Port & Access
```bash
ss -tulnp | grep ssh
```
Try reconnecting from a trusted host:
```bash
ssh -v user@hostname
```

## Safe Defaults for Recovery
Ensure the following are set:
```conf
PermitRootLogin yes
PasswordAuthentication yes
Port 22
```
⚠️ Use only during recovery — revert once access is restored.

## 📎 Paths
- Config: `/etc/ssh/sshd_config`
- Logs: `/var/log/auth.log`

## Best Practices
- Back up `sshd_config` before hardening
- Validate with `sshd -t` and test in staging first
- Monitor logins with `journalctl -u ssh` or `last`

## Related
- See [`sshd-lockdown.sh`](../../baseline-hardening/sshd-lockdown.sh)
- Use [`pre-hardening-backup.sh`](../backup-hooks/) before SSH changes

