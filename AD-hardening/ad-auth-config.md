# Active Directory Authentication Hardening (ad-auth-config.md)

## Purpose
This guide walks through securely joining a Linux host to Active Directory (AD) using `realm`, `sssd`, and `kerberos`, with security-first defaults for access, logging, and recovery.

## Prerequisites
- AD DNS domain (e.g., `corp.example.com`)
- Linux host with:
  - `realmd`, `sssd`, `krb5-user`, `adcli`, `oddjob`
  - NTP synced to same time source as domain controllers

### Install Required Packages
```bash
sudo apt update
sudo apt install -y realmd sssd sssd-tools adcli krb5-user libnss-sss libpam-sss
```

## Discover AD Domain
```bash
realm discover corp.example.com
```
Ensure DNS and SRV records resolve. Fix `/etc/resolv.conf` if needed.

## Secure Join Process
```bash
sudo realm join --user=adminuser corp.example.com
```
- Use a limited-privilege account (not domain admin)
- If prompted for Kerberos config, accept secure defaults

## Hardened Access Rules
Limit login to specific AD groups:
```bash
sudo realm deny --all
sudo realm permit -g "corp.example.com/ITAdmins"
```
Confirm:
```bash
realm list
```

## Validate SSSD
```bash
id aduser@corp.example.com
getent passwd aduser@corp.example.com
```
If user lookup fails, check `/etc/sssd/sssd.conf`, permissions, and logs (`/var/log/sssd/`)

## Configuration Checklist
- `/etc/krb5.conf` — confirm `[libdefaults]` points to domain realm
- `/etc/sssd/sssd.conf`:
  ```ini
  [sssd]
  services = nss, pam
  domains = corp.example.com

  [domain/corp.example.com]
  fallback_homedir = /home/%u
  access_provider = simple
  simple_allow_groups = ITAdmins
  ```
- `/etc/nsswitch.conf`: ensure `passwd: files sss`
- PAM access control via `/etc/security/access.conf` or `pam_access.so`

## Final Test
```bash
ssh aduser@linuxhost
```

