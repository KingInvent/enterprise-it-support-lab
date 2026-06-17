# Knowledge Base Article 02: How to Connect to VPN

## Purpose

This article explains how BlancoTech Solutions users should connect to the company VPN when working remotely.

VPN access allows approved users to securely reach internal company resources, including shared drives, internal systems, and domain-based services.

## Applies To

This guide applies to:

- Remote work
- VPN access
- Company shared drives
- Internal applications
- Domain resources
- Windows laptops
- Users assigned to the `VPN-Users` group

## When to Use VPN

Connect to VPN when you need access to:

- Company shared drives
- Internal applications
- Internal file shares
- Domain resources
- Systems that are not available from the public internet

Example internal resource:

```text
\\vm-bt-dc01\Company
```

## Before You Connect

Confirm the following:

1. Your internet connection is working.
2. You are using your company-approved device.
3. You know your current company username and password.
4. Your account has VPN access.
5. You have completed MFA if required.
6. You are not using an expired or old password.

## VPN Access Requirement

VPN access is controlled by the IT team.

Users must be approved and assigned to the correct access group:

```text
VPN-Users
```

If you are not approved for VPN access, submit a help desk ticket.

## How to Connect to VPN

Follow these steps:

1. Connect your computer to the internet.
2. Open the company VPN client.
3. Enter your company username.
4. Enter your current company password.
5. Complete MFA if prompted.
6. Wait for the VPN client to show connected.
7. Test access to the internal resource you need.

## Testing Internal Access

After VPN connects, test access to the company shared drive:

```text
\\vm-bt-dc01\Company
```

If the company drive opens, VPN is working.

If the drive does not open, wait 30 seconds and try again.

## If VPN Does Not Connect

Check the following:

| Check | What to Do |
|---|---|
| Internet access | Open a public website to confirm internet works |
| Username | Confirm you typed your username correctly |
| Password | Enter your current password manually |
| MFA | Approve only prompts you initiated |
| Saved credentials | Remove old saved VPN credentials if needed |
| Restart | Restart the VPN client or computer |
| Remote network | Try a different Wi-Fi network or mobile hotspot if needed |

## If You Recently Changed Your Password

If you recently changed your password, the VPN client may still be using your old saved password.

Do this:

1. Open the VPN client.
2. Remove the saved password if one is stored.
3. Type your new password manually.
4. Connect again.

Also update saved passwords in:

- Outlook
- Teams
- OneDrive
- Browser
- Mobile email app
- Windows Credential Manager

## Clear Saved VPN Credentials

If VPN repeatedly fails after a password change, clear old credentials.

Path:

```text
Control Panel → Credential Manager → Windows Credentials
```

Remove saved credentials related to:

```text
VPN
blancotech.local
company network
internal resources
```

Then restart the VPN client and sign in again.

## If VPN Connects but Internal Resources Do Not Work

If VPN says connected but internal resources do not open, the issue may involve DNS, network routing, or mapped drives.

Try opening the company share manually:

```text
\\vm-bt-dc01\Company
```

If this fails, contact IT support and include the exact error message.

## Common Error Scenarios

| Symptom | Possible Cause |
|---|---|
| VPN will not connect | Incorrect password, no internet, missing access |
| VPN keeps asking for password | Saved old credentials |
| VPN connects but drive missing | Group Policy, DNS, or mapped drive issue |
| VPN connects but internal sites fail | DNS or routing issue |
| MFA prompt not received | MFA setup or phone issue |
| Account locked after attempts | Too many failed sign-ins |

## Security Reminders

Do not:

- Share your VPN password
- Save your password on shared devices
- Approve MFA prompts you did not initiate
- Use VPN on untrusted public computers
- Ignore repeated VPN failures
- Send passwords to IT by email or chat

Report unexpected MFA prompts or suspicious sign-in activity immediately.

## When to Contact IT Support

Contact IT support if:

- VPN does not connect after checking your password
- You do not receive MFA prompts
- Your account is locked
- You changed your phone and MFA no longer works
- VPN connects but internal resources do not work
- You receive an access denied message
- You are not assigned VPN access but need it for work

Provide the following information:

| Information Needed | Example |
|---|---|
| Full name | Jordan Lee |
| Department | Sales |
| Device | Company laptop |
| Error message | VPN authentication failed |
| Location | Home Wi-Fi |
| Recent password change? | Yes / No |
| MFA issue? | Yes / No |

## Related Articles

| Article | Location |
|---|---|
| VPN troubleshooting runbook | `troubleshooting-runbooks/vpn-not-connecting.md` |
| DNS troubleshooting runbook | `troubleshooting-runbooks/dns-resolution-issue.md` |
| Mapped drive troubleshooting runbook | `troubleshooting-runbooks/mapped-drive-missing.md` |
| MFA issue runbook | `troubleshooting-runbooks/mfa-issue.md` |
| Password reset article | `knowledge-base/01-how-to-reset-password.md` |

## For IT Staff

Related systems and workflows:

- VPN access group validation
- Active Directory account status check
- `VPN-Users` group membership
- DNS and internal resource testing
- MFA validation
- GLPI ticket documentation

Related lab evidence:

| Evidence | Location |
|---|---|
| VPN sample ticket | `sample-tickets/03-vpn-connection-failure.md` |
| VPN runbook | `troubleshooting-runbooks/vpn-not-connecting.md` |
| Group membership script | `powershell/Get-GroupMembershipReport.ps1` |
| Network test script | `powershell/Test-NetworkConnectivity.ps1` |
| AD security groups screenshot | `screenshots/ad-security-groups.png` |
| Network test screenshot | `screenshots/powershell-network-test-output.png` |