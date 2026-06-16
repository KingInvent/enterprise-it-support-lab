# DNS Resolution Issue Troubleshooting Runbook

## Overview

This runbook documents the troubleshooting process for DNS resolution issues in the BlancoTech Solutions Active Directory environment.

DNS issues can prevent users and systems from accessing domain resources, mapped drives, internal applications, VPN resources, and authentication services.

In this lab, DNS is hosted on the Windows Server domain controller:

```text
vm-bt-dc01.blancotech.local
```

The domain is:

```text
blancotech.local
```

## Scope

This runbook applies to:

- DNS name resolution failures
- Domain resource access issues
- Mapped drive access failures
- VPN users unable to reach internal resources
- Workstations unable to locate domain services
- Internal hostname lookup problems
- Active Directory DNS troubleshooting

## Related Systems

| System | Purpose |
|---|---|
| Active Directory | Domain identity and authentication |
| DNS Server | Resolves domain and internal hostnames |
| Domain Controller | Hosts AD DS and DNS services |
| Group Policy | Depends on DNS for policy processing |
| SMB/File Sharing | Depends on DNS for mapped drives |
| VPN | Requires DNS for remote internal resource access |
| PowerShell | Used for DNS and connectivity testing |
| GLPI | Ticket tracking and documentation |

## Related Lab Evidence

| Evidence | Location |
|---|---|
| DNS audit screenshot | `screenshots/ad-dns-audit.png` |
| DNS zones screenshot | `screenshots/ad-dns-zones.png` |
| Network test script | `powershell/Test-NetworkConnectivity.ps1` |
| Network test screenshot | `screenshots/powershell-network-test-output.png` |
| Domain controller | `vm-bt-dc01.blancotech.local` |
| Domain | `blancotech.local` |
| Domain controller IP | `10.0.0.4` |

## Symptoms

User or administrator may report:

- Internal websites do not load
- Mapped drives do not connect
- VPN connects but internal resources are unreachable
- Domain login is slow
- Group Policy does not apply
- `\\vm-bt-dc01\Company` does not open
- Hostname lookup fails
- User can reach IP address but not hostname
- Workstation cannot find domain controller

## Initial Questions

Ask or verify:

1. Is the issue affecting one user or multiple users?
2. Is the user onsite or remote?
3. Is the user connected to VPN?
4. Can the user access the internet?
5. Can the user access internal resources by IP address?
6. Can the user access internal resources by hostname?
7. Did the issue begin after a network, VPN, or password change?
8. Are mapped drives, login, or Group Policy also affected?

## Priority

| Condition | Priority |
|---|---|
| Single user DNS issue with workaround | Medium |
| Single user blocked from internal resources | High |
| Multiple users affected | Critical |
| Domain-wide DNS failure | Critical |
| Domain controller DNS service unavailable | Critical |

## Troubleshooting Steps

## 1. Confirm the Affected Resource

Identify what the user cannot access.

Examples:

```text
blancotech.local
vm-bt-dc01
vm-bt-dc01.blancotech.local
\\vm-bt-dc01\Company
```

Determine whether the issue is:

- One hostname
- One user
- One workstation
- One network segment
- Remote/VPN only
- Domain-wide

## 2. Confirm Basic Network Connectivity

Before troubleshooting DNS, confirm the device has network access.

Test internet access:

```powershell
Test-Connection 8.8.8.8 -Count 4
```

If this fails, troubleshoot network connectivity first.

If this works but hostnames fail, DNS is more likely.

## 3. Check DNS Server Assignment

On the affected Windows workstation, run:

```powershell
ipconfig /all
```

Review:

| Field | Expected |
|---|---|
| IPv4 Address | Valid local or VPN IP |
| Default Gateway | Present |
| DNS Servers | Internal DNS server when on domain/VPN |
| Connection-specific DNS suffix | Domain/VPN suffix if applicable |

In this lab, the internal DNS server is the domain controller:

```text
10.0.0.4
```

If the workstation is using only a public DNS server, such as `8.8.8.8` or `1.1.1.1`, it may not resolve internal domain resources.

## 4. Test Domain Name Resolution

Run:

```powershell
nslookup blancotech.local
```

Expected result:

```text
Name: blancotech.local
Address: 10.0.0.4
```

If this fails, test against the domain controller IP directly:

```powershell
nslookup blancotech.local 10.0.0.4
```

Interpretation:

| Result | Meaning |
|---|---|
| Works with default DNS | DNS client settings likely correct |
| Works only with `10.0.0.4` | Workstation DNS server assignment issue |
| Fails with `10.0.0.4` | DNS server or DNS zone issue |
| Times out | DNS server unreachable or blocked |

## 5. Test Domain Controller Hostname Resolution

Run:

```powershell
nslookup vm-bt-dc01
```

Then test the fully qualified domain name:

```powershell
nslookup vm-bt-dc01.blancotech.local
```

Expected result should resolve to:

```text
10.0.0.4
```

If short name fails but FQDN works, check DNS suffix configuration.

## 6. Test Connectivity to the DNS Server

Run:

```powershell
Test-Connection 10.0.0.4 -Count 4
```

Then test DNS port access:

```powershell
Test-NetConnection 10.0.0.4 -Port 53
```

Expected result:

```text
TcpTestSucceeded : True
```

If DNS port 53 fails, check:

