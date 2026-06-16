# Outlook Mailbox Issue Troubleshooting Runbook

## Overview

This runbook documents the troubleshooting process for Outlook and mailbox access issues in the BlancoTech Solutions environment.

Outlook issues commonly occur because of incorrect credentials, expired passwords, Microsoft 365 licensing problems, mailbox permission issues, network connectivity problems, Outlook profile corruption, cached credentials, or service availability issues.

## Scope

This runbook applies to:

- Outlook sign-in issues
- Mailbox access problems
- Outlook not opening
- Outlook disconnected status
- Mailbox permission issues
- Shared mailbox access issues
- Email send/receive problems
- Microsoft 365 / Exchange Online support tickets

## Related Systems

| System | Purpose |
|---|---|
| Microsoft 365 | Cloud productivity platform |
| Exchange Online | Mailbox hosting |
| Outlook | Email client |
| Entra ID / Azure AD | Identity and authentication |
| Active Directory | On-prem identity reference in hybrid environments |
| MFA | Sign-in protection |
| DNS / Networking | Connectivity and service resolution |
| GLPI | Ticket tracking and documentation |

## Related Lab Evidence

| Evidence | Location |
|---|---|
| Microsoft 365 documentation | `microsoft-365/` |
| Entra ID documentation | `entra-id/` |
| GLPI ticket categories | `screenshots/glpi-ticket-categories.png` |
| Network test script | `powershell/Test-NetworkConnectivity.ps1` |
| Network test screenshot | `screenshots/powershell-network-test-output.png` |

## Symptoms

User may report:

- Outlook will not open
- Outlook says disconnected
- Outlook keeps asking for password
- User cannot send or receive email
- Mailbox is missing
- Shared mailbox is not visible
- Calendar does not sync
- Outlook works on web but not desktop app
- Outlook works on one device but not another
- User receives mailbox permission or access denied errors

## Initial Questions

Ask the user:

1. Are you using Outlook desktop, Outlook web, or mobile Outlook?
2. Are you able to sign in to Microsoft 365 in a browser?
3. Are you receiving an error message?
4. Did you recently change your password?
5. Are other Microsoft 365 apps working?
6. Is the issue affecting only email or all Microsoft services?
7. Is the issue affecting only you or multiple users?
8. Are you trying to access your own mailbox or a shared mailbox?

## Priority

| Condition | Priority |
|---|---|
| Single user Outlook issue with webmail workaround | Medium |
| Single user blocked from email entirely | High |
| Executive or critical business mailbox unavailable | High |
| Multiple users unable to access email | Critical |
| Microsoft 365 service outage suspected | Critical |

## Troubleshooting Steps

## 1. Confirm User and Mailbox Details

Verify:

- User full name
- Username / email address
- Department
- Device type
- Outlook version if known
- Whether issue affects desktop, web, or mobile
- Whether user can access other Microsoft 365 services

Example:

```text
User: Elena Torres
Email: elena.torres@blancotechsolutions.com
Department: HR
Issue: Outlook desktop keeps asking for password
```

## 2. Confirm Whether Outlook Web Works

Ask the user to sign in through Outlook on the web.

If Outlook web works but desktop Outlook fails, the issue is likely local to the workstation or Outlook profile.

If Outlook web also fails, the issue may involve:

- Password
- MFA
- License
- Account status
- Mailbox status
- Microsoft 365 service availability

## 3. Check Account Status

Confirm the user account is active.

In Microsoft 365 / Entra ID, verify:

- Account is enabled
- User can sign in
- Password is not expired
- MFA status is valid
- User is not blocked from sign-in

If the user is locked out or cannot authenticate, follow the account lockout or MFA runbook.

## 4. Check Microsoft 365 License Assignment

Confirm the user has a license that includes Exchange Online.

Check:

- Microsoft 365 license assigned
- Exchange Online service plan enabled
- License was not recently removed
- Mailbox exists

If the user has no Exchange Online license, Outlook mailbox access will fail.

## 5. Check Mailbox Availability

Verify that the mailbox exists and is active.

Potential checks:

| Check | Purpose |
|---|---|
| Mailbox exists | Confirms Exchange mailbox was provisioned |
| Mailbox license active | Confirms mailbox is entitled |
| Mailbox not hidden incorrectly | Confirms visibility where needed |
| Shared mailbox permissions | Confirms delegate access |
| Send As / Send on Behalf | Confirms sending permission |

## 6. Check Outlook Connection Status

On Windows Outlook desktop:

```text
Hold Ctrl → Right-click Outlook icon in system tray → Connection Status
```

Review whether Outlook is connected to Exchange Online.

If Outlook shows disconnected:

- Confirm internet access
- Restart Outlook
- Sign out and sign back in
- Check cached credentials
- Test Outlook web access
- Restart the workstation if needed

## 7. Restart Outlook and Device

Basic first-line remediation:

1. Close Outlook completely
2. Confirm Outlook is not running in Task Manager
3. Reopen Outlook
4. Restart workstation if issue continues
5. Test again

