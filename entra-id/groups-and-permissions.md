# Groups and Permissions Design

## Objective

Document how user access is organized using department-based groups and role-based access control in the simulated company environment.

## Business Scenario

BlancoTech Solutions has 75 employees across five departments. IT uses Microsoft Entra ID groups to assign access based on department, role, and business need.

## Access Control Principles

The access model follows these principles:

- Least privilege
- Department-based access
- Role-based access
- Manager approval for sensitive resources
- Group-based permissions instead of direct user permissions
- Regular access review during onboarding, role changes, and offboarding

## Department Groups

| Group Name | Purpose | Example Access |
|---|---|---|
| HR-Users | Human Resources employees | HR SharePoint site, HR Teams channel |
| Finance-Users | Finance employees | Finance SharePoint site, finance printer, accounting app |
| Sales-Users | Sales employees | Sales SharePoint site, CRM access, Sales Teams channel |
| Operations-Users | Operations employees | Operations files, scheduling tools |
| IT-Users | IT staff | IT documentation, ticketing admin access |
| All-Employees | Company-wide access | General Teams, company announcements, shared policies |

## Role-Based Groups

| Group Name | Purpose |
|---|---|
| Managers | Access to manager resources and approval workflows |
| M365-Helpdesk | Limited Microsoft 365 support permissions |
| Intune-Device-Admins | Endpoint management access |
| GLPI-Technicians | Ticket handling and asset management |
| VPN-Users | Remote access permissions |

## Example Access Assignment

| User | Department | Groups |
|---|---|---|
| Jordan Lee | Sales | Sales-Users, All-Employees, VPN-Users |
| Maria Gonzalez | Sales Manager | Sales-Users, Managers, All-Employees, VPN-Users |
| Alan Chen | IT Support | IT-Users, GLPI-Technicians, M365-Helpdesk, All-Employees |
| Priya Shah | Finance | Finance-Users, All-Employees |
| Elena Torres | HR | HR-Users, All-Employees |

## Standard Access Request Process

1. User or manager submits access request.
2. IT reviews requested resource.
3. Manager or resource owner approves access.
4. IT adds user to the correct Entra ID group.
5. IT validates access.
6. Ticket is updated with action taken.
7. User is notified.

## Access Change Example

### Request

Jordan Lee from Sales needs VPN access for remote work.

### IT Action

Add Jordan Lee to the `VPN-Users` group after manager approval.

### Ticket Note

Received manager approval for Jordan Lee to receive VPN access. Added user to VPN-Users group in Entra ID and confirmed access assignment. User notified with VPN setup instructions.

## Permission Review Checklist

- [ ] User is assigned only to required groups
- [ ] Access matches department and role
- [ ] Sensitive access has approval
- [ ] No direct user permissions were assigned when group access is available
- [ ] Ticket includes reason for access
- [ ] Access was validated after assignment

## Escalation Criteria

Escalate to a system administrator or security team if:

- User requests privileged admin access
- Access request involves financial, HR, or confidential data
- Group membership does not apply correctly
- User has access beyond their job role
- Access request is missing manager approval
