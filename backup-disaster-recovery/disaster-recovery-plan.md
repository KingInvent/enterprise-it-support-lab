# Backup and Disaster Recovery Plan

## Overview

This document outlines the backup and disaster recovery plan for the BlancoTech Solutions hybrid IT lab.

The purpose of this plan is to demonstrate how IT support and systems administration teams protect business continuity by documenting recovery objectives, backup targets, restoration priorities, and incident response steps.

This is a lab-level disaster recovery plan, not a production-grade enterprise backup design.

## Environment

| Item | Value |
|---|---|
| Company | BlancoTech Solutions |
| Domain | `blancotech.local` |
| Domain Controller | `vm-bt-dc01.blancotech.local` |
| Domain Controller IP | `10.0.0.4` |
| Primary Identity Platform | Active Directory |
| Ticketing System | GLPI |
| Documentation Platform | GitHub |
| Automation | PowerShell |
| Local ITSM Deployment | Docker / GLPI |
| Cloud Lab Platform | Azure |

## Disaster Recovery Objectives

The disaster recovery plan focuses on:

- Restoring identity services
- Preserving user and group data
- Maintaining access to documentation
- Recovering ticketing and support records
- Restoring PowerShell automation tools
- Rebuilding lab infrastructure if needed
- Reducing downtime during system failure
- Creating repeatable recovery steps

## Recovery Priority

| Priority | System / Data | Reason |
|---|---|---|
| 1 | Active Directory / Domain Controller | Required for authentication, users, groups, DNS, and Group Policy |
| 2 | DNS | Required for domain resource resolution |
| 3 | PowerShell scripts | Required for automation and support workflows |
| 4 | GLPI ticketing data | Required for ticket history and ITSM records |
| 5 | GitHub documentation | Required for rebuild instructions and evidence |
| 6 | Screenshots / evidence | Required for portfolio and validation records |
| 7 | Knowledge base and runbooks | Required for support continuity |

## Recovery Time and Recovery Point Objectives

| System | Recovery Time Objective | Recovery Point Objective |
|---|---:|---:|
| Active Directory lab | 4–8 hours | Last documented configuration |
| DNS configuration | 2–4 hours | Last documented configuration |
| GLPI local deployment | 2–4 hours | Last Docker volume backup |
| PowerShell scripts | Less than 1 hour | Latest GitHub commit |
| Documentation | Less than 1 hour | Latest GitHub commit |
| Screenshots / evidence | Less than 1 hour | Latest GitHub commit |
| Knowledge base | Less than 1 hour | Latest GitHub commit |

## Backup Targets

The following items should be backed up or preserved.

| Item | Backup Method |
|---|---|
| GitHub repository | Remote GitHub repository |
| Markdown documentation | GitHub commits |
| PowerShell scripts | GitHub commits |
| Screenshots | GitHub repository |
| GLPI Docker Compose files | GitHub repository |
| GLPI `.env.example` | GitHub repository |
| GLPI `.env` | Local secure storage only |
| GLPI database volume | Docker volume backup |
| GLPI application volume | Docker volume backup |
| Azure VM configuration | Azure Portal screenshots and documentation |
| Active Directory configuration | Markdown documentation and screenshots |

## GitHub Backup Strategy

GitHub is used as the primary backup location for documentation, scripts, screenshots, and project evidence.

Protected content includes:

- Project README
- Architecture documentation
- Active Directory documentation
- Group Policy documentation
- PowerShell scripts
- GLPI documentation
- Troubleshooting runbooks
- Sample tickets
- Knowledge base articles
- Security baseline documentation
- Screenshots

Git commands used:

```bash
git status
git add .
git commit -m "Descriptive commit message"
git push
```

## Local Repository Recovery

If the local project folder is lost, recover it from GitHub.

Recovery command:

```bash
cd ~/Desktop

git clone https://github.com/KingInvent/enterprise-it-support-lab.git
```

Then open it in VS Code:

