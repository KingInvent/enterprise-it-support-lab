# MFA Support Workflow

## Objective

Document the process for supporting multi-factor authentication setup, troubleshooting, and reset requests in the simulated company IT environment.

## Business Scenario

BlancoTech Solutions requires MFA for employee accounts to reduce unauthorized access risk. IT supports users during MFA registration, device changes, sign-in issues, and lost authenticator access.

## Common MFA Support Scenarios

| Scenario | Example |
|---|---|
| New user MFA setup | New hire needs to register Microsoft Authenticator |
| New phone | User replaced phone and cannot approve sign-in |
| Lost device | User lost phone used for MFA |
| Number changed | User changed mobile number |
| App issue | Authenticator app is not showing prompts |
| Travel issue | User cannot access MFA while traveling |
| Repeated prompts | User is constantly asked to approve sign-ins |

## Required Verification Before MFA Reset

Before resetting MFA, IT must verify the user's identity.

Acceptable verification methods:

- Manager confirmation
- Video call verification
- Employee ID verification
- Security questions if company policy allows
- HR confirmation for sensitive cases

## MFA Setup Steps

1. Confirm user identity.
2. Confirm user has access to their work account.
3. Direct user to register Microsoft Authenticator.
4. Confirm default sign-in method.
5. Test sign-in with MFA prompt.
6. Document completion in the ticket.

## MFA Reset Steps

1. Confirm the user identity.
2. Review the reason for MFA reset.
3. Remove or reset the old authentication method.
4. Require the user to register a new MFA method.
5. Confirm successful sign-in.
6. Document the action in the ticketing system.

## Troubleshooting Checklist

- [ ] Confirm user identity
- [ ] Confirm correct username
- [ ] Confirm user has internet access
- [ ] Confirm phone date and time are correct
- [ ] Confirm Microsoft Authenticator is installed
- [ ] Confirm notifications are enabled
- [ ] Confirm user is not locked out
- [ ] Confirm old device or phone number issue
- [ ] Confirm new MFA method works
- [ ] Update ticket notes

## Example Ticket: New Phone MFA Reset

### Issue

User replaced their phone and can no longer approve Microsoft 365 sign-in prompts.

### Troubleshooting

Verified user identity through manager confirmation. Confirmed user had a new phone and no longer had access to the previous Microsoft Authenticator registration.

### Resolution

Reset MFA registration requirement and instructed user to register Microsoft Authenticator on the new phone. User confirmed successful Microsoft 365 sign-in after registration.

### Ticket Note

Verified user identity through manager confirmation. Reset MFA registration for the user due to phone replacement. User registered Microsoft Authenticator on new device and confirmed successful Microsoft 365 sign-in. Ticket resolved.

## Security Considerations

MFA reset requests should be treated carefully because attackers may attempt to bypass account protection through social engineering.

Do not reset MFA if:

- User identity cannot be verified
- Request comes from an unusual or suspicious source
- Manager approval is missing for sensitive accounts
- User has privileged access and security review is required

## Escalation Criteria

Escalate to a system administrator or security team if:

- User has admin privileges
- Suspicious login activity is detected
- Multiple MFA reset requests occur in a short period
- User reports MFA prompts they did not initiate
- Conditional access or security policy appears to block sign-in
