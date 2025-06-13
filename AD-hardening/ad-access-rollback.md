# ad-access-rollback.md

## Purpose
Document how to safely recover Linux login access when Active Directory authentication fails, misconfigures, or causes lockouts.

## Prevention First
Before making any changes to AD auth:
- Create a local fallback admin account:
  ```bash
  sudo useradd -m -G sudo fallbackadmin
  sudo passwd fallbackadmin
  ```
- Verify SSH or console access with this account

## Common Recovery Scenarios

### 1. SSSD Not Starting or Misconfigured
```bash
sudo systemctl restart sssd
journalctl -u sssd -b --no-pager | tail -n 50
```
If `sssd.conf` is invalid, restore from backup:
```bash
sudo cp ./rollbacks-and-recovery/backups/sssd.conf.bak.* /etc/sssd/sssd.conf
sudo systemctl restart sssd
```

### 2. Broken Kerberos or Expired Tickets
```bash
kdestroy
kinit aduser@CORP.EXAMPLE.COM
klist
```

Check `/etc/krb5.conf` for realm or crypto errors. Restore known good version:
```bash
sudo cp ./rollbacks-and-recovery/backups/krb5.conf.bak.* /etc/krb5.conf
```

### 3. Locked Out Due to Sudoers Misrule
Boot into single-user mode or use console access:
```bash
sudo visudo -f /etc/sudoers.d/domain-admins
```
Temporarily comment out bad AD group entries.

### 4. Unresponsive Realmd / Realm Not Joined
```bash
realm list
realm discover corp.example.com
```
Rejoin if needed:
```bash
sudo realm join --user=adminuser corp.example.com
```

### 5. /etc/nsswitch.conf Misordered
Ensure `sss` is listed correctly:
```
passwd:     files sss
group:      files sss
shadow:     files sss
```

## Temporarily Disable SSSD Auth
To force use of local accounts only:
```bash
sudo systemctl stop sssd
sudo systemctl disable sssd
```

To re-enable:
```bash
sudo systemctl enable sssd
sudo systemctl start sssd
```

## Final Validation Steps
- `id testuser`
- `getent passwd testuser`
- `ssh testuser@host`

