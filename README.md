# Hybrid Enterprise IT Support and Systems Administration Lab

## Overview

This project is a hands-on IT support and systems administration lab built to simulate a 75-user hybrid company environment.

The lab demonstrates practical skills used in IT Support, Help Desk, Desktop Support, IT Analyst, Junior Systems Administrator, and early Systems Administrator roles.

It includes Active Directory, Group Policy, DNS, PowerShell automation, GLPI ticketing, troubleshooting runbooks, sample tickets, knowledge base articles, security baseline documentation, and backup/disaster recovery planning.

## Fictional Company

| Item | Value |
|---|---|
| Company | BlancoTech Solutions |
| Environment | 75-user hybrid company |
| Departments | HR, Finance, Sales, Operations, IT |
| Domain | `blancotech.local` |
| Domain Controller | `vm-bt-dc01.blancotech.local` |
| Ticketing System | GLPI |
| Documentation | GitHub Markdown |
| Automation | PowerShell |

## Project Goals

The goal of this lab is to demonstrate the ability to:

- Build and document an enterprise-style IT support environment
- Administer Active Directory users, groups, and OUs
- Configure Group Policy for security and user experience controls
- Validate DNS and domain controller functionality
- Automate common IT support tasks with PowerShell
- Deploy and document a GLPI ticketing system
- Write realistic troubleshooting runbooks
- Create user-facing knowledge base articles
- Document sample help desk tickets
- Build security baseline and disaster recovery documentation
- Present technical work clearly for hiring managers and recruiters

## Technologies Used

| Technology | Purpose |
|---|---|
| Microsoft Azure | Windows Server lab hosting |
| Windows Server 2025 | Domain controller, AD DS, DNS, Group Policy |
| Active Directory Domain Services | Users, groups, OUs, authentication |
| DNS Server | Internal domain name resolution |
| Group Policy | Password policy, screen lock, USB block, mapped drive |
| PowerShell | Automation, reporting, troubleshooting |
| Docker Desktop | Local GLPI deployment |
| GLPI | Ticketing, ITSM, assets, categories |
| MariaDB | GLPI database backend |
| GitHub | Version control and project documentation |
| VS Code | Documentation and code editing |

## Repository Structure

```text
enterprise-it-support-lab/
├── README.md
├── architecture/
├── backup-disaster-recovery/
├── entra-id/
├── glpi-ticketing/
├── intune/
├── knowledge-base/
├── microsoft-365/
├── networking/
├── powershell/
├── resume-linkedin/
├── sample-tickets/
├── screenshots/
├── security-baseline/
├── troubleshooting-runbooks/
└── windows-server-ad/
```

## Major Project Phases

| Phase | Status | Documentation |
|---|---:|---|
| Project structure and documentation foundation | Complete | `README.md` |
| Active Directory and Windows Server lab | Complete | `windows-server-ad/README.md` |
| Group Policy configuration | Complete | `windows-server-ad/README.md` |
| DNS and AD security audit | Complete | `windows-server-ad/README.md` |
| PowerShell automation | Complete | `powershell/README.md` |
| GLPI ticketing and ITSM | Complete | `glpi-ticketing/setup.md` |
| Troubleshooting runbooks | Complete | `troubleshooting-runbooks/` |
| Sample tickets | Complete | `sample-tickets/` |
| Knowledge base articles | Complete | `knowledge-base/` |
| Security baseline | Complete | `security-baseline/README.md` |
| Backup and disaster recovery | Complete | `backup-disaster-recovery/disaster-recovery-plan.md` |

## Active Directory Lab

The Windows Server / Active Directory portion of the lab includes:

- Windows Server domain controller
- AD DS installation
- DNS installation
- Domain creation
- OU structure
- Department-based users
- Security groups
- Group memberships
- Disabled Users OU
- AD validation
- DNS validation
- Security audit checks

Documentation:

```text
windows-server-ad/README.md
```

Key lab values:

| Item | Value |
|---|---|
| Domain | `blancotech.local` |
| Domain Controller | `vm-bt-dc01.blancotech.local` |
| Domain Controller IP | `10.0.0.4` |
| NetBIOS | `BLANCOTECH` |

## Active Directory Structure

The lab uses the following OU structure:

```text
BlancoTech
├── Users
│   ├── HR
│   ├── Finance
│   ├── Sales
│   ├── Operations
│   └── IT
├── Groups
├── Computers
├── Servers
└── Disabled Users
```

## Active Directory Users

The lab includes 15 sample users across five departments.

