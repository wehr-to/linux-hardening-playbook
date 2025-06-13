# krb5-secure-config.md

## Purpose
Secure `krb5.conf` settings to improve Kerberos authentication security, reduce ticket abuse, and ensure interoperability with AD.

## Path
`/etc/krb5.conf`

## Example Hardened Configuration

```ini
[libdefaults]
default_realm = CORP.EXAMPLE.COM
clockskew = 300
rdns = false
ticket_lifetime = 10h	renew_lifetime = 7d
forwardable = false
allow_weak_crypto = false
udp_preference_limit = 1

[realms]
CORP.EXAMPLE.COM = {
  kdc = dc1.corp.example.com
  admin_server = dc1.corp.example.com
  default_domain = corp.example.com
}

[domain_realm]
.corp.example.com = CORP.EXAMPLE.COM
corp.example.com = CORP.EXAMPLE.COM
```

## Key Security Points
| Setting | Purpose |
|---------|---------|
| `ticket_lifetime` | Short-lived tickets reduce exposure if stolen |
| `renew_lifetime` | Limits maximum total duration of credential reuse |
| `forwardable = false` | Prevents tickets from being reused on other systems |
| `allow_weak_crypto = false` | Enforces modern encryption (AES) only |
| `rdns = false` | Prevents hostname-based KDC lookup spoofing |

## Test It
```bash
kinit aduser
klist
```
Output should show limited ticket lifetime and valid realm.

## Tips
- Always ensure system time is synced via NTP
- Avoid default `/etc/krb5.conf` templates that include weak crypto
- Combine with hardened SSSD + AD group restrictions

