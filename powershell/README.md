# PowerShell Automation

## Overview

This section contains PowerShell scripts created for the BlancoTech Solutions IT lab.

The goal is to demonstrate practical automation for Active Directory administration, account lifecycle management, reporting, access review, account troubleshooting, and network diagnostics.

These scripts are designed to be tested against the `blancotech.local` Active Directory environment hosted on the Windows Server domain controller.

## Environment

| Item | Configuration |
|---|---|
| Domain | blancotech.local |
| Domain Controller | vm-bt-dc01 |
| Server OS | Windows Server 2025 Datacenter |
| Script Location | powershell/ |
| Test Location | Windows Server VM |
| Required Module | ActiveDirectory PowerShell module |
| Log Directory | C:\Logs |
| Report Directory | C:\Reports |

## Script Inventory

| Script | Purpose |
|---|---|
| Create-NewHireUser.ps1 | Creates a new AD user, assigns OU placement, groups, manager, VPN access, and logs actions |
| Disable-OffboardedUser.ps1 | Disables an AD user, removes group memberships, clears manager, updates description, moves account to Disabled Users OU |
| Export-ADUserReport.ps1 | Exports AD user inventory to CSV and HTML reports |
| Get-GroupMembershipReport.ps1 | Exports AD group membership details to CSV and HTML reports |
| Find-LockedOutUsers.ps1 | Finds locked-out users, exports reports, and optionally unlocks accounts |
| Test-NetworkConnectivity.ps1 | Runs network troubleshooting checks and exports diagnostic reports |

## 1. Create-NewHireUser.ps1

### Purpose

Automates new hire account creation in Active Directory.

### Actions Performed

- Creates a new AD user
- Places the user in the correct department OU
- Assigns `All-Employees`
- Assigns the correct department group
- Optionally assigns `VPN-Users`
- Optionally assigns a manager
- Requires password change at next logon
- Logs activity to `C:\Logs\NewHireLog.txt`

### Example

    .\Create-NewHireUser.ps1 `
      -FirstName "Carlos" `
      -LastName "Mendez" `
      -Department "Sales" `
      -JobTitle "Sales Representative" `
      -Manager "mgonzalez" `
      -EnableVPN

### Skills Demonstrated

- AD user provisioning
- OU targeting
- Group-based access assignment
- Secure password prompt handling
- Manager attribute assignment
- PowerShell logging
- Input validation

## 2. Disable-OffboardedUser.ps1

### Purpose

Automates the user offboarding process in Active Directory.

### Actions Performed

- Validates the user exists
- Disables the AD account
- Removes group memberships except `Domain Users`
- Clears the Manager attribute
- Updates the Description field with reason and ticket number
- Moves the user to the Disabled Users OU
- Logs activity to `C:\Logs\OffboardingLog.txt`

