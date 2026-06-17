# Sample Ticket 05: Employee Offboarding

## Ticket Summary

| Field | Value |
|---|---|
| Ticket ID | REQ-005 |
| Type | Request |
| Category | Offboarding |
| Priority | High |
| Status | Resolved |
| User | Carlos Mendez |
| Department | Sales |
| System | Active Directory |
| Related Runbook | `troubleshooting-runbooks/account-locked-out.md` |
| Related Script | `powershell/Disable-OffboardedUser.ps1` |
| Related OU | `BlancoTech/Disabled Users` |

## Issue Description

Carlos Mendez from the Sales department required offboarding after separation from the company.

The request required disabling the user account, removing access from security groups, clearing the manager field, updating the account description with a ticket reference, and moving the account to the Disabled Users OU.

## Business Impact

The offboarding request was security-sensitive because the user no longer required access to company systems.

Impact:

- User access needed to be removed
- VPN access needed to be revoked
- Sales group access needed to be removed
- Account needed to be preserved for audit purposes
- Offboarding needed to be documented in GLPI

## Initial Triage

The following information was collected:

| Question | Answer |
|---|---|
| Is this an offboarding request? | Yes |
| User account | `cmendez` |
| Department | Sales |
| Should account be deleted? | No |
| Should account be disabled? | Yes |
| Should groups be removed? | Yes |
| Should account be moved to Disabled Users OU? | Yes |
| Is this security-sensitive? | Yes |

## Troubleshooting / Fulfillment Steps

## 1. Verified Offboarding Request

Confirmed the affected user:

```text
Name: Carlos Mendez
Username: cmendez
Department: Sales
Action: Disable account and remove access
```

## 2. Confirmed Account Existed in Active Directory

The user account was reviewed in Active Directory before offboarding.

Example PowerShell check:

```powershell
Get-ADUser cmendez -Properties Enabled,Department,Title,Manager,Description |
Select-Object Name,SamAccountName,Enabled,Department,Title,Manager,Description
```

## 3. Reviewed Current Group Membership

The account’s current group membership was reviewed before removing access.

Example command:

```powershell
Get-ADPrincipalGroupMembership cmendez |
Select-Object Name |
Sort-Object Name
```

Expected pre-offboarding access included:

```text
All-Employees
Sales-Users
VPN-Users
Domain Users
```

## 4. Ran Offboarding PowerShell Script

The offboarding script was used to standardize the process.

Script used:

```text
powershell/Disable-OffboardedUser.ps1
```

Example command:

```powershell
cd C:\Lab\enterprise-it-support-lab-main\powershell

.\Disable-OffboardedUser.ps1 -Username "cmendez" -TicketNumber "REQ-005" -Reason "Employee offboarding"
```

The script performs the following actions:

- Disables the Active Directory account
- Removes group memberships except `Domain Users`
- Clears the manager field
- Updates the account description with ticket details
- Moves the account to the Disabled Users OU
- Logs the action to `C:\Logs\OffboardingLog.txt`

## 5. Validated Account Was Disabled

After running the script, the account status was checked.

Example command:

```powershell
Get-ADUser cmendez -Properties Enabled,DistinguishedName,Description |
Select-Object Name,SamAccountName,Enabled,DistinguishedName,Description
```

Expected result:

```text
Enabled: False
OU: Disabled Users
Description includes offboarding ticket reference
```

## 6. Validated Group Access Was Removed

The account’s group membership was checked again.

Example command:

```powershell
Get-ADPrincipalGroupMembership cmendez |
Select-Object Name |
Sort-Object Name
```

Expected remaining group:

```text
Domain Users
```

Removed groups:

```text
All-Employees
Sales-Users
VPN-Users
```

## 7. Confirmed Manager Field Was Cleared

The account was reviewed to confirm that manager information was removed.

Example command:

```powershell
Get-ADUser cmendez -Properties Manager |
Select-Object Name,SamAccountName,Manager
```

Expected result:

```text
Manager: blank
```

## 8. Confirmed Account Was Moved to Disabled Users OU

The distinguished name was reviewed to confirm the account was moved.

Expected OU:

```text
OU=Disabled Users,OU=BlancoTech,DC=blancotech,DC=local
```

## 9. Documented Completion in GLPI

The ticket was updated with offboarding actions completed.

Documentation included:

- Account disabled
- Group memberships removed
- VPN access removed
- Manager field cleared
- Account moved to Disabled Users OU
- Ticket reference added to account description
- PowerShell script used for standardized execution

## Resolution

The employee offboarding request was completed using the PowerShell offboarding script.

The account was disabled, access groups were removed, manager information was cleared, the account was moved to the Disabled Users OU, and the action was documented for audit purposes.

## Resolution Notes

```text
Completed employee offboarding for Carlos Mendez. Verified the Active Directory account and reviewed current group memberships. Ran the PowerShell offboarding script to disable the account, remove access groups, clear the manager field, update the account description with ticket reference REQ-005, and move the account to the Disabled Users OU. Confirmed the account was disabled and only Domain Users remained. Documented completion in GLPI.
```

## Root Cause

Standard employee separation/offboarding request.

## Preventive Action

Recommended actions:

- Use a standardized offboarding checklist
- Disable accounts instead of deleting them immediately
- Remove VPN and department access during offboarding
- Preserve account records for audit and investigation
- Document all offboarding actions in the ticketing system
- Coordinate offboarding with HR and management
- Review recurring access removal tasks for automation

## Related Evidence

| Evidence | Location |
|---|---|
| Offboarding script | `powershell/Disable-OffboardedUser.ps1` |
| Offboarding validation screenshot | `screenshots/powershell-offboarding-success.png` |
| Offboarding user validation | `screenshots/powershell-offboarding-user-validation.png` |
| Offboarding group validation | `screenshots/powershell-offboarding-group-validation.png` |
| GLPI sample tickets screenshot | `screenshots/glpi-sample-tickets.png` |
| AD security groups screenshot | `screenshots/ad-security-groups.png` |

## Skills Demonstrated

This ticket demonstrates:

- Employee offboarding workflow
- Active Directory account disablement
- Group membership cleanup
- VPN access removal
- PowerShell automation
- Audit-friendly documentation
- GLPI request tracking
- Security-aware access management
- HR/IT process alignment