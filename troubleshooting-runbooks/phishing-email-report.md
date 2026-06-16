# Phishing Email Report Troubleshooting Runbook

## Overview

This runbook documents the troubleshooting process for a suspected phishing email reported by a user in the BlancoTech Solutions environment.

Phishing reports must be handled carefully because they may indicate credential theft, malware delivery, business email compromise, or a broader security campaign targeting multiple users.

## Scope

This runbook applies to:

- Suspicious email reports
- Phishing attempts
- Credential harvesting links
- Malicious attachments
- Spoofed sender emails
- Business email compromise attempts
- Microsoft 365 security support tickets
- Help desk security escalation workflows

## Related Systems

| System | Purpose |
|---|---|
| Microsoft 365 | Email and collaboration platform |
| Exchange Online | Mailbox and mail flow platform |
| Outlook | User email client |
| Entra ID / Azure AD | Identity and sign-in monitoring |
| MFA | Protects accounts after credential exposure |
| Endpoint Security | Detects malware or suspicious files |
| GLPI | Ticket tracking and documentation |
| Security Baseline | Defines security controls and escalation process |

## Related Lab Evidence

| Evidence | Location |
|---|---|
| GLPI ticket categories | `screenshots/glpi-ticket-categories.png` |
| Security category | GLPI category: `Security` |
| MFA workflow documentation | `entra-id/mfa-workflow.md` |
| Offboarding workflow | `entra-id/offboarding-workflow.md` |
| Security baseline documentation | `security-baseline/README.md` |
| GLPI setup documentation | `glpi-ticketing/setup.md` |

## Symptoms

User may report:

- Suspicious email received
- Email asks for password or MFA code
- Email contains unknown attachment
- Email contains suspicious link
- Sender address looks spoofed
- Email claims urgent payment or gift card request
- User clicked a suspicious link
- User entered credentials into a suspicious page
- User opened a suspicious attachment
- Multiple users received the same email

## Initial Questions

Ask the user:

1. Did you click any links?
2. Did you open any attachments?
3. Did you enter your password or MFA code?
4. Did you reply to the message?
5. Did you forward the message to anyone?
6. When did you receive the email?
7. Was the message sent only to you or multiple users?
8. Is the sender internal or external?
9. Can you provide the subject line and sender address?

## Priority

| Condition | Priority |
|---|---|
| Suspicious email not clicked | Medium |
| User clicked link but entered no credentials | High |
| User entered credentials | Critical |
| User opened suspicious attachment | Critical |
| Multiple users affected | Critical |
| Executive/payment fraud attempt | Critical |

## Troubleshooting Steps

## 1. Tell User Not to Interact Further

Immediately instruct the user:

- Do not click links
- Do not open attachments
- Do not reply
- Do not forward externally
- Do not enter credentials
- Leave the email available for review if possible

If the user already interacted with the message, continue with containment steps.

## 2. Confirm User and Email Details

Collect:

- User full name
- Email address
- Department
- Sender email address
- Subject line
- Time received
- Whether link or attachment was clicked
- Whether credentials were entered
- Whether other users received it

Example:

```text
User: Priya Shah
Department: Finance
Issue: Suspicious invoice email with attachment
Sender: unknown external sender
Action taken: User did not open attachment
```

## 3. Determine Interaction Level

Classify the incident.

| Interaction | Risk Level |
|---|---|
| Email received only | Medium |
| Email opened only | Medium |
| Link clicked | High |
| Attachment opened | Critical |
| Credentials entered | Critical |
| MFA prompt approved unexpectedly | Critical |
| Money/payment request followed | Critical |

## 4. Preserve Evidence

Ask the user to keep the message available.

Document:

- Sender
- Subject
- Date/time
- Recipients
- Link destination if safely available
- Attachment name if present
- User action taken

Do not ask the user to download or open attachments for investigation.

## 5. Review Sender and Message Indicators

Check for common phishing indicators:

- Misspelled sender domain
- Urgent language
- Password reset request
- Fake Microsoft 365 login page
- Unknown attachment
- External sender pretending to be internal
- Gift card or wire transfer request
- Mismatched display name and email address
- Link text does not match actual URL
- Grammar or formatting abnormalities

## 6. Check Whether User Clicked a Link

If the user clicked a link but did not enter credentials:

- Document the link interaction
- Ask user to close the browser tab
- Clear browser cache if needed
- Check for downloads
- Monitor sign-in activity
- Escalate if the page requested credentials or downloaded a file

If the user entered credentials, treat as credential compromise.

## 7. If Credentials Were Entered

Escalate immediately.

Recommended actions:

- Reset user password
- Revoke active sessions
- Confirm MFA methods
- Review sign-in logs
- Check inbox rules
- Check forwarding rules
- Check sent items
- Check for suspicious OAuth app consent
- Monitor for additional suspicious activity

Document all containment steps in GLPI.

## 8. If MFA Was Approved Unexpectedly

