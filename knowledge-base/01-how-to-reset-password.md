# Knowledge Base Article 01: How to Reset Your Password

## Purpose

This article explains how BlancoTech Solutions users should request a password reset and what to do after the password has been changed.

## Applies To

This guide applies to:

- Windows sign-in
- Microsoft 365 sign-in
- Outlook
- Teams
- OneDrive
- SharePoint
- VPN access
- Company shared drives

## When to Use This Article

Use this article if:

- You forgot your password
- Your password no longer works
- You recently changed your password and some apps still fail
- You are locked out after too many failed attempts
- Outlook, Teams, or VPN keeps asking for your old password

## Before You Request a Password Reset

Check the following first:

1. Make sure Caps Lock is off.
2. Confirm you are typing the correct username.
3. Try signing in again carefully.
4. If you recently changed your password, use your newest password.
5. If you are remote, confirm you have internet access.

If the password still does not work, contact IT support.

## How to Request a Password Reset

Submit a help desk ticket or contact IT support with the following information:

| Information Needed | Example |
|---|---|
| Full name | Jordan Lee |
| Username or email | jordan.lee@blancotechsolutions.com |
| Department | Sales |
| Device affected | Laptop |
| Service affected | Windows, VPN, Outlook, Teams |
| Error message | Account locked or incorrect password |

Do not send your current password or any previous password to IT.

## Identity Verification

For security, IT may verify your identity before resetting your password.

You may be asked to confirm:

- Full name
- Department
- Manager
- Company device name
- Callback number
- Recent ticket number

This protects your account from unauthorized access.

## After IT Resets Your Password

After your password is reset:

1. Sign in with the temporary password provided through the approved process.
2. Create a new password when prompted.
3. Use a strong password.
4. Do not reuse an old password.
5. Do not share your password with anyone.

## Password Requirements

Your new password should follow company password requirements.

Recommended password rules:

- At least 12 characters
- Use uppercase and lowercase letters
- Use numbers
- Use special characters
- Avoid names, birthdays, or common words
- Do not reuse old passwords

Example of a strong password pattern:

```text
Three unrelated words + numbers + symbol
```

Do not use the example as your actual password.

## Update Saved Passwords

After changing your password, update saved credentials in:

- Windows sign-in
- VPN client
- Outlook
- Teams
- OneDrive
- Browser saved passwords
- Mobile email app
- Windows Credential Manager

If old passwords remain saved, your account may lock again.

## Clear Windows Saved Credentials

If Outlook, Teams, VPN, or mapped drives keep asking for a password, clear old saved credentials.

Path:

```text
Control Panel → Credential Manager → Windows Credentials
```

Remove saved credentials related to:

```text
Microsoft 365
Outlook
Teams
VPN
blancotech.local
vm-bt-dc01
Company shared drives
```

Then restart the affected application and sign in again with the new password.

## VPN Users

If you work remotely, update your VPN password after the reset.

Steps:

1. Connect to the internet.
2. Open the VPN client.
3. Enter your new password manually.
4. Do not rely on saved credentials.
5. Connect to VPN.
6. Test access to internal resources.

If VPN still fails, contact IT support.

## Microsoft 365 Users

After a password reset, sign back in to:

- Outlook
- Teams
- OneDrive
- SharePoint
- Microsoft 365 web portal

If you receive an MFA prompt, approve it only if you initiated the sign-in.

Do not approve unexpected MFA prompts.

## If Your Account Locks Again

If your account locks again after a reset, contact IT support.

Common causes include:

- Old password saved in VPN
- Old password saved in Outlook
- Old password saved on a phone
- Old password saved in browser
- Mapped drive using old credentials
- Another device repeatedly trying the old password

IT may need to check for repeated failed sign-in attempts.

## Security Reminders

Do not:

- Share your password
- Send passwords by email or chat
- Save passwords in unapproved locations
- Approve MFA prompts you did not request
- Reuse your work password on personal websites
- Ignore repeated password prompts

Report suspicious sign-in activity to IT immediately.

## When to Contact IT Support

Contact IT if:

- You cannot reset your password
- Your account is locked
- MFA does not work
- VPN still fails after password reset
- Outlook keeps asking for the old password
- You receive unexpected MFA prompts
- You think someone else may know your password

## Related Articles

| Article | Location |
|---|---|
| Account locked out runbook | `troubleshooting-runbooks/account-locked-out.md` |
| MFA issue runbook | `troubleshooting-runbooks/mfa-issue.md` |
| VPN troubleshooting runbook | `troubleshooting-runbooks/vpn-not-connecting.md` |
| Outlook mailbox issue runbook | `troubleshooting-runbooks/outlook-mailbox-issue.md` |

## For IT Staff

Related systems and workflows:

- Active Directory user account reset
- Account lockout investigation
- MFA verification
- Credential cache troubleshooting
- GLPI ticket documentation

Related lab evidence:

| Evidence | Location |
|---|---|
| Account lockout runbook | `troubleshooting-runbooks/account-locked-out.md` |
| Account lockout sample ticket | `sample-tickets/02-account-locked-out.md` |
| Lockout PowerShell script | `powershell/Find-LockedOutUsers.ps1` |
| Password policy screenshot | `screenshots/gpo-password-policy.png` |