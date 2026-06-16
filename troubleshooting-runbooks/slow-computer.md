# Slow Computer Troubleshooting Runbook

## Overview

This runbook documents the troubleshooting process for a Windows computer that is running slowly in the BlancoTech Solutions environment.

Slow computer issues commonly occur because of high CPU or memory usage, low disk space, too many startup apps, pending updates, malware, failing hardware, browser overload, user profile issues, or network-related delays.

## Scope

This runbook applies to:

- Slow Windows workstation performance
- Slow login
- Slow application launch
- High CPU or memory usage
- Low disk space
- Startup delays
- Browser performance issues
- General desktop support tickets

## Related Systems

| System | Purpose |
|---|---|
| Windows Workstation | User endpoint experiencing performance issue |
| Task Manager | Reviews CPU, memory, disk, and startup usage |
| Windows Update | Confirms system patch status |
| Disk Management / Storage | Reviews available disk space |
| Endpoint Security | Checks malware or suspicious activity |
| GLPI | Ticket tracking and documentation |
| PowerShell | System and network validation |

## Related Lab Evidence

| Evidence | Location |
|---|---|
| GLPI ticket categories | `screenshots/glpi-ticket-categories.png` |
| Network test script | `powershell/Test-NetworkConnectivity.ps1` |
| Network test screenshot | `screenshots/powershell-network-test-output.png` |
| PowerShell documentation | `powershell/README.md` |
| GLPI setup documentation | `glpi-ticketing/setup.md` |

## Symptoms

User may report:

- Computer is slow
- Login takes too long
- Applications take a long time to open
- Browser freezes or becomes unresponsive
- System fan is loud
- Computer freezes randomly
- File Explorer is slow
- Teams or Outlook runs poorly
- Computer is slow after startup
- Computer is slow only when connected to VPN

## Initial Questions

Ask the user:

1. When did the slowness start?
2. Is the issue constant or intermittent?
3. Is the whole computer slow or only one application?
4. Did the issue start after an update or software install?
5. Is the device slow during startup, login, or normal use?
6. Are other users affected?
7. Is the user onsite or remote?
8. Is VPN connected when the issue happens?
9. Has the device been restarted recently?

## Priority

| Condition | Priority |
|---|---|
| Minor slowness with workaround | Low |
| Single user productivity affected | Medium |
| User blocked from work | High |
| Multiple users affected | Critical |
| Possible malware or security issue | High / Critical |

## Troubleshooting Steps

## 1. Confirm User and Device Details

Verify:

- User full name
- Department
- Computer name
- Device type
- Windows version if available
- Whether the issue is local, application-specific, or network-related

Example:

```text
User: Alan Chen
Department: IT
Computer: BT-LT-004
Issue: Computer is slow after startup and Outlook freezes
```

## 2. Confirm Recent Restart

Ask the user when the computer was last restarted.

If uptime is high, restart the computer.

Check uptime with PowerShell:

```powershell
(Get-CimInstance Win32_OperatingSystem).LastBootUpTime
```

If the device has not restarted in several days or weeks, reboot first and retest.

## 3. Check Task Manager

Open Task Manager:

```text
Ctrl + Shift + Esc
```

Review:

| Tab | What to Check |
|---|---|
| Processes | High CPU, memory, disk, or network usage |
| Performance | CPU, RAM, disk, and network trends |
| Startup apps | Apps slowing boot/login |
| Users | Whether another user session is consuming resources |

Look for:

- CPU near 90–100%
- Memory near 90–100%
- Disk near 100%
- Unknown or suspicious processes
- Browser using excessive resources
- Teams or Outlook consuming excessive memory

## 4. Identify Resource Bottleneck

Use the table below:

| Bottleneck | Common Cause |
|---|---|
| High CPU | Browser tabs, Teams, updates, malware, heavy app |
| High memory | Too many apps, browser tabs, Teams, Outlook, low RAM |
| High disk | Updates, indexing, antivirus scan, failing drive |
| High network | Sync apps, OneDrive, updates, VPN, large downloads |
| Low storage | Large downloads, temp files, user profile data |

Document which resource is causing the slowness.

## 5. Close Unneeded Applications

Ask the user to close:

- Extra browser tabs
- Unused applications
- Duplicate Teams or Outlook windows
- Large files
- Background apps not needed for work

Then retest system responsiveness.

## 6. Check Startup Apps

Open:

```text
Task Manager → Startup apps
```

Disable unnecessary startup items such as:

- Consumer apps
- Updaters not required at startup
- Messaging apps not used for work
- Vendor utilities not needed daily

Do not disable security tools, VPN clients, management agents, or required company software without approval.

## 7. Check Disk Space

Open:

```text
Settings → System → Storage
```

Or run PowerShell:

```powershell
Get-PSDrive C
```

Review free space.

Recommended minimum:

```text
At least 15–20% free disk space
```

If disk space is low:

- Empty Recycle Bin
- Remove temporary files
- Clear Downloads if approved
- Remove old installers
- Move large files to approved storage
- Use Storage Sense if permitted

## 8. Clean Temporary Files

Run:

```text
Win + R → cleanmgr
```

