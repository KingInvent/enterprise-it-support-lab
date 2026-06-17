# Sample Ticket 04: Mapped Company Drive Missing

## Ticket Summary

| Field | Value |
|---|---|
| Ticket ID | INC-004 |
| Type | Incident |
| Category | File Access |
| Priority | Medium |
| Status | Resolved |
| User | Maria Gonzalez |
| Department | Sales |
| System | Group Policy / File Share |
| Related Runbook | `troubleshooting-runbooks/mapped-drive-missing.md` |
| Related GPO | `GPO - Map Company Drive` |
| Company Share | `\\vm-bt-dc01\Company` |
| Drive Letter | `S:` |

## Issue Description

Maria Gonzalez from the Sales department reported that the company shared drive was missing after signing in to her workstation.

The user expected the company drive to appear as the `S:` drive, but it was not visible in File Explorer.

## Business Impact

The user could not access shared company files required for daily Sales operations.

Impact:

- Company shared drive unavailable
- Shared files inaccessible
- User productivity affected
- Possible Group Policy or network dependency issue

## Initial Triage

The following information was collected:

| Question | Answer |
|---|---|
| Is the user onsite or remote? | Remote |
| Is the user connected to VPN? | Needs validation |
| Is the issue affecting multiple users? | No |
| Does the user see the drive with a red X? | No, drive is missing |
| Can the user access the share manually? | Needs validation |
| Expected drive letter | `S:` |
| Expected share path | `\\vm-bt-dc01\Company` |

## Troubleshooting Steps

## 1. Verified User and Device Details

Confirmed the affected user:

```text
Name: Maria Gonzalez
Username: mgonzalez
Department: Sales
Issue: Company drive S: missing
Expected share: \\vm-bt-dc01\Company
```

## 2. Confirmed VPN / Network Connectivity

Because the user was remote, VPN connectivity was reviewed first.

If the user is remote and not connected to VPN, the mapped drive may not appear because the workstation cannot reach internal domain resources.

Related runbook:

```text
troubleshooting-runbooks/vpn-not-connecting.md
```

## 3. Tested Manual Share Access

The user was asked to open File Explorer and manually enter:

```text
\\vm-bt-dc01\Company
```

Possible results:

| Result | Meaning |
|---|---|
| Share opens successfully | GPO drive mapping issue |
| Access denied | Permission issue |
| Network path not found | DNS, VPN, or network issue |
| Credential prompt appears | Cached credential or authentication issue |

## 4. Confirmed DNS and Server Connectivity

The file share depends on internal DNS resolution and connectivity to the domain controller.

Example DNS test:

```powershell
nslookup vm-bt-dc01
```

Expected result:

```text
10.0.0.4
```

Example connectivity test:

```powershell
Test-NetConnection vm-bt-dc01 -Port 445
```

Expected result:

```text
TcpTestSucceeded : True
```

## 5. Reviewed Group Policy Drive Mapping

The mapped drive is deployed through Group Policy.

Configured GPO:

```text
GPO - Map Company Drive
```

Configured share:

```text
\\vm-bt-dc01\Company
```

Configured drive letter:

```text
S:
```

The GPO is linked under:

```text
BlancoTech → Users
```

## 6. Forced Group Policy Update

On the affected workstation, Group Policy would be refreshed using:

```powershell
gpupdate /force
```

The user would then sign out and sign back in.

If needed, the workstation would be restarted.

## 7. Checked Applied Group Policies

The applied policies would be reviewed using:

```powershell
gpresult /r
```

The expected result is that `GPO - Map Company Drive` appears under applied user policies.

If the GPO does not apply, possible causes include:

- User is outside the scoped OU
- GPO link issue
- Security filtering issue
- Domain connectivity issue
- VPN not connected
- DNS resolution issue

## 8. Manually Mapped Drive for Testing

For testing, the drive can be mapped manually:

```powershell
net use S: \\vm-bt-dc01\Company
```

If manual mapping works, the file share and permissions are likely valid, and the issue is probably Group Policy application.

If manual mapping fails, the error should be used to determine whether the issue is permissions, DNS, VPN, or share availability.

## 9. Cleared Stale Drive Mapping if Needed

If a stale or broken mapping exists, remove it:

```powershell
net use S: /delete
```

Then refresh Group Policy again:

```powershell
gpupdate /force
```

## 10. Confirmed Access Restored

After remediation, the user confirmed:

- `S:` drive appeared in File Explorer
- `\\vm-bt-dc01\Company` opened successfully
- Shared files were accessible
- No credential prompt or access denied error appeared

## Resolution

The mapped drive issue was investigated by validating VPN/network connectivity, DNS resolution, SMB access, Group Policy drive mapping, and manual share access.

The company drive mapping was restored after confirming access to the internal share and refreshing Group Policy.

## Resolution Notes

```text
Verified user identity and confirmed the company mapped drive was missing. Tested manual access to \\vm-bt-dc01\Company and reviewed VPN/network connectivity. Confirmed DNS resolution and SMB connectivity where applicable. Reviewed mapped drive Group Policy configuration and verified expected drive letter S:. Forced Group Policy update, had the user sign out and back in, and confirmed the Company Drive was visible and accessible.
```

## Root Cause

Likely Group Policy drive mapping did not apply because of VPN/domain connectivity timing or a temporary mapped drive refresh issue.

## Preventive Action

Recommended actions:

- Ensure users connect to VPN before accessing internal drives
- Keep mapped drive configuration controlled through Group Policy
- Document company share paths and drive letters
- Review GPO scope after OU changes
- Monitor recurring mapped drive issues
- Confirm VPN and DNS health for remote users

## Related Evidence

| Evidence | Location |
|---|---|
| Mapped drive runbook | `troubleshooting-runbooks/mapped-drive-missing.md` |
| Mapped drive GPO screenshot | `screenshots/gpo-mapped-drive-settings.png` |
| GPO linked users OU screenshot | `screenshots/gpo-linked-users-ou.png` |
| Network test script | `powershell/Test-NetworkConnectivity.ps1` |
| Network validation screenshot | `screenshots/powershell-network-test-output.png` |
| GLPI sample tickets screenshot | `screenshots/glpi-sample-tickets.png` |

## Skills Demonstrated

This ticket demonstrates:

- File share troubleshooting
- Group Policy validation
- Mapped drive support
- VPN dependency awareness
- DNS and SMB connectivity testing
- Windows user support
- Help desk ticket documentation
- Escalation awareness
- User communication and follow-up