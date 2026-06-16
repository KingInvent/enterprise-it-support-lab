# VPN Not Connecting Troubleshooting Runbook

## Overview

This runbook documents the troubleshooting process for a user who cannot connect to VPN in the BlancoTech Solutions environment.

VPN issues commonly occur because of incorrect credentials, expired passwords, missing group membership, unstable internet, DNS issues, client misconfiguration, or remote access policy problems.

## Scope

This runbook applies to:

- Remote users
- VPN connection failures
- Domain resource access issues
- Users who need access to internal systems
- Help desk VPN support tickets

## Related Systems

| System | Purpose |
|---|---|
| Active Directory | User identity and group membership |
| VPN-Users group | Controls VPN access eligibility |
| DNS | Resolves internal resources |
| PowerShell | Connectivity testing and validation |
| GLPI | Ticket tracking and documentation |
| Windows Server | Hosts AD DS, DNS, and domain services |

## Related Lab Evidence

| Evidence | Location |
|---|---|
| VPN security group | `VPN-Users` in Active Directory |
| Group membership report script | `powershell/Get-GroupMembershipReport.ps1` |
| Network test script | `powershell/Test-NetworkConnectivity.ps1` |
| Network test screenshot | `screenshots/powershell-network-test-output.png` |
| GLPI sample ticket | `VPN connection failure - Sales user` |
| AD group screenshot | `screenshots/ad-security-groups.png` |

## Symptoms

User may report:

- VPN client fails to connect
- VPN keeps disconnecting
- VPN accepts password but internal resources do not load
- User cannot access shared drives after VPN connection
- User cannot access internal applications remotely
- VPN worked before but stopped after password change
- VPN fails only from home network or public Wi-Fi

## Initial Questions

Ask the user:

1. Are you connected to the internet?
2. Are other websites loading?
3. Are you working from home, public Wi-Fi, or mobile hotspot?
4. Did VPN work previously?
5. Did you recently change your password?
6. Are you receiving an error message?
7. Are you able to sign in to Microsoft 365 or other company services?
8. Are other remote users affected?

## Priority

| Condition | Priority |
|---|---|
| Single user VPN issue with workaround | Medium |
| Single user blocked from remote work | High |
| Multiple remote users affected | Critical |
| VPN outage affecting business operations | Critical |

## Troubleshooting Steps

## 1. Confirm Basic Internet Access

Ask the user to open several websites.

If the user has no internet access, troubleshoot local connectivity first:

- Wi-Fi connection
- Ethernet connection
- Modem/router status
- Mobile hotspot test
- Restart network adapter
- Restart home router if needed

If internet does not work, the issue is not isolated to VPN.

## 2. Confirm User Identity

Verify:

- Full name
- Username
- Department
- Device name if available
- Whether the user is remote or onsite
- Whether the issue affects only VPN or all sign-ins

Example:

```text
User: Jordan Lee
Username: jlee
Department: Sales
Issue: VPN connection failure while remote
```

## 3. Check Account Status

On the domain controller or an admin workstation with RSAT, check the user account.

```powershell
Get-ADUser jlee -Properties Enabled,LockedOut,PasswordExpired,PasswordLastSet |
Select-Object Name,SamAccountName,Enabled,LockedOut,PasswordExpired,PasswordLastSet
```

Review:

| Field | Meaning |
|---|---|
| Enabled | Confirms account is active |
| LockedOut | Confirms whether login failures locked the account |
| PasswordExpired | Confirms whether password must be changed |
| PasswordLastSet | Helps identify recent password changes |

If the account is locked, follow the account lockout runbook.

## 4. Confirm VPN Group Membership

VPN access should be controlled through group membership.

Check whether the user is a member of `VPN-Users`.

```powershell
Get-ADPrincipalGroupMembership jlee |
Select-Object Name |
Sort-Object Name
```

Expected result should include:

```text
VPN-Users
```

If missing, add the user after approval:

```powershell
Add-ADGroupMember -Identity "VPN-Users" -Members jlee
```