Or use Windows Storage settings.

Safe cleanup targets:

- Temporary files
- Recycle Bin
- Windows update cleanup
- Downloaded program files
- Temporary internet files

Do not delete user files without confirmation.

## 9. Check Windows Updates

Open:

```text
Settings → Windows Update
```

Check for:

- Pending updates
- Failed updates
- Required restart
- Driver updates
- Update stuck in progress

If updates are pending, install approved updates and restart.

## 10. Check for Malware or Suspicious Activity

If performance drop is sudden or suspicious, check endpoint security.

Warning signs:

- Unknown processes
- Browser redirects
- Pop-ups
- High CPU from unknown executable
- User clicked suspicious link
- Unauthorized software installed
- Unexpected MFA prompts or sign-in alerts

Escalate to security if malware or compromise is suspected.

## 11. Check Browser Performance

If slowness is mostly browser-related:

- Close unused tabs
- Clear cache if needed
- Disable unnecessary extensions
- Test in another browser
- Confirm website-specific issue
- Restart browser
- Check whether issue happens in private/incognito mode

If only one website is slow, troubleshoot the website or network path.

## 12. Check Outlook and Teams

If Outlook or Teams is slow:

- Restart the application
- Check internet connection
- Check mailbox size if Outlook is affected
- Clear Teams cache if needed
- Test Outlook on the web
- Confirm Microsoft 365 service health if multiple users are affected

If Outlook is the primary issue, follow the Outlook mailbox issue runbook.

## 13. Check OneDrive or File Sync

If disk or network usage is high, check OneDrive or file sync tools.

Look for:

- Large sync backlog
- Sync errors
- Files stuck uploading
- User syncing very large folders
- Network slowdown from active sync

Pause sync temporarily for testing if allowed.

## 14. Check Network-Related Slowness

If the computer is slow only when accessing internal resources, test network connectivity.

Use PowerShell:

```powershell
Test-Connection 8.8.8.8 -Count 4
```

Test internal domain connectivity if applicable:

```powershell
Test-Connection vm-bt-dc01 -Count 4
```

If using the lab script:

```powershell
cd C:\Lab\enterprise-it-support-lab-main\powershell

.\Test-NetworkConnectivity.ps1 -Target "blancotech.local" -Port 53
```

If the computer itself is responsive but internal resources are slow, troubleshoot DNS, VPN, or mapped drives.

## 15. Check Device Health

If performance remains poor, check for hardware signs:

- Failing drive
- Low RAM
- Overheating
- Battery or power mode issues
- Old device model
- Loud fan
- Random shutdowns
- Blue screen events

Review Event Viewer if needed.

Path:

```text
Event Viewer → Windows Logs → System
```

Look for disk, driver, or hardware errors.

## 16. Check Power Mode

On laptops, confirm the device is not using a low-power mode.

Path:

```text
Settings → System → Power & battery
```

Check:

- Battery saver
- Power mode
- Docking station power
- Charger connected
- Performance mode if approved

## 17. Create a New User Profile if Needed

If slowness affects only one user profile and not the whole device, test with another profile.

If another user profile works normally, the issue may involve:

- Corrupt user profile
- Large profile data
- Bad startup items
- Cached application data
- User-specific application settings

Escalate before recreating or migrating a user profile.

## 18. Escalation Criteria

Escalate to Desktop Support, Systems Administrator, or Security if:

- Device remains slow after basic troubleshooting
- Hardware failure is suspected
- Malware or compromise is suspected
- Disk errors appear in Event Viewer
- Multiple users report the same issue
- Windows updates repeatedly fail
- User profile corruption is suspected
- Device needs reimage, replacement, or warranty support

## Resolution Notes Template

Use this format in GLPI:

```text
Verified user and device details and confirmed the reported performance issue. Reviewed uptime, Task Manager resource usage, startup applications, disk space, Windows updates, and application-specific behavior. Cleared unnecessary startup items and temporary files where appropriate, restarted the device, and retested performance. User confirmed system responsiveness improved. Documented findings and escalation path if issue returns.
```

## GLPI Ticket Example

| Field | Value |
|---|---|
| Type | Incident |
| Category | Hardware |
| Priority | Medium |
| Title | Slow computer performance |

Ticket description:

```text
User reports workstation is slow after startup and applications take several minutes to open. Checked uptime, Task Manager resource usage, startup applications, disk space, and pending Windows updates. Removed unnecessary startup items, cleared temporary files, restarted workstation, and confirmed performance improvement with user.
```

## Prevention

Recommended prevention steps:

- Restart devices regularly
- Keep Windows updates current
- Maintain at least 15–20% free disk space
- Limit unnecessary startup apps
- Keep browser tabs and extensions under control
- Monitor recurring performance issues
- Replace aging hardware when performance no longer meets business needs
- Escalate suspicious activity quickly

## Skills Demonstrated

This runbook demonstrates:

- Windows performance troubleshooting
- Task Manager analysis
- Disk space and startup app review
- Windows Update support
- Basic malware awareness
- Network dependency troubleshooting
- User profile troubleshooting awareness
- Help desk ticket documentation
- Escalation decision-making
