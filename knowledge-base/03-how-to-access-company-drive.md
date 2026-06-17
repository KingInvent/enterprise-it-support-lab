# Knowledge Base Article 03: How to Access the Company Drive

## Purpose

This article explains how BlancoTech Solutions users should access the company shared drive.

The company drive is used to access shared internal files and department resources.

## Applies To

This guide applies to:

- Company shared drive access
- Mapped drives
- File Explorer
- Remote users connected to VPN
- Windows laptops
- Internal file share access

## Company Drive Details

| Item | Value |
|---|---|
| Drive name | Company Drive |
| Drive letter | `S:` |
| Network path | `\\vm-bt-dc01\Company` |
| Access method | Group Policy mapped drive |
| Required access | Domain user access |
| Remote access requirement | VPN connection |

## When to Use This Article

Use this article if:

- You need to access the company shared drive
- The `S:` drive is missing
- The drive shows a red X
- You cannot open the company shared folder
- You receive an access denied message
- You are remote and cannot access shared files
- You recently changed your password and the drive no longer works

## Before You Start

Confirm the following:

1. You are signed in to your company account.
2. Your computer is connected to the internet.
3. If remote, you are connected to VPN.
4. You are using your current company password.
5. You have permission to access the shared drive.
6. Your computer has been restarted recently.

## How to Access the Company Drive

Open File Explorer and check for the mapped drive:

```text
S: Company Drive
```

If the drive appears, double-click it to open the shared folder.

## How to Open the Drive Manually

If the `S:` drive does not appear, open File Explorer and enter this path in the address bar:

```text
\\vm-bt-dc01\Company
```

If the folder opens manually, the shared drive is reachable, but the mapped drive may not have applied correctly.

## If You Are Working Remotely

You must connect to VPN before accessing the company drive.

Steps:

1. Connect to the internet.
2. Open the VPN client.
3. Sign in with your company username and password.
4. Complete MFA if prompted.
5. Wait until VPN shows connected.
6. Open File Explorer.
7. Try the company drive again.

Network path:

```text
\\vm-bt-dc01\Company
```

## If the Drive Is Missing

Try these steps:

1. Confirm VPN is connected if remote.
2. Restart File Explorer or the computer.
3. Sign out and sign back in.
4. Open the drive manually using the network path.
5. Contact IT if the drive still does not appear.

Expected drive:

```text
S: Company Drive
```

Expected path:

```text
\\vm-bt-dc01\Company
```

## If the Drive Shows a Red X

A red X usually means the drive is mapped but not currently connected.

Try:

1. Double-click the drive.
2. Confirm VPN is connected if remote.
3. Wait a few seconds for the drive to reconnect.
4. Restart the computer if needed.
5. Open the drive manually using the network path.

## If You Receive Access Denied

Access denied usually means your account does not have permission to open the folder.

Do not try to use another user’s account.

Contact IT support and provide:

| Information Needed | Example |
|---|---|
| Full name | Maria Gonzalez |
| Department | Sales |
| Folder path | `\\vm-bt-dc01\Company` |
| Error message | Access denied |
| Remote or onsite? | Remote |
| VPN connected? | Yes |

## If You Recently Changed Your Password

If you changed your password recently, Windows may still have your old password saved.

This can affect:

- Company drive
- VPN
- Outlook
- Teams
- OneDrive
- Browser sign-ins

Clear old saved credentials if needed.

Path:

```text
Control Panel → Credential Manager → Windows Credentials
```

Remove old saved credentials related to:

```text
vm-bt-dc01
blancotech.local
Company share
mapped drives
VPN
```

Then restart the computer and sign in again with your current password.

## Common Issues

| Symptom | Possible Cause |
|---|---|
| `S:` drive missing | Group Policy did not apply or VPN is disconnected |
| Red X on drive | Drive mapped but not connected |
| Access denied | Permission issue |
| Network path not found | VPN, DNS, or network issue |
| Credential prompt appears | Cached password or authentication issue |
| Drive works onsite but not remote | VPN issue |

## When to Contact IT Support

Contact IT support if:

- The `S:` drive is missing after restart
- You cannot open `\\vm-bt-dc01\Company`
- You receive access denied
- VPN is connected but the drive still fails
- The drive worked before and suddenly disappeared
- Other users are also missing the drive
- You recently changed departments and lost access

## What to Include in the Ticket

Include:

| Information Needed | Example |
|---|---|
| Full name | Maria Gonzalez |
| Department | Sales |
| Computer name | Company laptop |
| Drive affected | `S:` |
| Network path | `\\vm-bt-dc01\Company` |
| Error message | Network path not found |
| Remote or onsite? | Remote |
| VPN connected? | Yes |

## Security Reminders

Do not:

- Share files with unauthorized users
- Use someone else’s account to access files
- Store company files on personal cloud storage
- Change folder permissions without approval
- Save company files on public computers
- Ignore access denied errors

Report unusual access issues to IT.

## Related Articles

| Article | Location |
|---|---|
| Mapped drive troubleshooting runbook | `troubleshooting-runbooks/mapped-drive-missing.md` |
| VPN connection article | `knowledge-base/02-how-to-connect-to-vpn.md` |
| DNS troubleshooting runbook | `troubleshooting-runbooks/dns-resolution-issue.md` |
| Password reset article | `knowledge-base/01-how-to-reset-password.md` |

## For IT Staff

Related systems and workflows:

- Group Policy mapped drive configuration
- SMB file share access
- VPN dependency validation
- DNS resolution testing
- User permission review
- GLPI ticket documentation

Related lab evidence:

| Evidence | Location |
|---|---|
| Mapped drive sample ticket | `sample-tickets/04-mapped-drive-missing.md` |
| Mapped drive runbook | `troubleshooting-runbooks/mapped-drive-missing.md` |
| Mapped drive GPO screenshot | `screenshots/gpo-mapped-drive-settings.png` |
| GPO linked users OU screenshot | `screenshots/gpo-linked-users-ou.png` |
| Network test script | `powershell/Test-NetworkConnectivity.ps1` |
| Network test screenshot | `screenshots/powershell-network-test-output.png` |