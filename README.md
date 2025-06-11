# 🛡️ linux-hardening-toolkit

This repository contains hardened configurations, scripts, and templates designed to reduce risk in Linux environments — whether cloud-based, on-prem, or homelab. It follows CIS Benchmarks, NIST principles, and real-world blue team experience.

## 🧠 Why This Exists

Most attacks exploit **defaults**, not zero-days.

This repo exists to:
- Lock down unnecessary services
- Harden SSH and user access
- Improve log collection and auditing
- Enforce secure file and kernel-level configs
- Detect anomalies with integrity and rootkit tools

## 📦 What's Included

| Folder | Description |
|--------|-------------|
| `baseline-hardening/` | Disables root SSH, sets banners, audits users |
| `cis-compliance/` | CIS-aligned checklists and OS-specific notes |
| `logging-and-auditing/` | auditd, rsyslog, journald, logrotate best practices |
| `kernel-and-services/` | sysctl.conf settings, module lockdown, grub hardening |
| `file-permissions/` | World-writable scan, SUID/SGID tracking |
| `monitoring-and-detection/` | Tools like Tripwire, AIDE, Rootkit Hunter |
| `scripts/` | All-in-one automation and one-off utilities |
| `docs/` | Glossary, hardening rationale, and threat model mapping |

## ⚠️ Disclaimer: No Live Audit Results Included
This repository does not contain any real audit data, production system results, or sensitive configurations.

All content here is:
🔹 Educational and template-based
🔹 Designed to help users learn CIS hardening and practice auditing
🔹 Based on public benchmarks (e.g., CIS Debian 11, MITRE ATT&CK)

⚠️ Use this framework to build your own compliance tooling, audits, or lab exercises. Do not assume this reflects the security posture of any real infrastructure.

## 🔧 Example Script: SSH Lockdown

```bash
#!/bin/bash
# sshd-lockdown.sh
sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd

