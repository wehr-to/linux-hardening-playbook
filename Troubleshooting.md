# This checklist provides a step-by-step approach to investigate crashing or disappearing Linux processes. 
Covers system logs, resource usage, file locks, storage issues, and real-time debugging. 
Ideal for sysadmins and engineers looking to quickly isolate root causes in production or homelab environments.

𝗦𝘁𝗲𝗽 𝟭: 𝗩𝗲𝗿𝗶𝗳𝘆 𝘁𝗵𝗲 𝗼𝗯𝘃𝗶𝗼𝘂𝘀
ps aux | grep process_name → Is it actually dead?
pgrep -fl process_name → Double-check memory
dmesg -T | tail -50 → Look for segfaults or OOM kills

𝗦𝘁𝗲𝗽 𝟮: 𝗛𝘂𝗻𝘁 𝘁𝗵𝗿𝗼𝘂𝗴𝗵 𝘀𝘆𝘀𝘁𝗲𝗺 𝗹𝗼𝗴𝘀
journalctl -xe --no-pager -n 50 → Recent errors before crash
tail -f /var/log/syslog → Live warnings and crash messages

𝗦𝘁𝗲𝗽 𝟯: 𝗖𝗵𝗲𝗰𝗸 𝗿𝗲𝘀𝗼𝘂𝗿𝗰𝗲 𝗰𝗼𝗻𝘀𝘂𝗺𝗽𝘁𝗶𝗼𝗻
top -o %CPU → High CPU usage patterns
top -o %MEM → Memory limit breaches
dmesg | grep -i "oom" → OOM Killer activity

𝗦𝘁𝗲𝗽 𝟰: 𝗜𝗻𝘃𝗲𝘀𝘁𝗶𝗴𝗮𝘁𝗲 𝘀𝘁𝗼𝗿𝗮𝗴𝗲 𝗶𝘀𝘀𝘂𝗲𝘀
df -h → Disk space exhaustion
iostat -xm 1 → I/O bottlenecks causing freezes
dmesg | grep -i "error" → File system corruption

𝗦𝘁𝗲𝗽 𝟱: 𝗙𝗶𝗻𝗱 𝗳𝗶𝗹𝗲 𝗹𝗼𝗰𝗸 𝗶𝘀𝘀𝘂𝗲𝘀
lsof -p <PID> → Stuck on locked files
lsof | grep -iE "deleted|locked" → Lingering file problems

𝗦𝘁𝗲𝗽 𝟲: 𝗧𝗿𝗮𝗰𝗸 𝗲𝘅𝘁𝗲𝗿𝗻𝗮𝗹 𝗸𝗶𝗹𝗹𝘀
journalctl -u process_name --no-pager -n 50 → Manual terminations
lastcomm | grep process_name → Who sent the kill signal

𝗦𝘁𝗲𝗽 𝟳: 𝗥𝗲𝗮𝗹-𝘁𝗶𝗺𝗲 𝗱𝗲𝗯𝘂𝗴𝗴𝗶𝗻𝗴
strace -p <PID> → Live syscall monitoring
gdb -p <PID> → Attach debugger for deep inspection
