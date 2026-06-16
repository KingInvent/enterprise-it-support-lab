# Account Locked Out Troubleshooting Runbook

## Overview

This runbook documents the troubleshooting process for a user account lockout in the BlancoTech Solutions Active Directory environment.

This issue commonly occurs when a user enters an incorrect password multiple times, has stale saved credentials, or has a device/application repeatedly attempting authentication with an old password.

## Scope

This runbook applies to:

- Active Directory user accounts
- Help desk account lockout tickets
- Domain sign-in issues
- Repeated password failure scenarios
- User access troubleshooting

## Related Systems

| System | Purpose |
|---|---|
| Active Directory | User identity and authentication |
| Windows Server | Domain controller hosting AD DS |
| PowerShell | Account status and lockout checks |
| GLPI | Ticket tracking and documentation |
| Group Policy | Domain password and lockout policy |

## Related Lab Evidence

| Evidence | Location |
|---|---|
| PowerShell lockout script | `powershell/Find-LockedOutUsers.ps1` |
| PowerShell validation screenshot | `screenshots/powershell-lockedout-output.png` |
| GLPI sample ticket | `User account locked out - Jordan Lee` |
| AD password/lockout policy | `screenshots/gpo-password-policy.png` |

## Symptoms

User may report:

- Cannot sign in to Windows
- Cannot access VPN
- Cannot access Microsoft 365 or internal resources
- Receives account locked message
- Password was recently changed but login still fails
- Sign-in works on one device but fails on another

## Initial Questions

Ask the user:

1. What system are you trying to access?
2. When did the issue start?
3. Did you recently change your password?
4. Are you signed in on another device?
5. Are you connected to VPN?
6. Are you using saved credentials in Outlook, Teams, browser, or mobile email?
7. Did you retry the password multiple times?

## Priority

| Condition | Priority |
|---|---|
| Single user locked out with workaround | Medium |
| Single user blocked from work | High |
| Multiple users locked out | Critical |
| Privileged/admin account locked out | High / Critical |

## Troubleshooting Steps

## 1. Confirm the User Identity

Verify:

- Username
- Department
- Affected device
- Affected application
- Whether the issue is local, domain, VPN, or application-specific

Example:

```text
User: Jordan Lee
Username: jlee
Department: Sales
Issue: Cannot sign in, possible account lockout