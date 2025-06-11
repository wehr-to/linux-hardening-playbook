# SUID & SGID Tracking

## Purpose

This document outlines the rationale, use case, and best practices for tracking files with SUID and SGID bits set in a Linux environment.

SetUID (SUID) and SetGID (SGID) permissions allow executables to run with the privileges of the file owner or group, rather than the user who runs them. These bits are commonly abused in privilege escalation attacks.

## Why Track SUID/SGID Files?

- **Privilege Escalation Risk:** Attackers can exploit misconfigured SUID/SGID binaries to gain root access.
- **Audit Requirement:** Security frameworks like CIS Benchmarks and NIST require regular reviews of these permissions.
- **Change Detection:** Monitoring unexpected changes or additions helps detect compromise or misconfigurations.

## What To Look For

- **Unexpected Locations:** SUID/SGID files outside standard paths (`/bin`, `/sbin`, `/usr/bin`, etc.)
- **Recently Modified:** New or recently changed binaries with SUID/SGID
- **Unusual Ownership:** Files owned by non-root users or groups

## How To Track

1. **Initial Baseline:**
   ```bash
   find / -xdev -type f \( -perm -4000 -o -perm -2000 \) -exec ls -l {} + > suid_sgid_baseline.txt
   ```

2. **Ongoing Monitoring:**
   Compare current results against the baseline:
   ```bash
   diff suid_sgid_baseline.txt <(find / -xdev -type f \( -perm -4000 -o -perm -2000 \) -exec ls -l {} +)
   ```

3. **Logging:**
   Output should be logged and version-controlled (e.g., Git) if used in a hardened system.

4. **Optional Tools:**
   - `aide`, `tripwire` for filesystem integrity
   - `auditd` rules to alert on chmod/chown on critical paths

## Remediation Tips

- Use `chmod -s` to remove SUID/SGID from untrusted binaries
- Prefer `sudo` over SUID for privileged scripts/tools
- Create alerts for additions of new SUID/SGID files