| Department | Users |
|---|---|
| HR | Elena Torres, Rachel Kim, Marcus Brown |
| Finance | Priya Shah, Daniel Rivera, Nina Patel |
| Sales | Jordan Lee, Maria Gonzalez, Chris Evans |
| Operations | Omar Hassan, Sofia Martinez, Liam Walker |
| IT | Alan Chen, Maya Singh, Ethan Brooks |

## Active Directory Groups

Security groups were created to support group-based access control.

| Group | Purpose |
|---|---|
| `All-Employees` | Baseline employee access |
| `HR-Users` | HR department access |
| `Finance-Users` | Finance department access |
| `Sales-Users` | Sales department access |
| `Operations-Users` | Operations department access |
| `IT-Users` | IT department access |
| `Managers` | Manager-level grouping |
| `VPN-Users` | VPN access eligibility |
| `IT-Admins` | Administrative access |
| `Helpdesk-Technicians` | Help desk support access |
| `GLPI-Technicians` | Ticketing technician access |
| `M365-Helpdesk` | Microsoft 365 support access |

## Group Policy Configuration

The lab includes practical Group Policy controls.

| Policy | Purpose |
|---|---|
| Domain password policy | Enforces password and lockout standards |
| `GPO - User Screen Lock Policy` | Requires screen lock after inactivity |
| `GPO - Block USB Storage` | Restricts removable storage |
| `GPO - Map Company Drive` | Maps shared company drive |

Mapped drive configuration:

| Item | Value |
|---|---|
| Share | `\\vm-bt-dc01\Company` |
| Drive Letter | `S:` |
| GPO | `GPO - Map Company Drive` |

## PowerShell Automation

The lab includes six PowerShell scripts for common IT support and systems administration tasks.

Documentation:

```text
powershell/README.md
```

| Script | Purpose |
|---|---|
| `Create-NewHireUser.ps1` | Creates a new Active Directory user and assigns groups |
| `Disable-OffboardedUser.ps1` | Disables user accounts and removes access during offboarding |
| `Export-ADUserReport.ps1` | Exports AD user reports to CSV and HTML |
| `Get-GroupMembershipReport.ps1` | Reports group memberships and access assignments |
| `Find-LockedOutUsers.ps1` | Finds locked-out users and supports unlock workflow |
| `Test-NetworkConnectivity.ps1` | Tests DNS, ping, gateway, and TCP connectivity |

## PowerShell Validation

The scripts were validated in the lab and screenshot evidence was captured.

| Evidence | Screenshot |
|---|---|
| New hire script success | `screenshots/powershell-newhire-script-success.png` |
| New hire user validation | `screenshots/powershell-newhire-user-validation.png` |
| New hire group validation | `screenshots/powershell-newhire-group-validation.png` |
| Offboarding script success | `screenshots/powershell-offboarding-success.png` |
| Offboarding user validation | `screenshots/powershell-offboarding-user-validation.png` |
| Offboarding group validation | `screenshots/powershell-offboarding-group-validation.png` |
| AD user report output | `screenshots/powershell-user-report-output-1.png` |
| Group report output | `screenshots/powershell-group-report-output-1.png` |
| Locked-out users output | `screenshots/powershell-lockedout-output.png` |
| Network test output | `screenshots/powershell-network-test-output.png` |

## GLPI Ticketing and ITSM

GLPI was deployed locally using Docker Compose to demonstrate ITSM and ticketing workflows.

Documentation:

```text
glpi-ticketing/setup.md
```

| Item | Value |
|---|---|
| Application | GLPI |
| Deployment | Docker Compose |
| Database | MariaDB |
| Access URL | `http://localhost:8080` |
| Web Container | `glpi-app` |
| Database Container | `glpi-db` |

GLPI was used to create:

- Ticket categories
- Sample IT assets
- Sample support tickets
- ITSM workflow documentation
- Ticket resolution examples

## GLPI Categories

Ticket categories created:

- Account Access
- Hardware
- Software
- Network
- Email / Microsoft 365
- Printer
- File Access
- Onboarding
- Offboarding
- Security

## GLPI Sample Assets

Sample assets created:

| Asset | Type | Purpose |
|---|---|---|
| `BT-LT-001` | Laptop | HR Manager laptop |
| `BT-LT-002` | Laptop | Sales Manager laptop |
| `BT-LT-003` | Laptop | Finance Manager laptop |
| `BT-LT-004` | Laptop | IT Support Analyst laptop |
| `BT-SRV-DC01` | Server | Domain controller |

## Troubleshooting Runbooks

The project includes 10 troubleshooting runbooks.

Folder:

```text
troubleshooting-runbooks/
```

