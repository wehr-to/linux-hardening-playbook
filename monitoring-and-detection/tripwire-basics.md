# Tripwire Basics Guide

## Purpose
This guide provides an introduction to using **Tripwire**, a host-based intrusion detection system (HIDS) that verifies the integrity of system files through cryptographic signatures.

Tripwire helps detect unauthorized changes to binaries, configuration files, and system directories.

## Why Use Tripwire?
- Detects rootkits, file tampering, and unauthorized modifications
- Maintains a secure cryptographic baseline
- Customizable policy files and rule granularity

## Installation (Debian/Ubuntu)
```bash
sudo apt update && sudo apt install tripwire -y
```
You'll be prompted to set two passphrases:
1. **Site key**: for policy and config signing
2. **Local key**: for database signing

## Initialization Steps

### 1. Generate Keys
If skipped during install:
```bash
sudo twadmin --generate-keys --site-keyfile /etc/tripwire/site.key --local-keyfile /etc/tripwire/$(hostname)-local.key
```

### 2. Customize Policy File (Optional)
```bash
sudo cp /etc/tripwire/twpol.txt /etc/tripwire/twpol.local
```
Edit `twpol.local` to tailor to your system, then:
```bash
sudo twadmin --create-polfile --site-keyfile /etc/tripwire/site.key twpol.local
```

### 3. Initialize Baseline Database
```bash
sudo tripwire --init
```

## Running a Check
```bash
sudo tripwire --check
```
- Use `--check --quiet` for cron jobs
- Outputs modified, added, or deleted files

## After Updates
If legitimate changes occur:
```bash
sudo tripwire --update --twrfile /var/lib/tripwire/report-<timestamp>.twr
```
Enter your local passphrase to sign the new baseline.

## Key File Locations
- Policy file: `/etc/tripwire/twpol.txt`
- Reports: `/var/lib/tripwire/*.twr`
- Keys: `/etc/tripwire/*.key`

## Cron Automation (Example)
```cron
0 2 * * * /usr/sbin/tripwire --check --quiet | mail -s "Tripwire Report $(hostname)" root
```

## Best Practices
- Store site/local keys in a secure location
- Hash and back up policy and baseline DB
- Use alongside AIDE and auditd for layered integrity monitoring

## References
- [Tripwire Docs](https://github.com/Tripwire/tripwire-open-source)
- `man tripwire`, `man twadmin`, `man twprint`

