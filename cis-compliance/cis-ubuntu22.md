| Section | Description                                                     | 
| ------- | --------------------------------------------------------------- | 
| **1.1** | Ensure mounting with `nodev`, `nosuid`, `noexec` where needed   | 
| **1.2** | Disable unused filesystems (e.g., cramfs, squashfs, udf)        | 
| **1.3** | Enable filesystem integrity tool (AIDE)                         | 
| **1.4** | Restrict GRUB bootloader config permissions                     | 
| **1.5** | Enable UEFI Secure Boot (if available)                          |
| **2.1** | Disable unnecessary services (`avahi`, `cups`, `rpcbind`, etc.) | 
| **2.2** | Configure time sync securely (`chrony` or `systemd-timesyncd`)  | 
| **2.3** | Ensure AppArmor is enabled and in enforce mode                  | 
| **2.4** | Mask unused kernel modules (`dccp`, `sctp`, etc.)               | 
| **3.1** | Disable IP forwarding                                           | 
| **3.2** | Disable ICMP redirects                                          | 
| **3.3** | Enable reverse path filtering (`rp_filter`)                     | 
| **3.4** | Harden `/etc/sysctl.conf` and `/etc/sysctl.d/` settings         | 
| **3.5** | Disable IPv6 (if not required)                                  | 
| **4.1** | Enable and configure `rsyslog` or `journald`                    | 
| **4.2** | Restrict log file permissions to `0600`                         | 
| **4.3** | Install and enable `auditd`                                     | 
| **4.4** | Configure audit rules (auth, sudo, passwd, file changes)        | 
| **5.1** | Set secure `umask` (e.g., `027`)                                | 
| **5.2** | Lock inactive accounts after 30–35 days                         | 
| **5.3** | Enforce password aging and complexity (`pam_pwquality`)         | 
| **5.4** | Remove/lock unused local user accounts                          | 
| **5.5** | Restrict `cron` and `at` to authorized users only               | 
| **6.1** | Set `PermitRootLogin no` in SSH                                 | 
| **6.2** | Set SSH Protocol to 2 only                                      | 
| **6.3** | Disable weak SSH ciphers and MACs                               | 
| **6.4** | Set SSH login banner (`/etc/issue.net`)                         | 
| **6.5** | Limit SSH access with `AllowUsers` or `AllowGroups`             | 
| **6.6** | Set `LoginGraceTime`, `MaxAuthTries` in SSH                     | 
| **7.1** | Audit users with UID 0                                          | 
| **7.2** | List users with shell access                                    | 
| **7.3** | Detect users with empty passwords                               | 
| **7.4** | List `sudo`/`wheel` group members                               | 
| **7.5** | Review `lastlog`, inactive accounts                             | 
| **8.1** | Enable automatic security updates (`unattended-upgrades`)       | 
| **8.2** | Restrict access to compilers (e.g., `gcc`)                      | 
| **8.3** | Remove unnecessary packages (e.g., `nmap`, `telnet`)            | 
| **8.4** | Maintain backups of critical configuration files                | 

| Topic                     | Ubuntu-Specific Behavior                                                                 |
| ------------------------- | ---------------------------------------------------------------------------------------- |
| **Init System**           | Uses `systemd` exclusively; all services and targets managed via `systemctl`             |
| **Firewall**              | `ufw` (Uncomplicated Firewall) is the default frontend; can use `iptables` or `nftables` |
| **AppArmor**              | Enabled and loaded by default; profiles stored in `/etc/apparmor.d/`                     |
| **Filesystem Integrity**  | `aide` must be installed manually (`apt install aide`); not configured by default        |
| **SSH Config**            | `/etc/ssh/sshd_config` used; `openssh-server` often preinstalled on servers              |
| **User UIDs**             | Local users start at UID **1000** (controlled via `/etc/login.defs`)                     |
| **Time Sync**             | `systemd-timesyncd` active by default; can use `chrony` or `ntp` manually                |
| **IPv6**                  | Enabled by default; must be explicitly disabled via sysctl and GRUB                      |
| **Secure Boot**           | Enabled on most cloud/VPS platforms with UEFI; enforced kernel modules signing           |
| **Sudo Defaults**         | Root disabled by default; first user is auto-added to `sudo` group                       |
| **Automatic Updates**     | Supported via `unattended-upgrades`; install + configure manually                        |
| **Audit Logging**         | `auditd` not installed by default; requires `apt install auditd`                         |
| **Compiler Restrictions** | Not applied by default; compilers (`gcc`, `make`) often present even on production       |
| **Default Shells**        | `/bin/bash` or `/bin/sh` default; non-login shells like `/usr/sbin/nologin` available    |
| **Snap Packages**         | Snapd installed/enabled by default; not covered by apt-level package audits              |