| Runbook | Purpose |
|---|---|
| `no-internet.md` | Basic network troubleshooting |
| `account-locked-out.md` | AD account lockout support |
| `vpn-not-connecting.md` | VPN troubleshooting |
| `mapped-drive-missing.md` | Mapped drive and file share support |
| `dns-resolution-issue.md` | DNS troubleshooting |
| `printer-offline.md` | Printer support workflow |
| `outlook-mailbox-issue.md` | Outlook / Microsoft 365 mailbox support |
| `mfa-issue.md` | MFA support workflow |
| `slow-computer.md` | Windows performance troubleshooting |
| `phishing-email-report.md` | Phishing report triage and escalation |

## Sample Tickets

The project includes realistic GLPI-style ticket documentation.

Folder:

```text
sample-tickets/
```

| Ticket | Purpose |
|---|---|
| `01-new-hire-onboarding.md` | New hire IT setup |
| `02-account-locked-out.md` | Account lockout incident |
| `03-vpn-connection-failure.md` | VPN connection issue |
| `04-mapped-drive-missing.md` | Missing company drive |
| `05-employee-offboarding.md` | Employee offboarding and access removal |

## Knowledge Base Articles

The project includes user-facing knowledge base articles.

Folder:

```text
knowledge-base/
```

| Article | Purpose |
|---|---|
| `01-how-to-reset-password.md` | User password reset guidance |
| `02-how-to-connect-to-vpn.md` | VPN connection guidance |
| `03-how-to-access-company-drive.md` | Company shared drive access |
| `04-how-to-set-up-mfa.md` | MFA setup guidance |
| `05-how-to-report-phishing-email.md` | Phishing report guidance |

## Security Baseline

The security baseline documents practical controls implemented or supported in the lab.

Documentation:

```text
security-baseline/README.md
```

Covered controls:

- Password policy
- Account lockout policy
- Screen lock policy
- USB storage restriction
- Least privilege access model
- Group-based access control
- MFA support workflow
- Phishing response workflow
- Secure onboarding
- Secure offboarding
- PowerShell audit reporting
- GLPI security ticketing

## Backup and Disaster Recovery

The backup and disaster recovery plan documents recovery priorities and rebuild procedures.

Documentation:

```text
backup-disaster-recovery/disaster-recovery-plan.md
```

Covered areas:

- GitHub repository recovery
- Active Directory recovery
- Domain controller recovery
- DNS recovery
- Group Policy recovery
- File share recovery
- PowerShell script recovery
- GLPI recovery
- Docker recovery
- Documentation recovery

## Screenshots and Evidence

Screenshots are stored in:

```text
screenshots/
```

Key evidence includes:

| Area | Example Evidence |
|---|---|
| Active Directory | OU structure, users, groups |
| Group Policy | Password policy, screen lock, USB block, mapped drive |
| DNS | DNS audit, DNS zones |
| Security Audit | Privileged groups, user security audit |
| PowerShell | Script validation screenshots |
| GLPI | Dashboard, categories, assets, tickets |

## Key Skills Demonstrated

This project demonstrates:

- Active Directory administration
- Windows Server administration
- DNS troubleshooting
- Group Policy configuration
- PowerShell scripting
- User onboarding and offboarding
- Account lockout troubleshooting
- Group membership reporting
- ITSM ticketing with GLPI
- Docker-based application deployment
- Help desk ticket documentation
- Troubleshooting runbook writing
- Knowledge base documentation
- Security baseline planning
- Backup and disaster recovery planning
- Git and GitHub documentation workflow

## Role Alignment

This project is aligned with the following roles:

- IT Support Specialist
- Help Desk Technician
- Service Desk Analyst
- Desktop Support Technician
- IT Support Analyst
- Junior Systems Administrator
- Systems Support Specialist
- Technical Support Analyst

## How to Review This Project

Recommended review path:

1. Start with this README.
2. Review `windows-server-ad/README.md`.
3. Review `powershell/README.md`.
4. Review `glpi-ticketing/setup.md`.
5. Review `troubleshooting-runbooks/`.
6. Review `sample-tickets/`.
7. Review `knowledge-base/`.
8. Review `security-baseline/README.md`.
9. Review `backup-disaster-recovery/disaster-recovery-plan.md`.
10. Review screenshots in `screenshots/`.

## Project Summary

This lab simulates a practical hybrid IT support environment and documents the core workflows expected in real IT operations.

It combines infrastructure setup, automation, ticketing, troubleshooting, security awareness, and documentation into one portfolio project.

The project demonstrates not only technical configuration, but also the ability to document support processes clearly and maintain an organized GitHub-based technical portfolio.