```bash
open -a "Visual Studio Code" ~/Desktop/enterprise-it-support-lab
```

## Active Directory Recovery Strategy

The Active Directory lab is documented so it can be rebuilt if the Azure VM is lost.

Critical AD components documented:

| Component | Location |
|---|---|
| Domain name | `blancotech.local` |
| Domain controller | `vm-bt-dc01.blancotech.local` |
| OU structure | `windows-server-ad/README.md` |
| Users | `windows-server-ad/README.md` |
| Groups | `windows-server-ad/README.md` |
| Group memberships | `windows-server-ad/README.md` |
| DNS validation | `windows-server-ad/README.md` |
| Security audit | `security-baseline/README.md` |

Primary recovery approach:

1. Create new Windows Server VM if needed.
2. Install Active Directory Domain Services.
3. Promote server to domain controller.
4. Recreate domain `blancotech.local`.
5. Recreate OU structure.
6. Recreate users and security groups.
7. Reapply Group Policy settings.
8. Validate DNS.
9. Run PowerShell audit scripts.
10. Capture updated screenshots.

## Domain Controller Recovery

If `vm-bt-dc01` is unavailable, first determine whether the issue is temporary or permanent.

## Temporary Outage

Examples:

- VM stopped
- Azure resource unavailable
- Network issue
- RDP unavailable
- DNS service stopped

Recovery steps:

1. Check Azure VM status.
2. Start the VM if deallocated.
3. Confirm private IP remains `10.0.0.4`.
4. Confirm DNS service is running.
5. Confirm AD DS service health.
6. Validate domain resolution.
7. Run basic AD checks.

Validation commands:

```powershell
Get-ADDomain
Get-ADDomainController
Get-WindowsFeature DNS,AD-Domain-Services
Get-Service DNS
```

DNS validation:

```powershell
nslookup blancotech.local
nslookup vm-bt-dc01.blancotech.local
```

## Permanent Loss

Examples:

- VM deleted
- Disk corrupted
- Domain controller unrecoverable
- Azure subscription issue

Recovery steps:

1. Rebuild Windows Server VM.
2. Reinstall AD DS and DNS.
3. Recreate `blancotech.local`.
4. Recreate OU structure.
5. Recreate users and groups from documentation.
6. Recreate GPOs from documented settings.
7. Recreate file share.
8. Run audit scripts.
9. Update screenshots and documentation.

## DNS Recovery

DNS is hosted on the domain controller.

Expected zones:

```text
_msdcs.blancotech.local
blancotech.local
0.in-addr.arpa
127.in-addr.arpa
255.in-addr.arpa
```

Validation command:

```powershell
Get-DnsServerZone
```

Expected domain controller record:

```text
vm-bt-dc01 → 10.0.0.4
```

Validation command:

```powershell
Get-DnsServerResourceRecord -ZoneName "blancotech.local" -Name "vm-bt-dc01"
```

If DNS fails:

1. Confirm DNS service is running.
2. Confirm DNS role is installed.
3. Confirm zones exist.
4. Confirm domain controller record exists.
5. Confirm clients use internal DNS.
6. Test name resolution.

Related runbook:

```text
troubleshooting-runbooks/dns-resolution-issue.md
```

## Group Policy Recovery

The following Group Policy controls must be recreated if the domain is rebuilt.

| Policy | Purpose |
|---|---|
| Domain password policy | Password and lockout standards |
| `GPO - User Screen Lock Policy` | Enforces screen lock timeout |
| `GPO - Block USB Storage` | Restricts removable storage |
| `GPO - Map Company Drive` | Maps company shared drive |

Evidence:

| Evidence | Location |
|---|---|
| Password policy | `screenshots/gpo-password-policy.png` |
| Screen lock GPO | `screenshots/gpo-screen-lock-settings.png` |
| USB block GPO | `screenshots/gpo-usb-block-settings.png` |
| Mapped drive GPO | `screenshots/gpo-mapped-drive-settings.png` |
| GPO link | `screenshots/gpo-linked-users-ou.png` |