Then ask the user to sign out and try again.

## 5. Validate Group Membership with Lab Script

Use the group membership report script if needed:

```powershell
cd C:\Lab\enterprise-it-support-lab-main\powershell

.\Get-GroupMembershipReport.ps1 -GroupName "VPN-Users"
```

Review the generated report to confirm the user is listed.

## 6. Check for Recent Password Change

If the user recently changed their password, old saved credentials may still be used by:

- VPN client
- Windows Credential Manager
- Outlook
- Teams
- Browser saved passwords
- Mobile email apps

Ask the user to update or clear saved credentials.

On Windows:

```text
Control Panel → Credential Manager → Windows Credentials
```

Remove stale credentials related to:

```text
VPN
blancotech.local
Microsoft 365
internal file shares
```

## 7. Test DNS and Network Connectivity

If VPN connects but internal resources do not load, test DNS and connectivity.

Use the lab network test script:

```powershell
cd C:\Lab\enterprise-it-support-lab-main\powershell

.\Test-NetworkConnectivity.ps1 -Target "blancotech.local" -Port 53
```

Review:

| Check | Purpose |
|---|---|
| Local IP | Confirms network adapter information |
| Gateway | Confirms route to network |
| DNS servers | Confirms DNS configuration |
| Ping test | Checks basic reachability |
| DNS resolution | Confirms name resolution |
| TCP port test | Confirms service connectivity |

## 8. Test Internal Resource Access

After VPN connects, ask the user to test:

- Shared drive
- Internal application
- Intranet site
- Remote desktop resource if applicable
- DNS name resolution

Example internal resource:

```text
\\vm-bt-dc01\Company
```

If the VPN connects but internal resources fail, the issue may be DNS, routing, permissions, or mapped drive policy.

## 9. Restart VPN Client

Ask the user to:

1. Disconnect VPN
2. Close VPN client completely
3. Reopen VPN client
4. Enter current credentials manually
5. Reconnect
6. Test internal access again

Avoid relying on saved credentials during troubleshooting.

## 10. Reboot Device if Needed

If the VPN client appears stuck or cached credentials keep failing:

1. Restart the workstation
2. Confirm internet access
3. Open VPN client
4. Manually enter credentials
5. Test internal resources

## 11. Escalation Criteria

Escalate to Systems Administrator or Network Administrator if:

- Multiple users cannot connect
- VPN gateway appears down
- User is in the correct VPN group but access still fails
- DNS resolution fails after VPN connection
- Internal routes are missing
- VPN client logs show policy or certificate errors
- Security event or suspicious login behavior is suspected

## Resolution Notes Template

Use this format in GLPI:

```text
Verified user identity and confirmed the issue was isolated to VPN access. Checked Active Directory account status and confirmed the user account was enabled and not locked. Reviewed VPN group membership and validated whether the user belonged to VPN-Users. Tested network and DNS connectivity using PowerShell. Cleared stale credentials where needed, had the user reconnect to VPN, and confirmed access to internal resources.
```

## GLPI Ticket Example

| Field | Value |
|---|---|
| Type | Incident |
| Category | Network |
| Priority | High |
| Title | VPN connection failure - Sales user |

Ticket description:

```text
Sales user cannot connect to VPN while working remotely. User needs access to internal company resources. Verified VPN group membership in Active Directory. Confirmed user should be a member of VPN-Users. Documented escalation path for network and VPN troubleshooting.
```

## Prevention

Recommended prevention steps:

- Use group-based VPN access control
- Keep VPN client updated
- Document VPN access requirements
- Train users to update saved credentials after password changes
- Monitor recurring VPN failures
- Escalate repeated failures for network review
- Maintain clear VPN troubleshooting documentation

## Skills Demonstrated

This runbook demonstrates:

- VPN troubleshooting workflow
- Active Directory account validation
- Group membership verification
- PowerShell-based network testing
- DNS troubleshooting
- Remote user support
- Help desk ticket documentation
- Escalation decision-making
- Security-aware access control