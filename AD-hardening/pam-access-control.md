# pam-access-control.md

## Purpose
Use PAM (`Pluggable Authentication Modules`) to explicitly control which domain users or groups can access a Linux host. This augments `sssd` or `realm permit` rules with file-based access enforcement.

## PAM Access Layers
- `/etc/pam.d/common-auth` — primary auth control
- `/etc/security/access.conf` — whitelist/blacklist control file

> **Note**: PAM evaluation is top-down and fails closed. Misconfigurations can lock you out.

## Enable PAM Access Restrictions
Edit the session-level PAM config:
```bash
sudo nano /etc/pam.d/common-auth
```

Add this line **before** `pam_unix.so` or `pam_sss.so`:
```bash
auth required pam_access.so
```

## Configure `/etc/security/access.conf`
This file restricts who may access the system.

### Allow Only Specific Domain Group:
```
+ : (ITAdmins) : ALL
- : ALL : ALL
```

### Allow Specific User and Domain Group:
```
+ : fallbackadmin : ALL
+ : (ITAuditors) : ALL
- : ALL : ALL
```

> `()` denotes group name if using `pam_access.so` with `sssd`

## Test
Use SSH or login shell:
```bash
ssh aduser@host
```
Blocked users will see:
```
Access denied.
```

Check logs:
```bash
sudo journalctl -xe | grep pam_access
```

## Recovery Tip
Always test from a second open session before restarting services. Keep local admin access available.
