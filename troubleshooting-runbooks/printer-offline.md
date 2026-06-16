# Printer Offline Troubleshooting Runbook

## Overview

This runbook documents the troubleshooting process for a printer that appears offline or does not print in the BlancoTech Solutions environment.

Printer issues commonly occur because of network connectivity problems, incorrect default printer settings, print queue errors, driver problems, stale printer mappings, or the printer being physically unavailable.

## Scope

This runbook applies to:

- Printer offline errors
- Print jobs stuck in queue
- Network printer access issues
- Printer driver problems
- User unable to print
- Department printer support tickets
- Windows workstation printer troubleshooting

## Related Systems

| System | Purpose |
|---|---|
| Windows Workstation | User device sending print jobs |
| Network Printer | Printer connected to the office network |
| Print Queue | Stores pending print jobs |
| Printer Driver | Allows Windows to communicate with printer |
| DNS / Networking | Resolves and reaches network printer |
| GLPI | Ticket tracking and documentation |
| PowerShell | Network and printer validation |

## Related Lab Evidence

| Evidence | Location |
|---|---|
| GLPI ticket categories | `screenshots/glpi-ticket-categories.png` |
| Network test script | `powershell/Test-NetworkConnectivity.ps1` |
| Network test screenshot | `screenshots/powershell-network-test-output.png` |
| GLPI setup documentation | `glpi-ticketing/setup.md` |

## Symptoms

User may report:

- Printer shows offline
- Print job is stuck in queue
- Printer does not appear in the printer list
- Printer prints from other computers but not this user’s computer
- Printer prints slowly
- Printer asks for a driver
- User receives access denied or cannot connect to printer
- Printer was working before but stopped after reboot or network change

## Initial Questions

Ask the user:

1. Which printer are you trying to use?
2. Is the issue affecting only you or multiple users?
3. Is the printer powered on?
4. Is there an error message on the printer screen?
5. Are other people able to print to the same printer?
6. Is the printer connected by USB, Ethernet, or Wi-Fi?
7. Did the issue start after a Windows update or password change?
8. Is the print job stuck, or does nothing happen at all?

## Priority

| Condition | Priority |
|---|---|
| Single user cannot print, workaround available | Low / Medium |
| Single user blocked from critical work | Medium |
| Department printer unavailable | High |
| Multiple printers unavailable | Critical |
| Print server or network-wide issue | Critical |

## Troubleshooting Steps

## 1. Confirm Printer and User Details

Verify:

- User full name
- Department
- Computer name
- Printer name
- Printer location
- Connection type
- Whether other users are affected

Example:

```text
User: Priya Shah
Department: Finance
Issue: Finance printer appears offline
Printer: FIN-PRN-01
Connection type: Network printer
```

## 2. Check Physical Printer Status

Ask the user to confirm:

- Printer is powered on
- Printer has paper
- Printer has toner/ink
- No paper jam is present
- Printer screen does not show an error
- Network cable is connected if Ethernet
- Wi-Fi indicator is active if wireless

If the printer has a physical error, resolve that first.

## 3. Confirm Whether the Issue Is User-Specific or Printer-Wide

Ask another nearby user to print to the same printer.

| Result | Meaning |
|---|---|
| Other users can print | User workstation or profile issue |
| No users can print | Printer, network, or print service issue |
| Only one app cannot print | Application-specific issue |
| Only one document fails | Document-specific issue |

## 4. Check Printer Status in Windows

On the affected workstation:

```text
Settings → Bluetooth & devices → Printers & scanners
```

Check whether the printer shows:

- Offline
- Paused
- Error
- Driver unavailable
- Ready

Open the printer queue and look for stuck jobs.

## 5. Clear Stuck Print Jobs

If jobs are stuck in queue:

1. Open printer queue
2. Cancel stuck jobs
3. Pause and resume printing if needed
4. Retry a test page

If the queue does not clear, restart the print spooler.

## 6. Restart Print Spooler

On the affected Windows workstation, open PowerShell as Administrator and run:

```powershell
Restart-Service Spooler
```

Then retry printing.

Alternative command:

```powershell
net stop spooler
net start spooler
```

If the spooler fails to start, escalate to desktop support or systems administrator.

## 7. Confirm Default Printer

Check whether the correct printer is set as default.

Path:

```text
Settings → Bluetooth & devices → Printers & scanners
```

If Windows is managing the default printer automatically, confirm it did not switch to another printer.

Set the correct printer as default if needed.

## 8. Check Printer Network Connectivity