## File Share Recovery

The company shared drive uses:

```text
\\vm-bt-dc01\Company
```

Drive letter:

```text
S:
```

Local server path:

```text
C:\Shares\Company
```

Recovery steps:

1. Recreate folder.
2. Recreate SMB share.
3. Apply share permissions.
4. Apply NTFS permissions.
5. Recreate mapped drive GPO.
6. Test from a user session.

Example commands:

```powershell
New-Item -Path "C:\Shares\Company" -ItemType Directory -Force

New-SmbShare -Name "Company" -Path "C:\Shares\Company" -FullAccess "BLANCOTECH\Domain Admins" -ChangeAccess "BLANCOTECH\Domain Users"
```

Validation:

```powershell
Get-SmbShare -Name Company
Get-SmbShareAccess -Name Company
```

Related runbook:

```text
troubleshooting-runbooks/mapped-drive-missing.md
```

## PowerShell Script Recovery

PowerShell scripts are stored in GitHub.

Location:

```text
powershell/
```

Scripts:

| Script | Purpose |
|---|---|
| `Create-NewHireUser.ps1` | New hire account creation |
| `Disable-OffboardedUser.ps1` | Offboarding and access removal |
| `Export-ADUserReport.ps1` | AD user reporting |
| `Get-GroupMembershipReport.ps1` | Group membership reporting |
| `Find-LockedOutUsers.ps1` | Locked-out user detection |
| `Test-NetworkConnectivity.ps1` | Network and DNS testing |

Recovery steps:

1. Clone GitHub repository.
2. Copy scripts to the Windows Server lab path.
3. Open PowerShell as Administrator.
4. Validate execution policy.
5. Run scripts against the rebuilt domain.
6. Confirm reports and logs are generated.

Example path:

```text
C:\Lab\enterprise-it-support-lab-main\powershell
```

## GLPI Recovery

GLPI was deployed locally using Docker Compose.

Docker path:

```text
glpi-ticketing/docker/
```

Important files:

| File | Purpose |
|---|---|
| `docker-compose.yml` | Defines GLPI and MariaDB containers |
| `.env.example` | Safe example environment variables |
| `.env` | Local database credentials, not committed |
| Docker volumes | Store GLPI application and database data |

Start GLPI:

```bash
cd ~/Desktop/enterprise-it-support-lab/glpi-ticketing/docker
docker compose up -d
```

Stop GLPI:

```bash
cd ~/Desktop/enterprise-it-support-lab/glpi-ticketing/docker
docker compose down
```

Check status:

```bash
docker compose ps
```

Access GLPI:

```text
http://localhost:8080
```

## GLPI Data Backup

GLPI data is stored in Docker volumes.

Important volumes:

```text
glpi_db_data
glpi_app_data
```

A basic lab backup should preserve:

- MariaDB database data
- GLPI application files
- Docker Compose file
- Environment variable template
- Ticket documentation in GitHub
- Screenshots

For this lab, ticket documentation is also preserved in:

```text
sample-tickets/
glpi-ticketing/setup.md
screenshots/glpi-sample-tickets.png
```

## GLPI Recovery Steps

If GLPI needs to be restored locally:

1. Install Docker Desktop.
2. Clone the GitHub repository.
3. Recreate local `.env` file from `.env.example`.
4. Start containers with Docker Compose.
5. Restore Docker volumes if volume backup is available.
6. Access GLPI at `http://localhost:8080`.
7. Validate ticket categories, assets, and sample tickets.
8. Recreate sample GLPI data manually if volume backup is unavailable.

## Documentation Recovery

Documentation is stored in Markdown and committed to GitHub.

Critical documentation folders:

| Folder | Purpose |
|---|---|
| `windows-server-ad/` | AD and domain documentation |
| `powershell/` | Automation scripts and documentation |
| `glpi-ticketing/` | ITSM setup documentation |
| `troubleshooting-runbooks/` | Support runbooks |
| `sample-tickets/` | Ticket examples |
| `knowledge-base/` | User-facing support articles |
| `security-baseline/` | Security controls |
| `backup-disaster-recovery/` | Recovery planning |
| `screenshots/` | Evidence and validation |