### Example

    .\Disable-OffboardedUser.ps1 `
      -SamAccountName "cmendez" `
      -Reason "Resignation" `
      -TicketNumber "INC-1007"

### Skills Demonstrated

- AD account disablement
- User lifecycle management
- Group membership cleanup
- Attribute modification
- OU movement
- Audit-friendly logging

## 3. Export-ADUserReport.ps1

### Purpose

Exports a full Active Directory user inventory report.

### Actions Performed

- Queries users under the BlancoTech Users OU
- Reports account status and user metadata
- Detects stale accounts based on last logon
- Counts enabled, disabled, stale, locked-out, and password-never-expires users
- Exports CSV report
- Exports HTML report
- Logs activity to `C:\Logs\ADUserReportLog.txt`

### Example

    .\Export-ADUserReport.ps1

    .\Export-ADUserReport.ps1 -OutputPath "C:\Reports" -StaleThresholdDays 60

### Report Fields

- SamAccountName
- DisplayName
- UserPrincipalName
- Department
- Title
- Enabled
- LockedOut
- PasswordNeverExpires
- PasswordLastSet
- LastLogonDate
- StaleAccount
- GroupCount
- DistinguishedName

### Skills Demonstrated

- AD user reporting
- CSV export
- HTML report generation
- stale account detection
- password/account status review
- PowerShell calculated properties

## 4. Get-GroupMembershipReport.ps1

### Purpose

Exports Active Directory group membership reports for access review.

### Actions Performed

- Queries all groups under the BlancoTech Groups OU
- Optionally queries a single group
- Recursively retrieves group members
- Includes user department, title, and enabled status
- Counts groups, users, disabled members, and empty groups
- Exports CSV report
- Exports HTML report
- Logs activity to `C:\Logs\GroupMembershipReportLog.txt`

### Examples

    .\Get-GroupMembershipReport.ps1

    .\Get-GroupMembershipReport.ps1 -GroupName "VPN-Users"

### Report Fields

- GroupName
- GroupDescription
- MemberName
- SamAccountName
- ObjectClass
- Department
- Title
- Enabled
- DistinguishedName

### Skills Demonstrated

- AD group membership auditing
- access-control review
- recursive membership lookup
- CSV and HTML reporting
- disabled account detection in groups

## 5. Find-LockedOutUsers.ps1

### Purpose

Finds locked-out Active Directory users and optionally unlocks them.

### Actions Performed

- Searches for locked-out AD user accounts
- Displays lockout details
- Exports CSV report
- Exports HTML report
- Logs activity to `C:\Logs\LockedOutUsersLog.txt`
- Optionally unlocks locked-out users with `-Unlock`

### Examples

    .\Find-LockedOutUsers.ps1

    .\Find-LockedOutUsers.ps1 -Unlock

    .\Find-LockedOutUsers.ps1 -OutputPath "C:\Reports" -Unlock

### Report Fields

- SamAccountName
- DisplayName
- Department
- Title
- Enabled
- LockedOut
- BadLogonCount
- BadPasswordTime
- LockoutTime
- DistinguishedName

### Skills Demonstrated

- Help Desk account troubleshooting
- account lockout investigation
- account unlock remediation
- CSV and HTML reporting
- PowerShell conditional execution

## 6. Test-NetworkConnectivity.ps1

### Purpose

Runs basic network connectivity diagnostics for IT support troubleshooting.

### Actions Performed

- Collects local IPv4 configuration
- Detects active interface
- Detects default gateway
- Detects DNS servers
- Runs ping test
- Runs DNS resolution test
- Runs TCP port test
- Tests gateway connectivity
- Exports CSV report
- Exports HTML report
- Logs activity to `C:\Logs\NetworkConnectivityLog.txt`

### Examples

    .\Test-NetworkConnectivity.ps1

    .\Test-NetworkConnectivity.ps1 -Target "blancotech.local" -Port 53

    .\Test-NetworkConnectivity.ps1 -Target "vm-bt-dc01.blancotech.local" -Port 3389

### Diagnostic Checks

| Check | Purpose |
|---|---|
| Local IPv4 Address | Confirms local network address |
| Active Interface | Identifies active network adapter |
| Default Gateway | Confirms gateway configuration |
| DNS Servers | Confirms DNS configuration |
| Ping Target | Tests ICMP reachability |
| DNS Resolution | Tests name resolution |
| TCP Port Test | Tests service connectivity |
| Default Gateway Ping | Tests local network path |

### Skills Demonstrated

- network troubleshooting
- DNS testing
- TCP port testing
- gateway validation
- endpoint diagnostics
- CSV and HTML reporting

## Testing Plan

The scripts will be tested on the Windows Server domain controller:

    vm-bt-dc01

Testing will validate:

- new user creation
- group membership assignment
- AD user reporting
- group membership reporting
- locked-out user checks
- network connectivity diagnostics
- CSV and HTML report generation
- log file creation

## Planned Screenshots

The following screenshots will be added after VM testing:

| Screenshot | Purpose |
|---|---|
| powershell-newhire-script-success.png | New hire script successful execution |
| powershell-newhire-user-validation.png | AD validation of created user |
| powershell-newhire-group-validation.png | Group membership validation |
| powershell-offboarding-success.png | Offboarding script successful execution |
| powershell-user-report-output.png | AD user report output |
| powershell-group-report-output.png | Group membership report output |
| powershell-lockedout-output.png | Locked-out user script output |
| powershell-network-test-output.png | Network connectivity script output |

## Notes

These scripts are built for a lab environment and should be reviewed before production use.

Production use would require additional controls such as:

- delegated least-privilege permissions
- approval workflow integration
- stronger error handling
- transcript logging
- change ticket validation
- secure credential handling
- code signing
- source-controlled release process