# Sample Ticket 02: User Account Locked Out

## Ticket Summary

| Field | Value |
|---|---|
| Ticket ID | INC-002 |
| Type | Incident |
| Category | Account Access |
| Priority | High |
| Status | Resolved |
| User | Jordan Lee |
| Department | Sales |
| System | Active Directory |
| Related Runbook | `troubleshooting-runbooks/account-locked-out.md` |
| Related Script | `powershell/Find-LockedOutUsers.ps1` |

## Issue Description

Jordan Lee from the Sales department reported that he could not sign in to his domain account. The user stated that the login screen displayed an account lockout message after multiple failed password attempts.

The issue prevented the user from accessing internal company resources, including VPN, mapped drives, and Microsoft 365 services.

## Business Impact

The user was blocked from starting remote work and could not access required Sales department resources.

Impact:

- User unable to sign in
- VPN access unavailable
- Internal resources unavailable
- Productivity blocked for one user

## Initial Triage

The following information was collected:

| Question | Answer |
|---|---|
| Can the user sign in? | No |
| Is the issue affecting multiple users? | No |
| Did the user recently change password? | No |
| Is the account disabled? | No |
| Is the account possibly locked? | Yes |
| Is this a security concern? | Low initially, monitor if repeated |

## Troubleshooting Steps

## 1. Verified User Identity

Confirmed the affected user:

```text
Name: Jordan Lee
Username: jlee
Department: Sales
Role: Sales Representative
```

## 2. Checked Active Directory Account Status

The account was reviewed in Active Directory to confirm whether it was enabled, locked, or affected by recent failed login attempts.

Example PowerShell check:

```powershell
Get-ADUser jlee -Properties Enabled,LockedOut,BadLogonCount,LastBadPasswordAttempt,PasswordLastSet |
Select-Object Name,SamAccountName,Enabled,LockedOut,BadLogonCount,LastBadPasswordAttempt,PasswordLastSet
```

## 3. Used PowerShell Lockout Script

The lockout report script was used to identify locked-out users in the domain.

Script used:

```text
powershell/Find-LockedOutUsers.ps1
```

Example command:

```powershell
cd C:\Lab\enterprise-it-support-lab-main\powershell

.\Find-LockedOutUsers.ps1
```

The script checks for locked-out Active Directory users and generates report output for documentation.

## 4. Reviewed Possible Causes

Likely causes reviewed:

- Incorrect password attempts
- Saved old credentials
- Outlook or Teams using stale credentials
- VPN client using cached credentials
- Mobile email app using an old password
- User typo or repeated failed login attempts

## 5. Unlocked Account if Needed

After verifying the user identity and confirming the account lockout condition, the account would be unlocked using approved support procedure.

Example command:

```powershell
Unlock-ADAccount -Identity jlee
```

## 6. Asked User to Clear Cached Credentials

The user was advised to check for saved credentials that could cause repeat lockouts.

Areas reviewed:

- Windows Credential Manager
- Outlook
- Teams
- VPN client
- Browser saved passwords
- Mobile email application

## 7. User Retested Sign-In

The user tested:

- Windows sign-in
- VPN access
- Microsoft 365 access
- Shared drive access

The user confirmed account access was restored.

## Resolution

The user account lockout was investigated using Active Directory and the PowerShell lockout workflow. The user identity was verified, account status was reviewed, and likely causes were documented.

The user was advised to clear stale saved credentials to prevent repeated lockouts.

## Resolution Notes

```text
Verified user identity and reviewed Active Directory account status. Checked locked-out accounts using the PowerShell lockout script. Confirmed the issue was isolated to the affected user. Reviewed likely causes including saved credentials, VPN client, Outlook, Teams, and mobile email. User tested login successfully after remediation and confirmed access was restored.
```

## Root Cause

Likely repeated failed login attempts or stale saved credentials from an application or device.

## Preventive Action

Recommended actions:

- Update saved credentials after password changes
- Avoid repeated login attempts
- Use password manager if approved
- Monitor recurring account lockouts
- Review sign-in patterns if the lockout repeats
- Escalate to security if suspicious login behavior appears

## Related Evidence

| Evidence | Location |
|---|---|
| Lockout script | `powershell/Find-LockedOutUsers.ps1` |
| Script validation screenshot | `screenshots/powershell-lockedout-output.png` |
| Account lockout runbook | `troubleshooting-runbooks/account-locked-out.md` |
| Password policy screenshot | `screenshots/gpo-password-policy.png` |

## Skills Demonstrated

This ticket demonstrates:

- Help desk ticket documentation
- Active Directory account troubleshooting
- PowerShell-based user support
- Account lockout investigation
- User identity verification
- Security-aware troubleshooting
- Clear resolution documentation
