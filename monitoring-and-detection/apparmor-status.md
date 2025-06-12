# AppArmor Status

## Purpose
Check current AppArmor enforcement, status, and loaded profiles.

## Commands

```bash
# Check if AppArmor is enabled
sudo aa-status

# List profile modes
sudo apparmor_status

# Count profiles by status
sudo apparmor_status | grep -E 'enforce|complain|unconfined'

# List loaded profiles (sorted)
sudo aa-status | grep -A100 "profiles are loaded" | sort

# Optional: Dump active rules
sudo aa-genprof /usr/bin/YOUR_APP
```

## Output Sample
```
apparmor module is loaded.
40 profiles are loaded.
30 profiles are in enforce mode.
10 profiles are in complain mode.
5 processes have profiles defined.
```

## Recommendation
Ensure most profiles run in **enforce** mode.
Enable AppArmor via kernel boot param `apparmor=1 security=apparmor` if missing.

## Folder
Put in: `monitoring-and-detection/apparmor-status.md`
