# ldap-security-checklist.md

## Purpose
Ensure LDAP/Active Directory (AD) integrations use secure protocols, hardened bindings, schema controls, and minimize exposure to directory attacks.

## 1. Transport Security
- [ ] Use **LDAPS (port 636)** or **StartTLS (port 389)**
- [ ] Validate SSL certificates via CA chain
- [ ] Reject self-signed certs unless trusted internally
- [ ] Verify `ldap_tls_cacert` is correctly set in `sssd.conf`:
  ```ini
  ldap_tls_cacert = /etc/ssl/certs/your-ca.pem
  ```

## 2. Bind Account Hygiene
- [ ] Use a **read-only, least-privileged** service account
- [ ] Enforce IP restrictions or AD GPO on the bind user
- [ ] Rotate credentials regularly and never reuse admin creds

## 3. Schema & Search Scope
- [ ] Limit LDAP base DN to a minimal OU
  ```ini
  ldap_search_base = OU=Linux,DC=corp,DC=example,DC=com
  ```
- [ ] Avoid wide or deep queries across full domain trees
- [ ] Whitelist object classes or attributes if possible
- [ ] Avoid `enumerate = true` in `sssd.conf`

## 4. Access Filtering
- [ ] Use group-based filters:
  ```ini
  access_provider = ldap
  ldap_access_filter = (memberOf=CN=ITAdmins,OU=Groups,DC=corp,DC=example,DC=com)
  ```
- [ ] Confirm `access_provider` is not set to `permit`
- [ ] Use PAM layer as an additional restriction if needed (`pam_access.so`)

## 5. Logging & Alerts
- [ ] Enable verbose LDAP client logging (`sssd.conf` `debug_level = 3`+)
- [ ] Monitor `/var/log/sssd` and `/var/log/auth.log` for excessive queries
- [ ] Detect authentication failures and lockouts with SIEM or auditd

## 6. Validation Commands
```bash
ldapsearch -x -H ldaps://dc.corp.example.com -D "binduser@corp.example.com" -W -b "dc=corp,dc=example,dc=com"
getent passwd aduser
id aduser
```

## 📎 Related
- `sssd-hardening.md`
- `ad-auth-config.md`
- `ad-audit-checks.sh`