- VPN routing
- Firewall
- DNS service availability
- Domain controller availability
- Network security rules

## 7. Flush Local DNS Cache

On the affected workstation, clear cached DNS entries:

```powershell
ipconfig /flushdns
```

Then retry:

```powershell
nslookup vm-bt-dc01.blancotech.local
```

If resolution works after clearing cache, the issue may have been stale DNS data.

## 8. Renew IP Configuration

If DNS server assignment appears wrong, renew the network configuration.

Run:

```powershell
ipconfig /release
ipconfig /renew
```

Then confirm DNS settings again:

```powershell
ipconfig /all
```

For remote users, reconnect VPN after renewing network settings.

## 9. Test Internal Resource Access

After DNS resolution works, test internal resource access:

```text
\\vm-bt-dc01\Company
```

If DNS works but the share does not open, follow the mapped drive troubleshooting runbook.

If VPN is disconnected, follow the VPN troubleshooting runbook.

## 10. Use the Lab Network Test Script

Use the network test script for structured validation:

```powershell
cd C:\Lab\enterprise-it-support-lab-main\powershell

.\Test-NetworkConnectivity.ps1 -Target "blancotech.local" -Port 53
```

Also test the domain controller hostname:

```powershell
.\Test-NetworkConnectivity.ps1 -Target "vm-bt-dc01" -Port 53
```

Review:

| Check | Purpose |
|---|---|
| Local IP | Confirms network adapter details |
| Gateway | Confirms routing |
| DNS servers | Confirms DNS configuration |
| Ping test | Checks reachability |
| DNS resolution | Confirms hostname lookup |
| TCP port test | Confirms DNS service access |

## 11. Check DNS Service on the Domain Controller

On the domain controller, confirm the DNS service is running:

```powershell
Get-Service DNS
```

Expected status:

```text
Running
```

If stopped, start it:

```powershell
Start-Service DNS
```

## 12. Confirm DNS Server Role Is Installed

On the domain controller, run:

```powershell
Get-WindowsFeature DNS
```

Expected result:

```text
Installed
```

This was validated in the lab during the Active Directory and DNS audit phase.

## 13. Review DNS Zones

On the domain controller, review DNS zones:

```powershell
Get-DnsServerZone
```

Expected lab zones include:

```text
_msdcs.blancotech.local
blancotech.local
0.in-addr.arpa
127.in-addr.arpa
255.in-addr.arpa
```

If the `blancotech.local` zone is missing, domain DNS is misconfigured.

## 14. Check DNS Records

Check whether the domain controller has an A record:

```powershell
Get-DnsServerResourceRecord -ZoneName "blancotech.local" -Name "vm-bt-dc01"
```

Expected record:

```text
vm-bt-dc01 → 10.0.0.4
```

If the record is missing or incorrect, update DNS records carefully.

## 15. Restart DNS Client Service

On the affected workstation, restart the DNS Client service if needed:

```powershell
Restart-Service Dnscache
```

If the command fails due permissions, restart the workstation.

## 16. Confirm Group Policy Dependency

DNS problems can also affect Group Policy.

Run:

```powershell
gpupdate /force
```

If Group Policy fails, DNS may be preventing the workstation from locating the domain controller.

Common symptoms:

- Mapped drives not applying
- Login scripts not running
- Policies missing
- Slow logon

## 17. Escalation Criteria

Escalate to Systems Administrator or Network Administrator if:

- Multiple users cannot resolve internal hostnames
- DNS service is stopped or unstable
- Domain zone records are missing
- VPN users cannot receive internal DNS settings
- DNS port 53 is blocked
- Domain controller is unreachable
- Group Policy fails across multiple users
- DNS issue may indicate a broader network outage

## Resolution Notes Template

Use this format in GLPI:

```text
Verified user-reported DNS issue and confirmed affected internal resource. Tested basic network connectivity, DNS server assignment, and hostname resolution using nslookup and PowerShell. Confirmed whether the workstation could resolve blancotech.local and vm-bt-dc01.blancotech.local. Flushed DNS cache and validated connectivity to DNS port 53. Confirmed internal resource access after DNS resolution was restored. Documented findings and escalation path.
```

## GLPI Ticket Example

| Field | Value |
|---|---|
| Type | Incident |
| Category | Network |
| Priority | High |
| Title | DNS resolution issue - internal resources unavailable |

Ticket description:

```text
User reports they can access the internet but cannot access internal resources by hostname. Tested DNS resolution for blancotech.local and vm-bt-dc01.blancotech.local. Verified DNS server assignment, flushed local DNS cache, and tested connectivity to DNS port 53. Internal hostname resolution was restored and user confirmed access to the company share.
```

## Prevention

Recommended prevention steps:

- Ensure domain workstations use internal DNS
- Ensure VPN clients receive internal DNS settings
- Monitor DNS service health
- Document DNS server IP addresses
- Avoid using only public DNS for domain-joined devices
- Maintain accurate DNS records
- Review DNS after domain controller IP or network changes
- Include DNS checks in network troubleshooting runbooks

## Skills Demonstrated

This runbook demonstrates:

- DNS troubleshooting
- Active Directory DNS awareness
- Domain controller validation
- PowerShell network testing
- Internal hostname resolution
- VPN and mapped drive dependency analysis
- Group Policy troubleshooting awareness
- Help desk documentation
- Escalation decision-making