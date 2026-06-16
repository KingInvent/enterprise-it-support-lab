# Mapped Drive Missing Troubleshooting Runbook

## Overview

This runbook documents the troubleshooting process for a user who cannot see or access the mapped company drive in the BlancoTech Solutions environment.

Mapped drive issues commonly occur because of Group Policy problems, VPN connectivity issues, DNS resolution failures, permissions problems, or the user not being connected to the domain network.

## Scope

This runbook applies to:

- Missing mapped drives
- Shared folder access issues
- Department or company file share access issues
- Group Policy drive mapping problems
- Remote users accessing file shares over VPN
- Windows workstation support tickets

## Related Systems

| System | Purpose |
|---|---|
| Active Directory | User identity and group-based access |
| Group Policy | Deploys mapped drive configuration |
| DNS | Resolves the domain controller hostname |
| Windows Server | Hosts the shared folder |
| SMB file sharing | Provides access to company file shares |
| VPN | Provides remote access to internal resources |
| GLPI | Ticket tracking and documentation |

## Related Lab Evidence

| Evidence | Location |
|---|---|
| Mapped drive GPO screenshot | `screenshots/gpo-mapped-drive-settings.png` |
| GPO linked users OU screenshot | `screenshots/gpo-linked-users-ou.png` |
| Company file share | `\\vm-bt-dc01\Company` |
| Drive letter | `S:` |
| GLPI sample ticket | `Mapped company drive missing` |
| Network test script | `powershell/Test-NetworkConnectivity.ps1` |
| Network test screenshot | `screenshots/powershell-network-test-output.png` |

## Symptoms

User may report:

- Company drive is missing
- `S:` drive does not appear in File Explorer
- Shared folder was available before but disappeared
- User receives access denied when opening the share
- Drive appears with a red X
- Drive appears only after reconnecting to VPN
- User cannot access `\\vm-bt-dc01\Company`

## Initial Questions

Ask the user:

1. Are you onsite or remote?
2. Are you connected to VPN?
3. Did the drive work before?
4. Are you able to access other internal systems?
5. Are you signed in with your domain account?
6. Do you see the drive with a red X, or is it completely missing?
7. What error appears when accessing the share manually?
8. Did the issue start after a password change or reboot?

## Priority

| Condition | Priority |
|---|---|
| Single user, workaround available | Medium |
| Single user blocked from critical files | High |
| Multiple users affected | Critical |
| File server or domain-wide issue | Critical |

## Troubleshooting Steps

## 1. Confirm User and Device Details

Verify:

- User full name
- Username
- Department
- Computer name
- Onsite or remote status
- Whether the user is connected to VPN
- Whether the issue affects only this drive or all internal resources

Example:

```text
User: Maria Gonzalez
Username: mgonzalez
Department: Sales
Issue: Company drive S: is missing
Share: \\vm-bt-dc01\Company
```

## 2. Confirm Network or VPN Connectivity

If the user is remote, confirm VPN is connected.

If VPN is not connected, follow the VPN troubleshooting runbook first.

Ask the user to test basic access to the internal file share:

```text
\\vm-bt-dc01\Company
```

If the share does not open, the issue may be:

- VPN
- DNS
- Network routing
- File share permissions
- Server availability

## 3. Test Manual Share Access

Ask the user to open File Explorer and enter:

```text
\\vm-bt-dc01\Company
```

Results:

| Result | Meaning |
|---|---|
| Share opens successfully | Drive mapping/GPO issue |
| Access denied | Permission issue |
| Network path not found | DNS, VPN, or server connectivity issue |
| Credential prompt appears | Cached credential or authentication issue |

## 4. Confirm DNS Resolution

On the affected workstation or admin system, test hostname resolution:

```powershell
nslookup vm-bt-dc01
```

Expected result should resolve to the domain controller IP:

```text
10.0.0.4
```

If DNS fails, check:

- VPN connection
- DNS server assignment
- Network adapter DNS settings
- Internal DNS availability

## 5. Test Network Connectivity

Use PowerShell to test basic connectivity:

```powershell
Test-Connection vm-bt-dc01 -Count 4
```

Test SMB port access:

```powershell
Test-NetConnection vm-bt-dc01 -Port 445
```

Expected result:

```text
TcpTestSucceeded : True
```

If port 445 fails, the issue may be:

- VPN routing
- Firewall
- SMB access blocked
- Server unavailable

## 6. Use Lab Network Test Script

If deeper validation is needed, run the lab network test script from the domain controller or admin system:

```powershell
cd C:\Lab\enterprise-it-support-lab-main\powershell

.\Test-NetworkConnectivity.ps1 -Target "vm-bt-dc01" -Port 445
```

Review:

