# Windows Server Active Directory Lab

## Overview

This section documents the Windows Server and Active Directory portion of the Hybrid Enterprise IT Support & Systems Administration Lab.

The goal is to simulate a traditional business directory environment for BlancoTech Solutions and demonstrate hands-on administration of Active Directory Domain Services, DNS, organizational units, users, groups, and access-control structure.

## Environment

| Item | Configuration |
|---|---|
| Cloud Platform | Microsoft Azure |
| Server Name | vm-bt-dc01 |
| Operating System | Windows Server 2025 Datacenter |
| Domain | blancotech.local |
| NetBIOS Name | BLANCOTECH |
| Domain Controller IP | 10.0.0.4 |
| Resource Group | rg-blancotech-ad-lab |
| VM Size | Standard B2als v2 |
| Server Role | Domain Controller, DNS Server |

## Domain Controller Setup

The server was promoted to a domain controller using PowerShell.

Validation commands used:

    Get-ADDomain
    Get-ADDomainController
    Get-WindowsFeature DNS, AD-Domain-Services
    nslookup blancotech.local

Confirmed results:

- Domain created: `blancotech.local`
- NetBIOS name configured: `BLANCOTECH`
- Domain controller: `vm-bt-dc01.blancotech.local`
- AD DS installed
- DNS Server installed
- Domain name resolves to `10.0.0.4`

## Organizational Unit Structure

The following OU structure was created for BlancoTech Solutions:

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

Accidental deletion protection was enabled on the custom OUs.

Screenshot:

![Active Directory OU Structure](../screenshots/ad-ou-structure.png)

## Security Groups

The following security groups were created:

| Group | Purpose |
|---|---|
| All-Employees | All BlancoTech employees |
| HR-Users | Human Resources department access |
| Finance-Users | Finance department access |
| Sales-Users | Sales department access |
| Operations-Users | Operations department access |
| IT-Users | IT department access |
| Managers | Managers and department leads |
| VPN-Users | Users approved for VPN access |
| IT-Admins | IT administrators with elevated responsibilities |
| Helpdesk-Technicians | Helpdesk technicians for delegated support tasks |
| GLPI-Technicians | IT staff assigned to GLPI ticket handling |
| M365-Helpdesk | Helpdesk users with Microsoft 365 support responsibilities |

Screenshot:

![Active Directory Security Groups](../screenshots/ad-security-groups.png)

## User Accounts

15 user accounts were created across five departments.

| Department | Users |
|---|---|
| HR | Elena Torres, Rachel Kim, Marcus Brown |
| Finance | Priya Shah, Daniel Rivera, Nina Patel |
| Sales | Jordan Lee, Maria Gonzalez, Chris Evans |
| Operations | Omar Hassan, Sofia Martinez, Liam Walker |
| IT | Alan Chen, Maya Singh, Ethan Brooks |

Each user account includes:

- First name and last name
- Username / SamAccountName
- UserPrincipalName
- Department
- Job title
- Correct department OU placement
- Group-based access assignment
- Enabled account status
- Password change required at next logon

Screenshot:

![Sales Users in Active Directory](../screenshots/ad-sales-users.png)

## Group Membership Validation

Group membership was validated with PowerShell.

    Get-ADPrincipalGroupMembership jlee | Select-Object Name | Sort-Object Name

Jordan Lee was confirmed as a member of:

    All-Employees
    Domain Users
    Sales-Users
    VPN-Users

Maya Singh was confirmed as a member of:

    All-Employees
    Domain Users
    Helpdesk-Technicians
    IT-Admins
    IT-Users
    VPN-Users

Alan Chen was confirmed as a member of:

    All-Employees
    Domain Users
    GLPI-Technicians
    Helpdesk-Technicians
    IT-Users
    M365-Helpdesk
    VPN-Users

## Group Count Validation

PowerShell was used to verify group membership counts.

| Group | Member Count |
|---|---:|
| All-Employees | 15 |
| HR-Users | 3 |
| Finance-Users | 3 |
| Sales-Users | 3 |
| Operations-Users | 3 |
| IT-Users | 3 |
| Managers | 4 |
| VPN-Users | 8 |
| IT-Admins | 1 |
| Helpdesk-Technicians | 3 |
| GLPI-Technicians | 2 |
| M365-Helpdesk | 1 |

## Skills Demonstrated

- Azure Windows Server VM deployment
- Active Directory Domain Services installation
- Domain controller promotion
- DNS role installation and validation
- Static private IP configuration
- OU design
- Department-based user organization
- Security group creation
- Group-based access control
- PowerShell-based user creation
- PowerShell-based validation
- Screenshot-backed technical documentation

## Next Improvements

Planned additions:

- Group Policy Objects
- Password and account lockout policy
- DNS/DHCP documentation
- Delegated password reset permissions
- AD security audit findings
- PowerShell automation scripts for onboarding and offboarding