Treat as possible account compromise.

Actions:

- Reset password
- Revoke sessions
- Review MFA methods
- Review sign-in logs
- Check for risky sign-ins
- Confirm user did not approve unknown prompts
- Escalate to security administrator

Unexpected MFA prompts may indicate the password is already known by an attacker.

## 9. If Attachment Was Opened

Treat as possible endpoint compromise.

Actions:

- Disconnect device from network if malware is suspected
- Do not delete evidence unless instructed
- Run endpoint security scan
- Check downloads folder
- Check recent processes if appropriate
- Escalate to security or desktop support
- Reimage device if required by security policy

Do not assume an attachment is safe because it opened normally.

## 10. Check Mailbox Rules

If account compromise is suspected, check for malicious mailbox rules.

Look for rules that:

- Forward email externally
- Delete incoming messages
- Hide security alerts
- Move emails to RSS feeds or archive
- Mark messages as read
- Redirect finance or password reset emails

Suspicious rules should be removed and documented.

## 11. Check Sign-In Activity

Review Entra ID / Azure AD sign-in logs.

Look for:

- Unknown locations
- Impossible travel
- Failed sign-in spikes
- Successful sign-ins from unfamiliar IP addresses
- MFA failures
- Risky sign-ins
- Legacy authentication attempts

Escalate suspicious sign-in activity.

## 12. Search for Similar Emails

If multiple users may be affected, search for the same sender, subject, link, or attachment.

Look for:

- Same sender address
- Same subject line
- Same attachment name
- Same link domain
- Same message body pattern
- Same recipient group

If found, escalate for organization-wide remediation.

## 13. Remove or Quarantine Message if Authorized

If admin tools are available and policy allows:

- Quarantine the message
- Remove from affected mailboxes
- Block sender/domain if appropriate
- Block malicious URL if confirmed
- Block attachment hash if available
- Create mail flow rule if needed

Do not block broad domains without verification because it may disrupt legitimate mail.

## 14. Check User Account Security

For affected user, verify:

- Password was changed if needed
- MFA methods are valid
- No unknown MFA method was added
- No suspicious inbox rules exist
- No external forwarding is configured
- No suspicious sent mail exists
- Active sessions were revoked if needed

## 15. User Guidance After Report

Tell the user:

- Thank you for reporting the email
- Do not interact with the message further
- Report any future similar emails
- Notify IT immediately if they entered credentials
- Watch for unexpected MFA prompts
- Do not approve MFA prompts they did not initiate

Keep communication factual and clear.

## 16. Escalation Criteria

Escalate to Security Administrator or Microsoft 365 Administrator if:

- User clicked link and entered credentials
- User approved unexpected MFA prompt
- Attachment was opened
- Multiple users received the same email
- Email impersonates executive leadership
- Financial fraud is involved
- Sign-in logs show suspicious activity
- Mailbox rules or forwarding were modified
- Endpoint malware is suspected
- Message appears to be part of a wider campaign

## Resolution Notes Template

Use this format in GLPI:

```text
User reported a suspicious email. Verified sender, subject, time received, and user interaction level. Confirmed whether the user clicked links, opened attachments, entered credentials, or approved MFA prompts. Reviewed phishing indicators and documented risk level. Escalated as needed for mailbox review, sign-in log review, message quarantine, password reset, session revocation, and endpoint security checks. User was advised not to interact with the message and to report future suspicious emails.
```

## GLPI Ticket Example

| Field | Value |
|---|---|
| Type | Incident |
| Category | Security |
| Priority | High |
| Title | Suspicious phishing email reported |

Ticket description:

```text
User reports receiving a suspicious email with an external sender, urgent language, and a link requesting Microsoft 365 sign-in. User confirmed they did not click the link or enter credentials. Documented sender, subject, timestamp, and indicators of phishing. Escalated for message review and advised user not to interact with the email.
```

## Prevention

Recommended prevention steps:

- Train users to report suspicious emails
- Enable MFA for all users
- Monitor risky sign-ins
- Review mailbox forwarding rules
- Disable legacy authentication where possible
- Use anti-phishing policies
- Use safe links and safe attachments if available
- Conduct periodic phishing awareness training
- Encourage users not to approve unexpected MFA prompts
- Document security escalation procedures

## Security Notes

Phishing reports should be handled as security-sensitive tickets.

Do not:

- Tell the user to click the link again
- Ask the user to download the attachment
- Ignore unexpected MFA prompts
- Reset MFA without identity verification
- Delete evidence before documenting it
- Assume one report means only one user was targeted

## Skills Demonstrated

This runbook demonstrates:

- Phishing triage
- Security-aware help desk workflow
- Microsoft 365 incident support
- Entra ID sign-in review awareness
- MFA compromise awareness
- Mailbox rule investigation awareness
- Endpoint security escalation
- GLPI security ticket documentation
- User education and prevention
- Incident escalation decision-making