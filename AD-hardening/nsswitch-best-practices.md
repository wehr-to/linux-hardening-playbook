# nsswitch-best-practices.md

## Purpose
Optimize `/etc/nsswitch.conf` to reduce login delays, avoid unnecessary lookups, and improve stability in AD-integrated Linux environments.

## Default File Location
```bash
/etc/nsswitch.conf
```

This file controls how name service lookups (users, groups, hosts) are resolved across local files, SSSD, LDAP, and more.

## Recommended Configuration
```conf
passwd:     files sss
shadow:     files sss
group:      files sss

hosts:      files dns
networks:   files

protocols:  db files
services:   db files
ethers:     db files
rpc:        db files

netgroup:   files sss
```

## Key Fields
| Field | Purpose |
|-------|---------|
| `passwd`, `group`, `shadow` | Resolve AD users + groups via SSSD |
| `hosts` | Avoid delay by querying `/etc/hosts` before DNS |
| `netgroup` | Supports group-based access control from LDAP/AD |

> Avoid `ldap` or `nis` if using `sssd`; they conflict and cause lookup loops.

## Avoid These Pitfalls
- `passwd: compat ldap` — introduces delays and misroutes auth
- `hosts: dns files` — causes slow boot/login if DNS is unavailable
- `sss` alone without `files` — prevents local user fallback

## Test Lookup Flow
```bash
getent passwd
getent passwd aduser
id aduser
```

If AD users don’t appear, validate `sssd` and `nsswitch.conf` order.
