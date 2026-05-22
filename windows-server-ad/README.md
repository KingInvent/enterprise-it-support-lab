# Windows Server Active Directory Lab

## Overview

This section documents the Windows Server and Active Directory portion of the Hybrid Enterprise IT Support & Systems Administration Lab.

The goal is to simulate a traditional business directory environment for BlancoTech Solutions and demonstrate hands-on administration of Active Directory Domain Services, DNS, organizational units, users, groups, access-control structure, password policy, account lockout policy, and Group Policy Objects.

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

## Password and Account Lockout Policy

The default domain password policy was configured for BlancoTech users.

| Setting | Value |
|---|---:|
| Minimum password length | 12 characters |
| Password complexity | Enabled |
| Password history | 10 passwords remembered |
| Maximum password age | 90 days |
| Minimum password age | 1 day |
| Account lockout threshold | 5 failed attempts |
| Lockout duration | 15 minutes |
| Lockout observation window | 15 minutes |
| Reversible encryption | Disabled |

Validation command used:

    Get-ADDefaultDomainPasswordPolicy

Screenshot:

![Password and Account Lockout Policy](../screenshots/gpo-password-policy.png)

## Group Policy Objects

Three Group Policy Objects were created and linked to the BlancoTech `Users` OU.

| GPO | Purpose |
|---|---|
| GPO - User Screen Lock Policy | Locks user sessions after 15 minutes of inactivity |
| GPO - Block USB Storage | Blocks access to removable storage devices |
| GPO - Map Company Drive | Maps a shared company drive for users |

Validation command used:

    Get-GPO -All | Select-Object DisplayName, GpoStatus | Sort-Object DisplayName

Screenshot:

![GPO List](../screenshots/gpo-list.png)

## Linked GPOs

The GPOs were linked to:

    OU=Users,OU=BlancoTech,DC=blancotech,DC=local

Screenshot:

![Linked GPOs on Users OU](../screenshots/gpo-linked-users-ou.png)

## Screen Lock Policy

The screen lock GPO was configured under:

    User Configuration
    └── Policies
        └── Administrative Templates
            └── Control Panel
                └── Personalization

Configured settings:

| Setting | Value |
|---|---|
| Enable screen saver | Enabled |
| Password protect the screen saver | Enabled |
| Screen saver timeout | 900 seconds |

Screenshot:

![Screen Lock GPO Settings](../screenshots/gpo-screen-lock-settings.png)

## USB Storage Restriction Policy

The USB storage restriction GPO was configured under:

    User Configuration
    └── Policies
        └── Administrative Templates
            └── System
                └── Removable Storage Access

Configured setting:

| Setting | Value |
|---|---|
| All Removable Storage classes: Deny all access | Enabled |

This blocks users from reading from or writing to removable storage devices such as USB flash drives and external USB hard drives.

Screenshot:

![USB Block GPO Settings](../screenshots/gpo-usb-block-settings.png)

## Mapped Drive Policy

A shared company folder was created and mapped to users through Group Policy Preferences.

Shared folder:

    C:\Shares\Company

Network path:

    \\vm-bt-dc01\Company

Mapped drive configuration:

| Setting | Value |
|---|---|
| Drive letter | S: |
| Location | \\vm-bt-dc01\Company |
| Label | Company Drive |
| Reconnect | Enabled |

Screenshot:

![Mapped Drive GPO Settings](../screenshots/gpo-mapped-drive-settings.png)

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
- Default domain password policy configuration
- Account lockout policy configuration
- Group Policy Object creation and linking
- Screen lock enforcement through GPO
- Removable storage restriction through GPO
- Mapped drive deployment through Group Policy Preferences
- SMB share creation for company drive mapping
- Screenshot-backed technical documentation

## Next Improvements

Planned additions:

- DNS/DHCP documentation
- Delegated password reset permissions
- AD security audit findings
- PowerShell automation scripts for onboarding and offboarding
