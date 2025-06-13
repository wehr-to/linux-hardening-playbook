# sssd-hardening.md

## Purpose
Secure `sssd` (System Security Services Daemon) configuration to improve reliability, minimize information exposure, and ensure least privilege.

## Key Config File

**Path**: `/etc/sssd/sssd.conf`

### Permissions
```bash
sudo chown root:root /etc/sssd/sssd.conf
sudo chmod 600 /etc/sssd/sssd.conf
```

## Recommended Secure Settings

```ini
[sssd]
domains = corp.example.com
services = nss, pam
config_file_version = 2

[domain/corp.example.com]
id_provider = ad
auth_provider = ad
access_provider = simple
simple_allow_groups = ITAdmins
fallback_homedir = /home/%u
use_fully_qualified_names = False
cache_credentials = True
krb5_store_password_if_offline = True
entry_cache_timeout = 600
entry_cache_nowait_percentage = 50
account_cache_expiration = 1

# Optional performance/safety
enumerate = False
ldap_id_mapping = True

# Logging
debug_level = 3
```

## Notes
- `use_fully_qualified_names = False` keeps usernames short
- `enumerate = False` avoids long delays from pulling entire domain
- `cache_credentials = True` enables offline logins
- `simple_allow_groups` restricts logins to AD group

## Validate
```bash
sudo systemctl restart sssd
sudo id aduser
getent passwd aduser
```
Logs:
- `/var/log/sssd/sssd_domain.log`
- `/var/log/auth.log`

## Best Practices
- Monitor for group membership drift
- Periodically flush expired cache entries
- Avoid full `ad_access_filter` unless LDAP schema validated