If the printer is network-based, identify the printer IP address.

Test connectivity:

```powershell
Test-Connection <printer-ip-address> -Count 4
```

Example:

```powershell
Test-Connection 10.0.0.50 -Count 4
```

If ping fails, check:

- Printer network connection
- Printer IP address
- Network/VLAN access
- Wi-Fi/Ethernet status
- Firewall or routing issue

## 9. Test Printer Port Access

Many network printers use TCP port 9100.

Run:

```powershell
Test-NetConnection <printer-ip-address> -Port 9100
```

Example:

```powershell
Test-NetConnection 10.0.0.50 -Port 9100
```

Expected result:

```text
TcpTestSucceeded : True
```

If port 9100 fails, the printer may be offline, blocked, or using a different print protocol.

## 10. Use Lab Network Test Script

If deeper validation is needed, use the lab network test script:

```powershell
cd C:\Lab\enterprise-it-support-lab-main\powershell

.\Test-NetworkConnectivity.ps1 -Target "<printer-ip-address>" -Port 9100
```

Review:

| Check | Purpose |
|---|---|
| Local IP | Confirms workstation network details |
| Gateway | Confirms routing |
| DNS servers | Confirms DNS configuration |
| Ping test | Checks reachability |
| DNS resolution | Confirms hostname lookup if using printer name |
| TCP port test | Confirms printer service access |

## 11. Remove and Re-Add Printer

If the printer appears corrupted or stuck:

1. Remove the printer from Windows
2. Restart the workstation
3. Re-add the printer by name or IP address
4. Install the correct driver if prompted
5. Print a test page

Windows path:

```text
Settings → Bluetooth & devices → Printers & scanners
```

## 12. Check Printer Driver

If Windows shows driver unavailable or printing produces errors:

- Confirm printer model
- Install correct manufacturer driver
- Avoid using incorrect generic drivers if features are missing
- Restart spooler after driver installation
- Print test page

Escalate if driver installation requires admin permissions.

## 13. Check for Offline Mode

In the printer queue, confirm these options are not enabled:

```text
Pause Printing
Use Printer Offline
```

If either is enabled, disable it and retry printing.

## 14. Check User Permissions

If the user receives access denied:

- Confirm user has permission to use the printer
- Check printer sharing permissions if using a shared printer
- Confirm the user is connected to the correct network or VPN
- Confirm the printer is not restricted to a specific department group

If permissions are unclear, escalate to systems administrator.

## 15. Confirm Application-Specific Issue

If the user can print a test page but not from one application:

Test printing from:

- Notepad
- Microsoft Word
- PDF reader
- Browser

If only one app fails:

- Restart the application
- Export document to PDF and retry
- Check page size and printer selection
- Reinstall or repair the application if needed

## 16. Escalation Criteria

Escalate to Desktop Support, Systems Administrator, or Network Administrator if:

- Multiple users cannot print
- Printer is unreachable by IP address
- Printer port test fails
- Print spooler repeatedly crashes
- Driver installation fails
- Printer requires firmware or vendor support
- Printer permissions are misconfigured
- Network printing is down across multiple printers

## Resolution Notes Template

Use this format in GLPI:

```text
Verified user and printer details. Confirmed printer power, paper, toner, and physical status. Checked whether the issue affected one user or multiple users. Reviewed Windows printer queue, cleared stuck jobs, and restarted the print spooler. Tested printer network connectivity and printer port access where applicable. Re-added printer or updated driver if needed. User printed a test page successfully and confirmed printing was restored.
```

## GLPI Ticket Example

| Field | Value |
|---|---|
| Type | Incident |
| Category | Printer |
| Priority | Medium |
| Title | Department printer offline |

Ticket description:

```text
User reports the department printer appears offline and print jobs remain stuck in queue. Verified printer power and physical status, checked Windows printer queue, restarted print spooler, tested printer network connectivity, and confirmed successful test print after clearing the queue.
```

## Prevention

Recommended prevention steps:

- Keep printer naming consistent
- Document printer IP addresses and locations
- Use standard printer drivers
- Monitor recurring printer queue failures
- Train users to check basic printer status before opening a ticket
- Keep spare toner and paper available
- Escalate recurring network printer issues for infrastructure review

## Skills Demonstrated

This runbook demonstrates:

- Printer troubleshooting
- Windows print queue support
- Print spooler service management
- Network printer connectivity testing
- PowerShell troubleshooting
- Driver and device support
- Help desk ticket documentation
- User communication
- Escalation decision-making
