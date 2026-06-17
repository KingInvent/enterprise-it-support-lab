# Security Baseline

## Overview

This section documents the security baseline implemented for the BlancoTech Solutions hybrid IT lab.

The goal of this baseline is to demonstrate practical security controls used in IT support and systems administration environments, including password policy, account lockout protection, least privilege access, account lifecycle management, Group Policy controls, MFA support, phishing response, and audit reporting.

## Environment

| Item | Value |
|---|---|
| Company | BlancoTech Solutions |
| Domain | `blancotech.local` |
| Domain Controller | `vm-bt-dc01.blancotech.local` |
| Domain Controller IP | `10.0.0.4` |
| Primary Identity System | Active Directory |
| Cloud Identity Reference | Microsoft Entra ID / Azure AD |
| Ticketing System | GLPI |
| Automation | PowerShell |
| Documentation | GitHub Markdown |

## Security Objectives

This baseline focuses on:

- Reducing unauthorized access risk
- Enforcing password and lockout controls
- Applying least privilege access
- Standardizing onboarding and offboarding
- Protecting user workstations through Group Policy
- Supporting MFA and phishing response workflows
- Documenting audit and reporting procedures
- Creating repeatable IT support processes

## Implemented Controls

| Control Area | Status | Evidence |
|---|---:|---|
| Password policy | Implemented | `screenshots/gpo-password-policy.png` |
| Account lockout policy | Implemented | `screenshots/gpo-password-policy.png` |
| Screen lock policy | Implemented | `screenshots/gpo-screen-lock-settings.png` |
| USB storage restriction | Implemented | `screenshots/gpo-usb-block-settings.png` |
| Mapped drive policy | Implemented | `screenshots/gpo-mapped-drive-settings.png` |
| Group-based access | Implemented | `screenshots/ad-security-groups.png` |
| Disabled Users OU | Implemented | `windows-server-ad/README.md` |
| PowerShell audit scripts | Implemented | `powershell/README.md` |
| MFA support workflow | Documented | `entra-id/mfa-workflow.md` |
| Phishing response workflow | Documented | `troubleshooting-runbooks/phishing-email-report.md` |
| Offboarding workflow | Implemented | `powershell/Disable-OffboardedUser.ps1` |

## Password Policy

The domain password policy was configured to enforce stronger authentication standards.

Configured settings:

| Setting | Value |
|---|---|
| Minimum password length | 12 characters |
| Complexity required | Enabled |
| Maximum password age | 90 days |
| Minimum password age | 1 day |
| Password history | 10 passwords remembered |
| Reversible encryption | Disabled |

Evidence:

```text
screenshots/gpo-password-policy.png
```

Purpose:

- Reduce weak password usage
- Prevent immediate password reuse
- Enforce basic password complexity
- Support account security best practices

## Account Lockout Policy

The account lockout policy was configured to reduce brute force and repeated password guessing risk.

Configured settings:

| Setting | Value |
|---|---|
| Lockout threshold | 5 failed attempts |
| Lockout duration | 15 minutes |
| Lockout observation window | 15 minutes |

Purpose:

- Slow down repeated failed login attempts
- Protect against password guessing
- Support help desk lockout investigation
- Create a measurable account access control

Related documentation:

| Item | Location |
|---|---|
| Account lockout runbook | `troubleshooting-runbooks/account-locked-out.md` |
| Account lockout sample ticket | `sample-tickets/02-account-locked-out.md` |
| Lockout script | `powershell/Find-LockedOutUsers.ps1` |

## Screen Lock Policy

A screen lock policy was configured through Group Policy.

Policy:

```text
GPO - User Screen Lock Policy
```

Configured behavior:

| Setting | Value |
|---|---|
| Screen saver | Enabled |
| Password protection | Enabled |
| Timeout | 900 seconds / 15 minutes |

Evidence:

```text
screenshots/gpo-screen-lock-settings.png
```

Purpose:

- Reduce risk from unattended workstations
- Protect user sessions
- Support office security hygiene
- Enforce consistent workstation behavior

## USB Storage Restriction

A USB storage restriction policy was configured through Group Policy.

Policy:

```text
GPO - Block USB Storage
```

Evidence:

```text
screenshots/gpo-usb-block-settings.png
```

Purpose:

- Reduce risk of unauthorized data transfer
- Reduce malware exposure from removable media
- Support endpoint security controls
- Demonstrate workstation hardening through Group Policy

## Group-Based Access Control

Access was organized using Active Directory security groups.

Security groups include:

| Group | Purpose |
|---|---|
| `All-Employees` | Baseline employee access |
| `HR-Users` | HR department access |
| `Finance-Users` | Finance department access |
| `Sales-Users` | Sales department access |
| `Operations-Users` | Operations department access |
| `IT-Users` | IT department access |
| `Managers` | Manager-level grouping |
| `VPN-Users` | VPN access eligibility |
| `IT-Admins` | Administrative access |
| `Helpdesk-Technicians` | Help desk support access |
| `GLPI-Technicians` | Ticketing technician access |
| `M365-Helpdesk` | Microsoft 365 support access |

Evidence:

```text
screenshots/ad-security-groups.png
```

Purpose:

- Apply least privilege
- Avoid direct user permission assignment where possible
- Simplify onboarding and offboarding
- Support department-based access management
- Improve auditability

## Least Privilege Model

The lab uses a basic least privilege model.

Principles:

- Users receive only access required for their department and role
- VPN access is controlled through `VPN-Users`
- IT administrative access is limited to IT-specific groups
- Help desk access is separated from full administrative access
- Offboarded users are removed from access groups
- Disabled accounts are moved to the Disabled Users OU

Examples:

| User Type | Access Model |
|---|---|
| Sales user | `All-Employees`, `Sales-Users`, optional `VPN-Users` |
| HR user | `All-Employees`, `HR-Users` |
| IT support user | `All-Employees`, `IT-Users`, `Helpdesk-Technicians` |
| Systems administrator | `All-Employees`, `IT-Users`, `IT-Admins` |

## Onboarding Security Controls

New hire onboarding follows a structured workflow.

Controls:

- User created in correct department OU
- Department group assigned
- VPN access assigned only if needed
- Manager field populated where applicable
- Temporary password set securely
- Password change required at next logon
- Actions logged through PowerShell workflow
- Ticket created in GLPI

Related documentation:

| Item | Location |
|---|---|
| Onboarding workflow | `entra-id/onboarding-workflow.md` |
| New hire script | `powershell/Create-NewHireUser.ps1` |
| New hire sample ticket | `sample-tickets/01-new-hire-onboarding.md` |
| GLPI documentation | `glpi-ticketing/setup.md` |

## Offboarding Security Controls

Offboarding follows a standardized access removal process.

Controls:

- Account disabled
- Group memberships removed except `Domain Users`
- VPN access removed
- Department access removed
- Manager field cleared
- Account description updated with ticket reference
- Account moved to Disabled Users OU
- Action logged by PowerShell
- GLPI ticket updated for audit trail

Related documentation:

| Item | Location |
|---|---|
| Offboarding script | `powershell/Disable-OffboardedUser.ps1` |
| Offboarding sample ticket | `sample-tickets/05-employee-offboarding.md` |
| Offboarding workflow | `entra-id/offboarding-workflow.md` |
| Offboarding validation screenshot | `screenshots/powershell-offboarding-success.png` |

Purpose:

- Quickly remove access after separation
- Preserve account for audit purposes
- Avoid deleting historical identity records
- Reduce unauthorized access risk
- Standardize HR/IT coordination

## MFA Support Workflow

MFA support is documented for Microsoft 365 / Entra ID workflows.

Covered scenarios:

- User cannot approve MFA prompt
- User replaced phone
- User changed phone number
- Microsoft Authenticator not working
- User receives unexpected MFA prompt
- MFA re-registration needed
- Temporary Access Pass awareness

Related documentation:

| Item | Location |
|---|---|
| MFA workflow | `entra-id/mfa-workflow.md` |
| MFA troubleshooting runbook | `troubleshooting-runbooks/mfa-issue.md` |
| MFA knowledge base article | `knowledge-base/04-how-to-set-up-mfa.md` |

Security reminder:

```text
Unexpected MFA prompts may indicate password compromise and should be reported immediately.
```

## Phishing Response Workflow

Phishing response documentation was created to support user-reported suspicious emails.

Covered scenarios:

- User received suspicious email
- User clicked a phishing link
- User opened suspicious attachment
- User entered credentials
- User approved unexpected MFA prompt
- Multiple users received the same email

