# sudoers-domain-access.md

## Purpose
Securely control which Active Directory (AD) domain users and groups are allowed to perform privileged (sudo) actions on Linux systems.

## Best Practice: Group-Based Sudo Access
Use AD groups to assign privilege, not individuals.

## 1. Define Sudoers File
Create a custom sudoers entry:
```bash
sudo visudo -f /etc/sudoers.d/domain-admins
```

Example rule:
```bash
%domain\\\\ITAdmins ALL=(ALL) ALL
```

Explanation:
- `%` — means group
- `domain\\ITAdmins` — escaping the AD group name properly

> Use **four backslashes** `\\\\` if using `realm join` with `sssd`

## 2. Confirm AD Group Mapping
```bash
id aduser
```
Should show:
```
uid=12345(aduser) gid=12345(domain users) groups=12345(domain users),67890(ITAdmins)
```

## 3. Use Fully Qualified or Short Names
If `sssd.conf` has:
```ini
use_fully_qualified_names = False
```
Then the group should be written as:
```bash
%ITAdmins ALL=(ALL) ALL
```

## 4. Test Access
```bash
ssh aduser@host
sudo whoami
```
Output:
```
root
```

## Restrict to Read-Only or Specific Commands (optional)
```bash
%ITAuditors ALL=(ALL) NOPASSWD: /usr/bin/journalctl, /usr/bin/less
```

## Rotate Access via AD
Adding/removing users from AD groups updates sudo privileges without touching Linux config.

## Validate
```bash
sudo visudo -c
```


