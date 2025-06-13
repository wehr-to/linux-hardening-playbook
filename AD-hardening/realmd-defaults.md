# realmd-defaults.md

## Purpose
Secure usage of the `realm` utility to join Linux systems to Active Directory (AD), while avoiding misconfigurations, unneeded daemons, or overly permissive defaults.

## About `realmd`
`realmd` simplifies domain discovery and join operations. It configures:
- `/etc/sssd/sssd.conf`
- `/etc/krb5.conf`
- PAM and NSS integration

> While convenient, `realm join` often applies loose defaults.

## Recommended Pre-Join Checklist

1. Confirm time sync:
```bash
timedatectl status | grep NTP
```

2. Confirm DNS resolves domain controllers:
```bash
host -t SRV _kerberos._tcp.corp.example.com
```

3. Inspect what changes will be made:
```bash
realm discover corp.example.com -v
```

## Secure Join
```bash
sudo realm join --user=ad-joiner corp.example.com --computer-ou="OU=Linux,DC=corp,DC=example,DC=com" --automatic-id-mapping=no
```

### Key Options
| Flag | Description |
|------|-------------|
| `--user` | Use a non-domain-admin user with join rights |
| `--computer-ou` | Places object in specific AD OU |
| `--automatic-id-mapping=no` | Preserves AD UID/GID values (use with `ldap_id_mapping = True`) |

> Consider pairing with a hardened `sssd.conf` template post-join.

## Risky Defaults to Avoid
- Joining without `--automatic-id-mapping=no` may break file permissions
- Not specifying OU may create clutter in `CN=Computers`
- `use_fully_qualified_names = True` leads to `user@DOMAIN` naming confusion

## Validate Post-Join
```bash
realm list
id aduser
getent passwd aduser
```

## Cleanup Example
To leave domain:
```bash
sudo realm leave --user=ad-joiner corp.example.com
```

To fully reset:
```bash
sudo realm leave --remove
sudo systemctl stop sssd
sudo rm -rf /etc/sssd /var/lib/sss
sudo rm -f /etc/krb5.conf
```