Related documentation:

| Item | Location |
|---|---|
| Phishing runbook | `troubleshooting-runbooks/phishing-email-report.md` |
| Phishing KB article | `knowledge-base/05-how-to-report-phishing-email.md` |
| GLPI Security category | `glpi-ticketing/setup.md` |

Security response considerations:

- Preserve evidence
- Identify user interaction level
- Reset password if credentials were entered
- Revoke sessions if compromise is suspected
- Review MFA methods
- Review sign-in logs
- Check mailbox forwarding and rules
- Escalate to security if needed

## Audit and Reporting Scripts

PowerShell scripts were created to support repeatable audit and support workflows.

| Script | Security Purpose |
|---|---|
| `Export-ADUserReport.ps1` | Reports enabled, disabled, stale, locked, and password-never-expires accounts |
| `Get-GroupMembershipReport.ps1` | Reviews group memberships and access assignments |
| `Find-LockedOutUsers.ps1` | Identifies locked-out users and supports account lockout investigation |
| `Disable-OffboardedUser.ps1` | Standardizes access removal during offboarding |
| `Create-NewHireUser.ps1` | Standardizes secure account creation |
| `Test-NetworkConnectivity.ps1` | Supports DNS and network troubleshooting |

Related documentation:

```text
powershell/README.md
```

## Privileged Access Review

Privileged and administrative groups were reviewed as part of the AD audit.

Reviewed areas:

- Domain Admins
- Enterprise Admins
- IT administrative groups
- Help desk groups
- VPN access group
- Microsoft 365 support group

Evidence:

```text
screenshots/ad-privileged-groups-audit.png
```

Purpose:

- Identify privileged users
- Reduce excessive administrative access
- Improve audit awareness
- Support least privilege

## User Security Audit

User account security checks were performed.

Reviewed items:

- Disabled accounts
- Locked-out accounts
- Password never expires
- Users who cannot change password
- Guest account status
- krbtgt account status

Evidence:

```text
screenshots/ad-user-security-audit.png
```

Documented findings:

| Check | Result |
|---|---|
| Guest account | Disabled |
| krbtgt account | Disabled |
| Locked-out users | 0 during audit |
| Enabled users with PasswordNeverExpires | 0 |
| Enabled users unable to change password | 0 |

## GLPI Security Ticketing

GLPI was configured to support security-related ticket tracking.

Relevant categories:

- Account Access
- Security
- Offboarding
- Network
- Email / Microsoft 365

Security-related sample tickets:

| Ticket | Location |
|---|---|
| Account lockout | `sample-tickets/02-account-locked-out.md` |
| Employee offboarding | `sample-tickets/05-employee-offboarding.md` |
| Phishing response workflow | `troubleshooting-runbooks/phishing-email-report.md` |
| MFA issue workflow | `troubleshooting-runbooks/mfa-issue.md` |

Purpose:

- Centralize security support requests
- Document user-reported incidents
- Track access changes
- Support audit trail
- Provide repeatable resolution notes

## Current Security Baseline Summary

| Area | Status |
|---|---:|
| Active Directory users and groups | Complete |
| Password policy | Complete |
| Account lockout policy | Complete |
| Group Policy security controls | Complete |
| Group-based access model | Complete |
| Offboarding process | Complete |
| MFA support documentation | Complete |
| Phishing response documentation | Complete |
| PowerShell audit scripts | Complete |
| GLPI security ticketing | Complete |

## Production Improvements

This lab baseline demonstrates core security concepts. A production environment would also require:

- Endpoint detection and response
- Centralized logging / SIEM
- Conditional Access policies
- Microsoft Defender for Office 365
- Device compliance policies
- Intune configuration profiles
- BitLocker enforcement
- Vulnerability management
- Patch compliance reporting
- Security awareness training
- Backup monitoring
- Formal incident response process
- Regular access reviews

## Skills Demonstrated

This security baseline demonstrates:

- Active Directory security administration
- Group Policy security configuration
- Password and lockout policy design
- Group-based access control
- Least privilege planning
- Secure onboarding and offboarding
- MFA support workflow
- Phishing response workflow
- PowerShell audit reporting
- GLPI security ticket documentation
- Practical IT support security awareness