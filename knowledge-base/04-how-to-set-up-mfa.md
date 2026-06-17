# Knowledge Base Article 04: How to Set Up MFA

## Purpose

This article explains how BlancoTech Solutions users should set up Multi-Factor Authentication for Microsoft 365 and company account access.

MFA helps protect your account by requiring a second verification step in addition to your password.

## Applies To

This guide applies to:

- Microsoft 365
- Outlook
- Teams
- OneDrive
- SharePoint
- Company account sign-in
- Microsoft Authenticator
- Entra ID / Azure AD authentication

## What Is MFA?

Multi-Factor Authentication, or MFA, adds an extra layer of security to your account.

Instead of signing in with only a password, MFA requires a second verification method, such as:

- Microsoft Authenticator app approval
- One-time code
- SMS verification
- Phone call verification
- Temporary Access Pass if provided by IT

## Why MFA Is Required

MFA helps protect against:

- Stolen passwords
- Phishing attempts
- Unauthorized account access
- Suspicious sign-ins
- Business email compromise
- Remote access abuse

Even if someone learns your password, MFA can help prevent them from accessing your account.

## Before You Start

You need:

1. Your company username and password.
2. Your mobile phone.
3. Internet access on your phone.
4. Microsoft Authenticator installed.
5. Access to your Microsoft 365 sign-in page.

Recommended app:

```text
Microsoft Authenticator
```

## Step 1: Install Microsoft Authenticator

On your phone, install Microsoft Authenticator from the official app store.

Use only the official Microsoft Authenticator app.

Do not install unknown or third-party authenticator apps unless approved by IT.

## Step 2: Sign In to Microsoft 365

On your computer, go to the Microsoft 365 sign-in page and enter your company email and password.

If MFA registration is required, you may see a message similar to:

```text
More information required
```

Select next to begin setup.

## Step 3: Choose Microsoft Authenticator

When prompted to set up a verification method, choose:

```text
Microsoft Authenticator
```

Follow the on-screen instructions.

You may be asked to scan a QR code using the Authenticator app.

## Step 4: Add Your Account to Authenticator

On your phone:

1. Open Microsoft Authenticator.
2. Select add account.
3. Choose work or school account.
4. Select scan QR code.
5. Scan the QR code shown on your computer screen.

After scanning, your company account should appear in the Authenticator app.

## Step 5: Approve the Test Prompt

Microsoft may send a test approval prompt to your phone.

On your phone:

1. Open the Authenticator notification.
2. Confirm the sign-in request.
3. Approve only if you are actively signing in.
4. Return to your computer and finish setup.

If number matching is required, enter the number shown on your computer into the Authenticator app.

## Step 6: Add a Backup Method

If allowed, add a backup method such as:

- Phone number
- SMS code
- Phone call
- Backup authenticator method

This helps you regain access if your phone is replaced, lost, or unavailable.

## How to Sign In After MFA Is Set Up

After MFA is configured:

1. Enter your company email.
2. Enter your password.
3. Approve the MFA prompt on your phone.
4. Complete sign-in.

Only approve prompts that you personally started.

## If You Do Not Receive the MFA Prompt

Try the following:

1. Confirm your phone has internet access.
2. Open Microsoft Authenticator manually.
3. Check whether notifications are enabled.
4. Confirm battery saver is not blocking notifications.
5. Choose another verification method if available.
6. Restart the Authenticator app.
7. Restart your phone if needed.

If the issue continues, contact IT support.

## If You Get a New Phone

If you replace your phone, contact IT before removing the old device if possible.

You may need to re-register MFA.

Contact IT if:

- You lost your old phone
- You replaced your phone
- You changed your phone number
- Authenticator was deleted
- You cannot approve MFA prompts

## If You Receive an Unexpected MFA Prompt

Do not approve it.

Unexpected MFA prompts may mean someone else has your password.

If this happens:

1. Deny the prompt.
2. Do not approve repeated prompts.
3. Contact IT support immediately.
4. Change your password if instructed.
5. Report any suspicious sign-in activity.

## Common MFA Issues

| Issue | Possible Cause |
|---|---|
| No notification received | Phone offline, notifications blocked, app issue |
| Code does not work | Phone time mismatch or wrong account selected |
| Prompt goes to old phone | MFA method still tied to old device |
| User changed phone number | Old SMS method still registered |
| MFA setup loops | Browser/session issue or registration problem |
| Unexpected MFA prompt | Possible password compromise |

## Security Reminders

Do not:

- Approve MFA prompts you did not initiate
- Share MFA codes with anyone
- Send screenshots of MFA codes
- Let another person use your Authenticator app
- Ignore repeated MFA prompts
- Remove MFA without IT approval

IT will never ask you to share your password or MFA code.

## When to Contact IT Support

Contact IT if:

- You cannot set up Microsoft Authenticator
- Your phone was lost or replaced
- Your phone number changed
- MFA prompts go to the wrong device
- You are stuck in an MFA setup loop
- You receive unexpected MFA prompts
- You cannot access Microsoft 365 after MFA setup

Provide the following information:

| Information Needed | Example |
|---|---|
| Full name | Elena Torres |
| Department | HR |
| Email address | elena.torres@blancotechsolutions.com |
| MFA method affected | Microsoft Authenticator |
| Device status | New phone |
| Error message | More information required |

## Related Articles

| Article | Location |
|---|---|
| MFA troubleshooting runbook | `troubleshooting-runbooks/mfa-issue.md` |
| Password reset article | `knowledge-base/01-how-to-reset-password.md` |
| Outlook mailbox issue runbook | `troubleshooting-runbooks/outlook-mailbox-issue.md` |
| Phishing email runbook | `troubleshooting-runbooks/phishing-email-report.md` |

## For IT Staff

Related systems and workflows:

- Entra ID authentication methods
- Microsoft 365 MFA registration
- Microsoft Authenticator setup
- Temporary Access Pass workflow
- User identity verification
- Sign-in log review
- GLPI ticket documentation

Related lab evidence:

| Evidence | Location |
|---|---|
| MFA runbook | `troubleshooting-runbooks/mfa-issue.md` |
| MFA workflow documentation | `entra-id/mfa-workflow.md` |
| Onboarding workflow | `entra-id/onboarding-workflow.md` |
| GLPI ticket categories | `screenshots/glpi-ticket-categories.png` |