Recovery method:

```bash
git clone https://github.com/KingInvent/enterprise-it-support-lab.git
```

## Backup Schedule

Recommended lab backup schedule:

| Item | Frequency |
|---|---|
| GitHub commits | After every meaningful change |
| Screenshots | After each completed technical task |
| GLPI volume backup | After ticketing changes |
| AD documentation review | After user/group/GPO changes |
| PowerShell scripts | After script edits or validation |
| Security documentation | After control changes |
| README updates | Before final project review |

## Disaster Scenarios

## Scenario 1: Local Mac Project Folder Deleted

Recovery:

1. Clone repository from GitHub.
2. Open in VS Code.
3. Confirm files and screenshots are present.
4. Continue work from latest commit.

Command:

```bash
cd ~/Desktop
git clone https://github.com/KingInvent/enterprise-it-support-lab.git
```

## Scenario 2: Azure Domain Controller Unavailable

Recovery:

1. Check VM status in Azure.
2. Start VM if stopped.
3. Confirm private IP.
4. Test RDP.
5. Validate AD DS and DNS.
6. Run AD audit commands.
7. If unrecoverable, rebuild using documentation.

## Scenario 3: GLPI Containers Stopped

Recovery:

```bash
cd ~/Desktop/enterprise-it-support-lab/glpi-ticketing/docker
docker compose up -d
```

Then access:

```text
http://localhost:8080
```

## Scenario 4: GLPI Docker Data Lost

Recovery:

1. Recreate `.env` file.
2. Restart GLPI containers.
3. Reinstall GLPI if needed.
4. Recreate ticket categories.
5. Recreate sample assets.
6. Recreate sample tickets.
7. Use GitHub documentation as reference.

## Scenario 5: PowerShell Scripts Lost on Windows Server

Recovery:

1. Download or clone GitHub repository.
2. Copy scripts to the lab PowerShell folder.
3. Run validation scripts.
4. Confirm logs and reports are generated.

## Scenario 6: Screenshot Evidence Missing Locally

Recovery:

1. Pull latest repository from GitHub.
2. Check `screenshots/` folder.
3. Recreate screenshots only if missing from GitHub.

Command:

```bash
git pull origin main
```

## Recovery Validation Checklist

After recovery, validate:

| Check | Status |
|---|---|
| Repository cloned successfully | Pending |
| Documentation opens in VS Code | Pending |
| Screenshots are present | Pending |
| PowerShell scripts are present | Pending |
| Docker Compose file is present | Pending |
| GLPI starts successfully | Pending |
| AD documentation is available | Pending |
| Security baseline is available | Pending |
| Runbooks are available | Pending |
| Knowledge base articles are available | Pending |

## Lessons Learned

This lab demonstrates that recovery planning is not only about restoring servers. It also requires:

- Good documentation
- Version control
- Screenshots and evidence
- Repeatable scripts
- Clearly defined recovery priorities
- User support workflows
- Security-aware offboarding
- Ticketing records
- Known system dependencies

## Production Improvements

A production environment would require additional controls:

- Automated VM backups
- System state backups for domain controllers
- Offsite backups
- Immutable backups
- Backup encryption
- Backup monitoring
- Backup restore testing
- Formal RTO/RPO requirements
- High availability domain controllers
- Centralized logging
- SIEM integration
- Documented incident response plan
- Backup access control
- Regular disaster recovery exercises

## Skills Demonstrated

This disaster recovery plan demonstrates:

- Backup planning
- Disaster recovery documentation
- Recovery prioritization
- Active Directory recovery awareness
- DNS dependency awareness
- GLPI recovery planning
- Docker deployment recovery
- GitHub-based documentation recovery
- PowerShell script recovery
- Business continuity thinking
- IT support and systems administration documentation