This resolves temporary client-side issues.

## 8. Check Internet and DNS Connectivity

Confirm the workstation has internet access.

Run:

```powershell
Test-Connection outlook.office.com -Count 4
```

Test HTTPS connectivity:

```powershell
Test-NetConnection outlook.office.com -Port 443
```

Expected result:

```text
TcpTestSucceeded : True
```

If connectivity fails, troubleshoot network, DNS, VPN, or firewall restrictions.

## 9. Clear Cached Credentials

If Outlook repeatedly prompts for password, clear saved credentials.

Path:

```text
Control Panel → Credential Manager → Windows Credentials
```

Remove stale credentials related to:

```text
MicrosoftOffice
Outlook
Office
Microsoft 365
ADAL
Exchange
```

Then restart Outlook and sign in again.

## 10. Confirm Recent Password Change

If the user recently changed their password, old credentials may remain saved in:

- Outlook
- Teams
- OneDrive
- Browser
- Windows Credential Manager
- Mobile email app
- VPN client

Have the user update credentials across devices to prevent repeated sign-in issues or account lockouts.

## 11. Start Outlook in Safe Mode

If Outlook crashes or freezes, start Outlook in safe mode.

Run:

```text
Win + R → outlook.exe /safe
```

If Outlook opens in safe mode, the issue may be caused by:

- Add-in
- Corrupt view
- Outlook extension
- Local profile issue

Disable suspicious add-ins and retest.

## 12. Create a New Outlook Profile

If Outlook profile corruption is suspected, create a new profile.

Path:

```text
Control Panel → Mail → Show Profiles → Add
```

Steps:

1. Add a new Outlook profile
2. Configure the user mailbox
3. Set the new profile as default
4. Open Outlook
5. Confirm mailbox sync

If the new profile works, the old profile was likely corrupted.

## 13. Check Shared Mailbox Access

If the issue involves a shared mailbox, verify:

- User has Full Access permission
- User has Send As permission if needed
- User has Send on Behalf permission if needed
- Shared mailbox appears in Outlook web
- User restarted Outlook after permission changes

Permission changes may take time to apply.

## 14. Check Mailbox Size and Sync Issues

If Outlook is slow or not syncing:

- Check mailbox size
- Check local OST file size
- Confirm cached mode settings
- Test Outlook web
- Restart Outlook
- Rebuild profile if needed

If Outlook web is current but desktop is stale, the issue is local sync/profile related.

## 15. Check Microsoft 365 Service Health

If multiple users are affected, check Microsoft 365 service health.

Look for issues affecting:

- Exchange Online
- Outlook on the web
- Microsoft 365 authentication
- Teams calendar integration
- Microsoft 365 admin center access

If service degradation exists, document it in GLPI and monitor for resolution.

## 16. Mobile Outlook Checks

If the issue is on mobile only:

- Confirm internet access
- Confirm app is updated
- Remove and re-add the account
- Confirm MFA approval works
- Check device compliance if required
- Confirm the same mailbox works on web

If mobile app fails but web works, the issue is likely local to the mobile app or device.

## 17. Escalation Criteria

Escalate to Microsoft 365 Administrator or Systems Administrator if:

- Multiple users are affected
- Exchange Online service issue is suspected
- User has correct license but mailbox is missing
- Shared mailbox permissions are not applying
- Outlook profile rebuild fails
- Authentication or MFA errors continue
- Mail flow issue affects business operations
- User receives compliance, retention, or security policy errors

## Resolution Notes Template

Use this format in GLPI:

```text
Verified user identity and confirmed the Outlook/mailbox issue scope. Tested Outlook web access to determine whether the issue was service-side or local to the desktop client. Reviewed account status, license assignment, mailbox availability, and MFA status where applicable. Cleared cached credentials, restarted Outlook, and created a new Outlook profile if needed. User confirmed mailbox access and email sync were restored.
```

## GLPI Ticket Example

| Field | Value |
|---|---|
| Type | Incident |
| Category | Email / Microsoft 365 |
| Priority | Medium |
| Title | Outlook mailbox access issue |

Ticket description:

```text
User reports Outlook desktop repeatedly prompts for password and does not load mailbox. Verified Outlook web access, confirmed Microsoft 365 account and mailbox status, cleared cached Windows credentials, restarted Outlook, and tested mailbox synchronization. User confirmed Outlook desktop access was restored.
```

## Prevention

Recommended prevention steps:

- Keep Outlook and Microsoft 365 apps updated
- Train users to update saved passwords after password changes
- Document shared mailbox access requirements
- Review license assignment during onboarding
- Use MFA documentation for sign-in issues
- Monitor repeated Outlook credential prompts
- Check Microsoft 365 service health during multi-user incidents

## Skills Demonstrated

This runbook demonstrates:

- Outlook troubleshooting
- Microsoft 365 support workflow
- Exchange Online mailbox troubleshooting
- Credential cache remediation
- License and mailbox validation
- Shared mailbox access review
- Network connectivity testing
- Help desk documentation
- Escalation decision-making