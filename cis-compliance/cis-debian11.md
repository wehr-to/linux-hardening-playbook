| Section  | Description                                                     | 
| -------- | --------------------------------------------------------------- | 
| **1.1**  | Ensure mounting with `nodev`, `nosuid`, `noexec` where needed   | 
| **1.2**  | Disable unused filesystems (e.g., cramfs, squashfs)             | 
| **2.1**  | Disable unnecessary services (`avahi`, `cups`, `rpcbind`, etc.) | 
| **3.2**  | Ensure IP forwarding is disabled unless needed                  | 
| **3.3**  | Configure `/etc/sysctl.conf` for ICMP, spoofing protections     | 
| **4.1**  | Enable and configure `rsyslog` or `journald` logging            | 
| **4.2**  | Restrict log file permissions to `0600`                         | 
| **5.1**  | Restrict `cron`, `at`, `/etc/sudoers`, `/etc/hosts.allow`       | 
| **6.2**  | Lock inactive user accounts (30–35 days)                        | 
| **6.3**  | Disable root SSH login (`PermitRootLogin no`)                   | 
| **6.4**  | Set strong password policies (`pam_pwquality.so`)               | 
| **6.5**  | Ensure users have valid shells, locked if not needed            | 
| **7.1**  | SSH hardening: protocol, ciphers, MACs, banners                 | 
| **8.1**  | User account auditing: `UID 0`, empty passwords, etc.           |
| **9.1**  | Enable `auditd`, configure logging rules                        | 
| **10.1** | Set legal banners (`/etc/issue`, `/etc/motd`)                   | 

| Topic          | Debian-Specific Behavior                                       |
| -------------- | -------------------------------------------------------------- |
| **Systemd**    | Manages all services; use `systemctl`                          |
| **AppArmor**   | Installed by default; consider enabling/enforcing profiles     |
| **rsyslog**    | Installed by default; configure `/etc/rsyslog.d/*.conf`        |
| **auditd**     | Needs to be installed manually: `apt install auditd`           |
| **cron/at**    | `atd` is disabled by default; configure `cron.allow/deny`      |
| **Networking** | IPv6 enabled by default; disable if unused in `/etc/sysctl.d/` |
| **SSH Config** | Located at `/etc/ssh/sshd_config`                              |
| **User UIDs**  | Local users start from UID 1000 in `/etc/login.defs`           |
