# Knowledge Base Article 05: How to Report a Phishing Email

## Purpose

This article explains how BlancoTech Solutions users should report suspicious or phishing emails.

Reporting suspicious emails quickly helps IT protect user accounts, company data, and Microsoft 365 services.

## Applies To

This guide applies to:

- Suspicious emails
- Phishing emails
- Fake Microsoft 365 login pages
- Unknown attachments
- Suspicious links
- Spoofed sender addresses
- Unexpected MFA prompts
- Payment or gift card scams
- Security-related help desk tickets

## What Is Phishing?

Phishing is a type of attack where someone tries to trick you into revealing sensitive information or performing an unsafe action.

Attackers may try to steal:

- Passwords
- MFA codes
- Bank or payment information
- Company data
- Microsoft 365 access
- Personal information

Phishing emails often look urgent, official, or familiar.

## Common Signs of Phishing

Watch for:

- Urgent or threatening language
- Requests for your password
- Requests for MFA codes
- Unexpected attachments
- Links to fake sign-in pages
- Sender address that does not match the display name
- Misspelled company or domain names
- Gift card or payment requests
- Unexpected invoice or document links
- Messages asking you to bypass normal approval processes

## What to Do If You Receive a Suspicious Email

If you receive a suspicious email:

1. Do not click links.
2. Do not open attachments.
3. Do not reply.
4. Do not forward the email externally.
5. Do not enter your password.
6. Do not approve unexpected MFA prompts.
7. Report the email to IT support.

## If You Already Clicked a Link

If you clicked a suspicious link:

1. Close the browser tab.
2. Do not enter any information.
3. Contact IT support immediately.
4. Tell IT that you clicked the link.
5. Include whether you entered any password or MFA code.

Do not hide the mistake. Fast reporting helps IT contain the issue.

## If You Entered Your Password

If you entered your password into a suspicious page:

1. Contact IT support immediately.
2. Stop using the affected account until IT responds.
3. Do not approve MFA prompts unless IT confirms they are expected.
4. Be ready to reset your password.
5. Tell IT exactly what information you entered.

This should be treated as urgent.

## If You Opened an Attachment

If you opened a suspicious attachment:

1. Stop interacting with the file.
2. Do not forward the attachment.
3. Contact IT support immediately.
4. Tell IT what file was opened.
5. Leave the device powered on unless IT instructs otherwise.
6. Disconnect from Wi-Fi or network only if instructed by IT or if malware is strongly suspected.

IT may need to review the device.

## If You Receive an Unexpected MFA Prompt

Do not approve it.

Unexpected MFA prompts may mean someone else has your password.

If this happens:

1. Deny the prompt.
2. Do not approve repeated prompts.
3. Contact IT support immediately.
4. Change your password if instructed by IT.
5. Report whether the prompt happened after clicking a link or entering credentials.

## What to Include in the Report

When reporting a phishing email, include:

| Information Needed | Example |
|---|---|
| Your full name | Priya Shah |
| Department | Finance |
| Sender email address | unknown@example.com |
| Subject line | Urgent invoice approval |
| Time received | Today at 9:15 AM |
| Did you click a link? | Yes / No |
| Did you open an attachment? | Yes / No |
| Did you enter credentials? | Yes / No |
| Did you approve MFA? | Yes / No |

## Example Report Message

Use this format when contacting IT:

```text
I received a suspicious email from an external sender. The subject was "Urgent invoice approval." I did not click the link or open the attachment. Please review the message.
```

If you clicked something, say so clearly:

```text
I received a suspicious email and clicked the link. I did not enter my password. Please review the message and advise next steps.
```

If you entered credentials:

```text
I received a suspicious email, clicked the link, and entered my company password. I did not approve any MFA prompts. Please treat this as urgent.
```

## What IT May Do

IT may take actions such as:

- Review the suspicious message
- Check sender and links
- Search for similar emails
- Remove or quarantine the message
- Reset your password
- Revoke active sessions
- Review sign-in activity
- Check mailbox rules
- Scan your device
- Escalate to security administrators

## Common Phishing Scenarios

| Scenario | Risk |
|---|---|
| Fake Microsoft 365 login page | Credential theft |
| Suspicious invoice attachment | Malware or fraud |
| Gift card request | Financial scam |
| Fake password expiration notice | Credential theft |
| Unexpected file share link | Phishing or malware |
| MFA prompt you did not request | Possible account compromise |
| Executive impersonation | Business email compromise |

## Security Reminders

Do not:

- Share your password
- Share MFA codes
- Approve unexpected MFA prompts
- Download suspicious attachments
- Enter credentials after clicking an unknown link
- Trust a message only because it uses a familiar logo
- Use personal email to forward suspicious company messages
- Delete evidence before reporting

## When to Contact IT Immediately

Contact IT immediately if:

- You clicked a suspicious link
- You entered your password
- You approved an unexpected MFA prompt
- You opened an unknown attachment
- You replied with sensitive information
- The email requested payment, gift cards, or banking changes
- Multiple users received the same suspicious email
- The email impersonates a manager, executive, vendor, or IT

## Related Articles

| Article | Location |
|---|---|
| Phishing troubleshooting runbook | `troubleshooting-runbooks/phishing-email-report.md` |
| MFA setup article | `knowledge-base/04-how-to-set-up-mfa.md` |
| MFA troubleshooting runbook | `troubleshooting-runbooks/mfa-issue.md` |
| Password reset article | `knowledge-base/01-how-to-reset-password.md` |

## For IT Staff

Related systems and workflows:

- Microsoft 365 mailbox review
- Exchange Online message trace
- Entra ID sign-in log review
- MFA method review
- Password reset workflow
- Session revocation
- Mailbox rule investigation
- Endpoint security escalation
- GLPI security ticket documentation

Related lab evidence:

| Evidence | Location |
|---|---|
| Phishing email runbook | `troubleshooting-runbooks/phishing-email-report.md` |
| MFA runbook | `troubleshooting-runbooks/mfa-issue.md` |
| MFA workflow documentation | `entra-id/mfa-workflow.md` |
| Security baseline documentation | `security-baseline/README.md` |
| GLPI ticket categories | `screenshots/glpi-ticket-categories.png` |
| GLPI setup documentation | `glpi-ticketing/setup.md` |