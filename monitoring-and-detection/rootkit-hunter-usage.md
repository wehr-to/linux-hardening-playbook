# Rootkit Hunter (rkhunter) Usage Guide

## Purpose
This guide explains how to use **Rootkit Hunter (rkhunter)** to detect known rootkits, backdoors, and local exploits by scanning for suspicious files and behavior.

`rkhunter` compares the system against known signatures and heuristics. It’s lightweight and easy to integrate into a security baseline.

## Why Use rkhunter?
- Detects **hidden files, binaries, and kernel modules**
- Warns about **insecure permissions** or known suspicious patterns
- Provides **cron-friendly output** for scheduled scans

## Installation (Debian/Ubuntu)
```bash
sudo apt update && sudo apt install rkhunter -y
```

## Update Signatures & Properties
```bash
sudo rkhunter --update
sudo rkhunter --propupd  # Accept current file properties as baseline
```
Run `--propupd` after clean install or when updating trusted binaries.

## Run a Manual Check
```bash
sudo rkhunter --check --sk
```
- `--sk`: Skip manual keypress (non-interactive mode)
- Output includes warnings (`[Warning]`) or checks passed (`[ OK ]`)

## Automate via Cron (Daily)
```cron
0 3 * * * /usr/bin/rkhunter --check --sk | grep -i warning | mail -s "[rkhunter] $(hostname) Warnings" root
```

## Important Log & Config Paths
- Logs: `/var/log/rkhunter.log`
- Config: `/etc/rkhunter.conf`
  - Use `MAIL-ON-WARNING=“root”` to trigger system mail alerts
  - Enable `ALLOW_SSH_ROOT_USER=no` for stricter checks

## Good Practices
- Run `--propupd` after safe updates (e.g., `apt upgrade`)
- Monitor logs with integrity tools like AIDE
- Whitelist known warnings cautiously with `ALLOW*` rules

## Limitations
- Rootkits running in-memory or at firmware/boot level may evade detection
- Use alongside other tools like AIDE, auditd, and antivirus (e.g. ClamAV)

## References
- [rkhunter source](https://sourceforge.net/projects/rkhunter/)
- [man rkhunter](https://manpages.debian.org/bullseye/rkhunter/rkhunter.8.en.html)

