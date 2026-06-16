# MFA Issue Troubleshooting Runbook

## Overview

This runbook documents the troubleshooting process for Multi-Factor Authentication issues in the BlancoTech Solutions environment.

MFA issues commonly occur because of a lost phone, changed phone number, Microsoft Authenticator problems, stale sessions, incorrect time settings, blocked sign-in attempts, or user confusion during MFA setup.

## Scope

This runbook applies to:

- Microsoft 365 MFA issues
- Entra ID / Azure AD sign-in problems
- Microsoft Authenticator issues
- User unable to approve MFA prompt
- Lost or replaced phone
- MFA setup problems
- MFA reset requests
- Help desk identity and access tickets

## Related Systems

| System | Purpose |
|---|---|
| Microsoft 365 | Cloud productivity platform |
| Entra ID / Azure AD | Identity and authentication |
| MFA | Second-factor sign-in protection |
| Microsoft Authenticator | Mobile MFA approval app |
| Conditional Access | Controls sign-in security policies |
| Active Directory | On-prem identity reference in hybrid environments |
| GLPI | Ticket tracking and documentation |

## Related Lab Evidence

| Evidence | Location |
|---|---|
| MFA workflow documentation | `entra-id/mfa-workflow.md` |
| Onboarding workflow | `entra-id/onboarding-workflow.md` |
| Offboarding workflow | `entra-id/offboarding-workflow.md` |
| Microsoft 365 documentation | `microsoft-365/` |
| GLPI ticket categories | `screenshots/glpi-ticket-categories.png` |

## Symptoms

User may report:

- Cannot approve MFA prompt
- Microsoft Authenticator is not sending a notification
- MFA prompt goes to old phone
- User replaced phone and lost access
- User changed phone number
- Verification code does not work
- MFA setup page keeps looping
- User receives “more information required”
- User can enter password but cannot complete sign-in
- User is locked out of Microsoft 365 because MFA fails

## Initial Questions

Ask the user:

1. Are you able to enter your password successfully?
2. What MFA method are you using?
3. Are you using Microsoft Authenticator, SMS, phone call, or another method?
4. Did you recently get a new phone?
5. Did your phone number change?
6. Are you receiving any MFA prompt or code?
7. Are you connected to the internet on your phone?
8. Are other Microsoft 365 apps affected?
9. Is this your first time setting up MFA?

## Priority

| Condition | Priority |
|---|---|
| User has alternate MFA method available | Medium |
| User cannot access Microsoft 365 | High |
| Executive or critical user blocked | High |
| Multiple users affected by MFA issue | Critical |
| Possible account compromise | Critical |

## Troubleshooting Steps

## 1. Confirm User Identity

Before making MFA changes, verify the user’s identity using approved support procedures.

Confirm:

- Full name
- Username / email address
- Department
- Manager if needed
- Callback number on file if available
- Existing ticket or request context

Do not reset MFA based only on an email request if identity cannot be verified.

Example:

```text
User: Elena Torres
Email: elena.torres@blancotechsolutions.com
Department: HR
Issue: Replaced phone and cannot approve MFA prompt
```

## 2. Confirm Password Works

Ask whether the user can successfully enter their password.

If the password fails before MFA appears, troubleshoot:

- Incorrect password
- Expired password
- Account locked out
- Disabled account
- Sign-in blocked

If the password works and MFA fails, continue with this runbook.

## 3. Identify Current MFA Method

Determine which MFA method is failing.

Common methods:

| MFA Method | Common Issue |
|---|---|
| Microsoft Authenticator push | No notification received |
| Microsoft Authenticator code | Code rejected or time mismatch |
| SMS | Old phone number or delayed message |
| Phone call | Call not received |
| Temporary Access Pass | Expired or not configured |
| Security key | Lost key or device issue |

## 4. Check Phone Internet and Time Settings

For Microsoft Authenticator issues, ask the user to confirm:

- Phone has internet access
- Authenticator app is installed
- Authenticator app notifications are allowed
- Phone time/date is set automatically
- Battery saver is not blocking notifications
- User is checking the correct account in Authenticator

If time is incorrect, one-time codes may fail.

## 5. Test Alternate MFA Method

If the user has another method configured, ask them to choose:

```text
Sign in another way
```

Possible alternate methods:

- SMS code
- Phone call
- Authenticator code
- Security key
- Temporary Access Pass

If alternate method works, user can sign in and update MFA settings.

## 6. Review MFA Methods in Entra ID

In Microsoft Entra admin center, review the user’s authentication methods.

Check:

- Registered phone number
- Authenticator app registration
- Default sign-in method
- Alternate methods
- Whether methods are outdated
- Whether user has enough methods configured

Do not remove all methods unless a reset is approved and documented.

## 7. Reset MFA Registration if Needed

If the user lost access to all MFA methods, reset MFA registration after verifying identity.

Admin action:

```text
Require re-register multifactor authentication
```

