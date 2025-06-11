# grub-rollback.md

## Purpose
This guide explains how to safely roll back changes made to GRUB2 configuration — such as password protection, boot parameters, or module restrictions — in case of boot issues or misconfigurations.

## When To Roll Back
- System is unbootable due to invalid GRUB config or boot params
- GRUB password prevents access and no recovery key is available
- You need to remove hardened parameters for troubleshooting

## Rollback Options

### 1. Boot into Recovery or Live Mode
If GRUB fails to load properly:
- Boot with a Live ISO or recovery USB
- Mount your root partition (e.g., `/mnt`)
```bash
sudo mount /dev/sdXn /mnt
sudo mount --bind /dev /mnt/dev && mount --bind /proc /mnt/proc && mount --bind /sys /mnt/sys
chroot /mnt
```

### 2. Restore GRUB Config Files
If you backed up GRUB settings:
```bash
cp /etc/default/grub.bak /etc/default/grub
cp /etc/grub.d/40_custom.bak /etc/grub.d/40_custom
```
Otherwise, copy a known-safe version from your toolkit:
```bash
cp ./references/grub-default.conf /etc/default/grub
cp ./references/grub-custom-default /etc/grub.d/40_custom
```

### 3. Regenerate GRUB Config
```bash
update-grub
```
(For UEFI systems, ensure `/boot/efi` is mounted and available)

### 4. Reboot
```bash
reboot
```
Ensure GRUB loads with default entries, no auth prompts, and correct kernel line.

## Tips
- To disable password temporarily, comment `password_pbkdf2` in `40_custom`
- Always test hardened `grub.cfg` in a VM first
- Avoid typos in kernel params (e.g. `ipv6.disable=1`)

## Key Paths
- `/etc/default/grub`
- `/etc/grub.d/`
- Generated file: `/boot/grub/grub.cfg`

## Related
- See [`grub-hardening.md`](../../kernel-and-services/grub-hardening.md)
- Include `grub.cfg` in [`pre-hardening-backup.sh`](../backup-hooks/)