| Check | Purpose |
|---|---|
| Local IP | Confirms network adapter details |
| Gateway | Confirms routing |
| DNS servers | Confirms DNS configuration |
| Ping test | Checks basic reachability |
| DNS resolution | Confirms hostname lookup |
| TCP port test | Confirms SMB service access |

## 7. Confirm Group Policy Drive Mapping

The lab maps the company drive through Group Policy.

Configured share:

```text
\\vm-bt-dc01\Company
```

Configured drive letter:

```text
S:
```

Configured GPO:

```text
GPO - Map Company Drive
```

The GPO is linked under:

```text
BlancoTech → Users
```

If the user is in scope of the linked OU, the drive should map during policy refresh or sign-in.

## 8. Force Group Policy Update

On the affected Windows workstation, run:

```powershell
gpupdate /force
```

Then ask the user to sign out and sign back in.

If needed, restart the workstation.

## 9. Check Applied Group Policies

Run:

```powershell
gpresult /r
```

Confirm that the mapped drive GPO appears under applied user policies.

If it does not appear, check:

- User OU location
- GPO link
- Security filtering
- WMI filtering
- User sign-in context
- Domain connectivity

## 10. Manually Map the Drive for Testing

For testing only, manually map the drive:

```powershell
net use S: \\vm-bt-dc01\Company
```

If manual mapping works, the file share and permissions are likely valid. The issue is probably GPO application.

If manual mapping fails, review the returned error.

Common examples:

| Error | Likely Cause |
|---|---|
| Access denied | Permission issue |
| Network path not found | DNS, VPN, or server issue |
| System error 53 | Name resolution or network path problem |
| System error 67 | Incorrect share name |
| Multiple connections error | Conflicting cached credentials |

## 11. Clear Existing Broken Drive Mapping

If the drive appears with a red X or has a stale connection, remove it:

```powershell
net use S: /delete
```

Then force policy update again:

```powershell
gpupdate /force
```

Ask the user to sign out and sign back in.

## 12. Check Cached Credentials

If the user receives credential prompts or access denied errors, check Windows Credential Manager.

Path:

```text
Control Panel → Credential Manager → Windows Credentials
```

Remove stale credentials related to:

```text
vm-bt-dc01
blancotech.local
Company share
mapped drives
```

Then ask the user to reconnect using their current domain credentials.

## 13. Confirm File Share Permissions

On the file server/domain controller, confirm the share exists:

```powershell
Get-SmbShare -Name Company
```

Confirm share path:

```text
C:\Shares\Company
```

Confirm share access:

```powershell
Get-SmbShareAccess -Name Company
```

In the lab, the share was configured with:

```text
Domain Admins: Full Access
Domain Users: Change Access
```

## 14. Confirm NTFS Permissions

Check folder permissions on:

```text
C:\Shares\Company
```

Review whether the user or group has proper NTFS access.

Remember:

```text
Effective access = Share permissions + NTFS permissions
```

If either permission layer blocks access, the user may receive access denied.

## 15. Escalation Criteria

Escalate to Systems Administrator if:

- Multiple users are missing the drive
- GPO is not applying
- DNS resolution fails for multiple users
- SMB port 445 is blocked
- File share is missing or inaccessible
- Permissions appear misconfigured
- Server is unreachable
- Security issue or unauthorized access is suspected

## Resolution Notes Template

Use this format in GLPI:

```text
Verified user identity and confirmed the company mapped drive was missing. Tested manual access to \\vm-bt-dc01\Company and reviewed VPN/network connectivity. Confirmed DNS resolution and SMB connectivity where applicable. Forced Group Policy update and verified mapped drive policy scope. Removed stale mapped drive credentials if needed. User signed out and back in, then confirmed the S: Company Drive was visible and accessible.
```

## GLPI Ticket Example

| Field | Value |
|---|---|
| Type | Incident |
| Category | File Access |
| Priority | Medium |
| Title | Mapped company drive missing |

Ticket description:

```text
User reports the company shared drive is not appearing after login. Reviewed mapped drive Group Policy configuration. Confirmed Company Drive maps to \\vm-bt-dc01\Company using drive letter S:. Documented GPO-based remediation steps.
```

## Prevention

Recommended prevention steps:

- Use Group Policy for consistent drive mapping
- Keep users in the correct OU structure
- Avoid manually mapping conflicting drive letters
- Document file share names and drive letters
- Train users to connect to VPN before accessing internal drives
- Monitor recurring mapped drive issues
- Review GPO scope after OU or department changes

## Skills Demonstrated

This runbook demonstrates:

- Windows mapped drive troubleshooting
- Group Policy validation
- SMB file share support
- DNS and network connectivity testing
- VPN dependency awareness
- Permission troubleshooting
- Help desk ticket documentation
- Escalation decision-making
- User-focused support workflow