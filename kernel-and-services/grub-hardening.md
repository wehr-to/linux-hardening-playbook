# GRUB Hardening Guide

## Purpose
This guide outlines how to harden the GRUB bootloader to prevent unauthorized modification of boot parameters and unauthorized access to single-user mode.

GRUB (GRand Unified Bootloader) is the first component loaded after BIOS/UEFI. Improperly secured, it can be a vector for privilege escalation or unauthorized kernel tampering.

## Why Harden GRUB?
- **Prevent Kernel Parameter Bypass:** Attackers can disable security features like SELinux or AppArmor.
- **Block Single-User Mode Escalation:** Booting to runlevel 1 (single user) often allows root shell access.
- **Ensure Boot Integrity:** Tampering with GRUB may bypass full disk encryption or integrity tools.

## Steps to Harden GRUB (GRUB2)

### 1. Set GRUB Boot Password
Create a hashed password:
```bash
grub-mkpasswd-pbkdf2
```
Add the output to `/etc/grub.d/40_custom`:
```bash
set superusers="admin"
password_pbkdf2 admin <paste hashed password here>
```

### 2. Restrict Editing Boot Entries
- Once a superuser is set in `40_custom`, GRUB will prompt for password when editing or accessing recovery mode.

### 3. Update GRUB Config
```bash
update-grub
```

### 4. Protect GRUB Files
```bash
chown root:root /etc/grub.d/* /etc/default/grub /boot/grub/grub.cfg
chmod 600 /boot/grub/grub.cfg
```

### 5. UEFI Systems (Optional)
Secure UEFI variables and boot order:
```bash
chattr +i /boot/efi/EFI/BOOT/BOOTX64.EFI
```
Ensure secure boot is enforced in UEFI firmware.

## Notes
- Test GRUB password changes on a virtual machine before rolling out.
- Always maintain console/serial access to recover in case of misconfiguration.
- GRUB password does **not** prevent boot; it prevents editing and recovery boot without auth.

## Related
- [CIS Benchmark for Debian/RHEL: Bootloader Configuration](https://www.cisecurity.org/)
- See `kernel-and-services/disable-uncommon-modules.sh` for securing kernel module access

