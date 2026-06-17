# Sample Ticket 03: VPN Connection Failure

## Ticket Summary

| Field | Value |
|---|---|
| Ticket ID | INC-003 |
| Type | Incident |
| Category | Network |
| Priority | High |
| Status | Resolved |
| User | Sales User |
| Department | Sales |
| System | VPN / Active Directory |
| Related Runbook | `troubleshooting-runbooks/vpn-not-connecting.md` |
| Related Script | `powershell/Test-NetworkConnectivity.ps1` |
| Related Group | `VPN-Users` |

## Issue Description

A Sales department user reported that they could not connect to the company VPN while working remotely. The user needed VPN access to reach internal company resources, including shared files and domain-based systems.

The issue prevented the user from accessing internal resources required for remote work.

## Business Impact

The user was unable to work remotely because internal resources were unavailable without VPN access.

Impact:

- VPN connection unavailable
- Internal resources inaccessible
- Shared drive access unavailable
- Remote productivity blocked for one user

## Initial Triage

The following information was collected:

| Question | Answer |
|---|---|
| Is the user remote? | Yes |
| Does the user have internet access? | Yes |
| Is the issue affecting multiple users? | No |
| Did VPN work previously? | Yes |
| Is the user in the VPN access group? | Needs validation |
| Are internal resources accessible without VPN? | No |

## Troubleshooting Steps

## 1. Verified User Identity

Confirmed the affected user:

```text
Department: Sales
Issue: Cannot connect to VPN while remote
Required access: Internal company resources
```

## 2. Confirmed Internet Connectivity

The user confirmed that general internet access was working.

Validated that the issue was specific to VPN access, not a full network outage.

## 3. Checked Active Directory Account Status

The user account was reviewed to confirm it was enabled and not locked.

Example PowerShell check:

```powershell
Get-ADUser jlee -Properties Enabled,LockedOut,PasswordExpired,PasswordLastSet |
Select-Object Name,SamAccountName,Enabled,LockedOut,PasswordExpired,PasswordLastSet
```

## 4. Verified VPN Group Membership

VPN access is controlled through the `VPN-Users` Active Directory security group.

Example command:

```powershell
Get-ADPrincipalGroupMembership jlee |
Select-Object Name |
Sort-Object Name
```

Expected group:

```text
VPN-Users
```

If the user is missing from the group, access should be added only after approval.

Example command:

```powershell
Add-ADGroupMember -Identity "VPN-Users" -Members jlee
```

## 5. Validated Group Membership Report

The group membership report script can be used to confirm VPN access membership.

Script used:

```text
powershell/Get-GroupMembershipReport.ps1
```

Example command:

```powershell
cd C:\Lab\enterprise-it-support-lab-main\powershell

.\Get-GroupMembershipReport.ps1 -GroupName "VPN-Users"
```

## 6. Checked for Saved Credential Issues

The user was asked whether they recently changed their password.

Possible stale credential locations:

- VPN client
- Windows Credential Manager
- Outlook
- Teams
- Browser saved passwords
- Mobile email app

The user was advised to manually re-enter current credentials instead of relying on saved VPN credentials.

## 7. Tested Network and DNS Connectivity

If VPN connects but internal resources remain unavailable, use the network test script.

Script used:

```text
powershell/Test-NetworkConnectivity.ps1
```

Example command:

```powershell
cd C:\Lab\enterprise-it-support-lab-main\powershell

.\Test-NetworkConnectivity.ps1 -Target "blancotech.local" -Port 53
```

This validates:

- Local IP information
- Gateway
- DNS servers
- Ping connectivity
- DNS resolution
- TCP port connectivity

## 8. Tested Internal Resource Access

After VPN access was restored, the user tested access to the company shared drive:

```text
\\vm-bt-dc01\Company
```

The user confirmed internal resource access was restored.

## Resolution

The VPN issue was investigated by confirming the user’s internet access, account status, VPN group membership, and internal network connectivity.

The user’s VPN eligibility was validated through Active Directory group membership, and internal access was tested after connection.

## Resolution Notes

```text
Verified user identity and confirmed the issue was isolated to VPN access. Confirmed the user had working internet access and reviewed Active Directory account status. Validated VPN group membership through the VPN-Users security group. Reviewed possible stale credential issues and had the user reconnect with current credentials. Tested internal resource access after VPN connection and confirmed access to company resources was restored.
```

## Root Cause

Likely VPN authentication or access validation issue related to group membership, cached credentials, or remote connection state.

## Preventive Action

Recommended actions:

- Use the `VPN-Users` group for controlled VPN access
- Document VPN access requirements during onboarding
- Train users to update saved credentials after password changes
- Monitor recurring VPN connection failures
- Escalate repeated VPN failures for network review
- Confirm VPN access during new hire setup for remote users

## Related Evidence

| Evidence | Location |
|---|---|
| VPN troubleshooting runbook | `troubleshooting-runbooks/vpn-not-connecting.md` |
| Group membership script | `powershell/Get-GroupMembershipReport.ps1` |
| Network test script | `powershell/Test-NetworkConnectivity.ps1` |
| Network validation screenshot | `screenshots/powershell-network-test-output.png` |
| AD security groups screenshot | `screenshots/ad-security-groups.png` |
| GLPI sample tickets screenshot | `screenshots/glpi-sample-tickets.png` |

## Skills Demonstrated

This ticket demonstrates:

- VPN troubleshooting
- Remote user support
- Active Directory group membership validation
- PowerShell-based support workflow
- Network and DNS connectivity testing
- Help desk ticket documentation
- Escalation awareness
- User communication and follow-up