This forces the user to set up MFA again during next sign-in.

Use this when:

- User replaced phone
- Old phone was lost
- Authenticator app was deleted
- Phone number changed
- MFA methods are no longer valid

## 8. Use Temporary Access Pass if Available

If the organization uses Temporary Access Pass, issue a temporary pass after identity verification.

Use when:

- User has no valid MFA method
- User needs to register a new Authenticator app
- User is remote and cannot complete MFA
- Help desk needs a secure recovery method

Document:

- Reason for issuing pass
- Expiration time
- Ticket number
- User verification steps

## 9. Have User Re-Register MFA

Ask the user to sign in again and complete MFA registration.

User should add at least two methods if policy allows:

- Microsoft Authenticator
- Phone number
- Backup method

Recommended order:

1. Microsoft Authenticator app
2. SMS or phone call backup
3. Additional method if required by policy

## 10. Confirm Microsoft Authenticator Setup

For Authenticator setup:

1. User installs Microsoft Authenticator
2. User signs in to Microsoft 365
3. User scans QR code
4. User approves test prompt
5. User confirms sign-in works
6. User verifies account appears in Authenticator app

If QR scan fails, try manual setup code if available.

## 11. Clear Stale Sessions if Needed

If MFA registration was reset but user remains stuck, sign the user out of active sessions.

Possible admin action:

```text
Revoke sessions
```

This forces the user to sign in again with updated authentication state.

Use this if:

- User is stuck in an MFA loop
- Old session keeps failing
- User changed authentication method but apps still fail
- Suspicious session behavior exists

## 12. Check Conditional Access or Security Defaults

If multiple users are affected, review whether a policy change occurred.

Check:

- Conditional Access policies
- Security defaults
- MFA enforcement policy
- Named locations
- Device compliance requirements
- Blocked countries or risky sign-ins
- Authentication strength requirements

Escalate if policy behavior is unclear.

## 13. Confirm Sign-In Logs

Review sign-in logs for the affected user.

Look for:

- MFA requirement failed
- User failed MFA challenge
- Authentication method not available
- Conditional Access failure
- Risky sign-in
- Blocked sign-in
- Location or device restriction

Sign-in logs help determine whether the issue is user error, method failure, policy failure, or security-related.

## 14. Test Microsoft 365 Access

After MFA is fixed, have the user test:

- Outlook web
- Teams
- OneDrive
- SharePoint
- Microsoft 365 portal
- Outlook desktop if applicable
- Mobile Outlook if applicable

Confirm the issue is fully resolved, not only partially fixed.

## 15. Escalation Criteria

Escalate to Microsoft 365 Administrator, Security Administrator, or Systems Administrator if:

- Identity cannot be verified
- Account compromise is suspected
- User reports unexpected MFA prompts
- Sign-in logs show risky sign-in behavior
- Multiple users are affected
- Conditional Access policy is blocking sign-in
- MFA reset does not resolve issue
- User cannot register new MFA method
- Admin permissions are required beyond help desk scope

## Resolution Notes Template

Use this format in GLPI:

```text
Verified user identity and confirmed the issue was related to MFA rather than password failure. Reviewed the user’s available authentication methods and confirmed the current MFA method was unavailable. After identity verification, reset MFA registration and had the user re-register Microsoft Authenticator. User completed MFA setup successfully and confirmed access to Microsoft 365 services. Documented verification steps and user confirmation.
```

## GLPI Ticket Example

| Field | Value |
|---|---|
| Type | Incident |
| Category | Account Access |
| Priority | High |
| Title | MFA issue - user replaced phone |

Ticket description:

```text
User reports they replaced their phone and can no longer approve Microsoft Authenticator prompts. Verified user identity, reviewed MFA method status, required MFA re-registration, and guided user through Microsoft Authenticator setup. User confirmed successful sign-in to Microsoft 365 after MFA reset.
```

## Security Notes

MFA reset requests require careful handling.

Do not:

- Reset MFA without verifying identity
- Accept a reset request from an unknown email address
- Send temporary access details through insecure channels
- Remove MFA permanently to bypass policy
- Ignore unexpected MFA prompts reported by the user

Unexpected MFA prompts may indicate a compromised password or active attack.

## Prevention

Recommended prevention steps:

- Require users to register more than one MFA method
- Document MFA setup during onboarding
- Train users to report unexpected MFA prompts
- Encourage users to update phone numbers before replacing devices
- Use Temporary Access Pass for secure recovery
- Monitor risky sign-ins and repeated MFA failures
- Include MFA review during offboarding and security audits

## Skills Demonstrated

This runbook demonstrates:

- MFA troubleshooting
- Microsoft 365 support workflow
- Entra ID / Azure AD user support
- Authentication method review
- Secure identity verification
- Temporary Access Pass awareness
- Sign-in log analysis
- Conditional Access awareness
- Help desk ticket documentation
- Security-aware escalation