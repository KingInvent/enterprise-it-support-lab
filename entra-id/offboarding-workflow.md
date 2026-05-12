# Employee Offboarding Workflow

## Objective

Document the process for removing access when an employee leaves the company.

## Scenario

A Sales employee, Jordan Lee, is leaving BlancoTech Solutions. IT must disable account access, remove group memberships, recover licenses, collect hardware, and document completion in the ticketing system.

## Required Information

Before offboarding, IT must confirm:

- Employee full name
- Department
- Manager
- Last working day
- Termination type
- Required access removal time
- Mailbox retention or forwarding requirements
- OneDrive data transfer requirements
- Assigned hardware assets
- Business application access

## Example User

| Field | Value |
|---|---|
| Name | Jordan Lee |
| Department | Sales |
| Manager | Maria Gonzalez |
| Email | jordan.lee@blancotechsolutions.com |
| Assigned Hardware | Windows 11 laptop, dock, monitor |
| Groups | Sales, All Employees |
| Mailbox Action | Convert to shared mailbox or delegate access to manager |
| OneDrive Action | Transfer ownership to manager |

## Offboarding Steps

1. Confirm offboarding request with HR or manager.
2. Block user sign-in in Microsoft 365 / Entra ID.
3. Reset the user password.
4. Revoke active sessions.
5. Remove user from security groups and Microsoft 365 groups.
6. Remove access to Teams and SharePoint resources.
7. Handle mailbox forwarding, delegation, or conversion if requested.
8. Transfer OneDrive data if requested.
9. Remove or recover Microsoft 365 license.
10. Mark assigned hardware for return.
11. Update asset inventory.
12. Document all actions in the ticketing system.
13. Notify HR or manager after completion.

## Validation Checklist

- [ ] Offboarding request confirmed
- [ ] Sign-in blocked
- [ ] Password reset
- [ ] Active sessions revoked
- [ ] Group memberships removed
- [ ] Teams access removed
- [ ] SharePoint access removed
- [ ] Mailbox action completed
- [ ] OneDrive action completed
- [ ] License removed or recovered
- [ ] Hardware return documented
- [ ] Ticket updated
- [ ] Manager or HR notified

## Example Ticket Note

Blocked sign-in for Jordan Lee, reset password, revoked active sessions, removed Sales and All Employees group memberships, removed Microsoft 365 license, documented mailbox and OneDrive handoff requirements, and updated hardware asset status for return. Ticket resolved after offboarding checklist was completed.

## Escalation Criteria

Escalate to a system administrator or security team if:

- Offboarding is urgent or involuntary
- User has privileged access
- Suspicious activity is detected
- Mailbox or OneDrive transfer fails
- Legal hold, retention, or compliance requirements apply
- Business application access must be removed outside Microsoft 365
