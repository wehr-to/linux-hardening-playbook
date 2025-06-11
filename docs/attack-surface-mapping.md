## Each attack vector includes:
- MITRE ATT&CK Technique ID
- Relevant CIS Control
- Mitigation Recommendations

## 1. User & Authentication
| Vector             | MITRE Tactic/Technique       | Risk Summary                                     | CIS Control | 
| ------------------ | ---------------------------- | ------------------------------------------------ | ----------- | 
| Root account login | T1078.003 (Valid Accounts)   | Full privilege access; default creds often known | 6.3, 5.4    | 
| SSH password auth  | T1110 (Brute Force)          | Password guessing risk over exposed SSH ports    | 6.4, 6.5    | 
| Empty passwords    | T1110                        | Auth bypass risk                                 | 5.3         | 
| Unused users       | T1078.003                    | Privilege abuse from stale accounts              | 5.4, 7.5    | 
| Sudo misconfig     | T1548.003 (Sudo and Sudoers) | Unauthorized privilege escalation                | 5.5         | 
| Inactive accounts  | T1087                        | Privilege exposure if not locked                 | 5.2         | 


## 2. Remote Access & Services
| Vector             | MITRE Tactic/Technique           | Risk Summary                        | CIS Control | 
| ------------------ | -------------------------------- | ----------------------------------- | ----------- | 
| SSH root login     | T1021.004                        | Direct full-access entry            | 6.3, 6.4    |
| Open service ports | T1046 (Network Service Scanning) | Unused ports allow recon/exploit    | 2.1         | 
| Legacy protocols   | T1040 (Network Sniffing)         | Insecure FTP, telnet may leak creds | 3.5         | 
| Avahi/Bonjour      | T1046                            | Auto-discovery risk in local net    | 2.1         | 
| RPC, NFS           | T1021.006                        | Legacy RCE paths if exposed         | 2.1         | 

## 3. Filesystem & Kernel
| Vector              | MITRE Tactic/Technique  | Risk Summary                               | CIS Control | 
| ------------------- | ----------------------- | ------------------------------------------ | ----------- | 
| World-writable dirs | T1006                   | Privilege escalation via malicious scripts | 1.1         | 
| /tmp misconfig      | T1547.009               | Used for dropping/executing payloads       | 1.1         | 
| Kernel modules      | T1547.006 (Kernel Mods) | Unrestricted loading of malicious modules  | 1.2, 2.4    | 
| Bootloader config   | T1542.001               | Local escalation during boot               | 1.4         | 

## 4. Networking Stack
| Vector                 | MITRE Tactic/Technique | Risk Summary                             | CIS Control | 
| ---------------------- | ---------------------- | ---------------------------------------- | ----------- | 
| IP forwarding          | T1090                  | Can allow pivoting between network zones | 3.2         | 
| ICMP redirects         | T1040                  | Enable MITM/routing attacks              | 3.3         | 
| IPv6 (unused)          | T1021.001              | Attack surface if not monitored          | 3.5         | 
| Insecure sysctl params | T1562.004              | Weakens L3/transport protections         | 3.4         | 

## 5. Logging & Monitoring
| Vector                | MITRE Tactic/Technique | Risk Summary                         | CIS Control | 
| --------------------- | ---------------------- | ------------------------------------ | ----------- | 
| auditd not enabled    | T1562.002              | No record of privilege usage or exec | 4.3         | 
| Log tampering allowed | T1070.001              | Can erase tracks of compromise       | 4.2         | 
| Insufficient sudo log | T1055                  | Priv esc may not be captured in logs | 4.4         | 

## 6. Software & Packages
| Vector              | MITRE Tactic/Technique | Risk Summary                               | CIS Control | 
| ------------------- | ---------------------- | ------------------------------------------ | ----------- | 
| Unused packages     | T1070.004              | May contain exploits, increase patch scope | 8.3         | 
| Auto updates off    | T1505.003              | Vulnerable code remains unpatched          | 8.1         | 
| Compilers available | T1059.004              | Enables local code execution & persistence | 8.2         | 
| Snap packages       | T1546.007              | Separate update system, often unchecked    | 8.3         | 

## Summary: Prioritized Attack Surface Areas
| Priority  | Focus Area          | Justification                                 |
| --------- | ------------------- | --------------------------------------------- |
| 🔴 High   | Root/sudo abuse     | Enables full takeover                         |
| 🔴 High   | Remote access (SSH) | Main ingress for external attackers           |
| 🟡 Medium | Package/Compiler    | Supports execution/persistence in escalation  |
| 🟡 Medium | Logging gaps        | Prevents detection and forensic investigation |
| 🟢 Low    | IPv6 / Avahi        | Relevant if not disabled, but low-frequency   |

## Frameworks Mapped
| Framework      | Mapped In This Doc? | Notes                                        |
| -------------- | ------------------- | -------------------------------------------- |
| MITRE ATT\&CK  | ✅                   | Lateral movement, persistence, escalation    |
| CIS Benchmarks | ✅                   | Controls referenced by section               |
| NIST 800-53    | ⚠️ Partial          | Use CIS-to-NIST mapping for crosswalk        |
| ISO 27001      | ⚠️ Partial          | Most relevant to access control & monitoring |

