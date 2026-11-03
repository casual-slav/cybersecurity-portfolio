# 🔐 Business Email Compromise (BEC)

How I investigate a possible account takeover, from the first alert to recovery. Business email compromise (BEC) usually starts with stolen credentials from phishing or a password spray, then moves on to the attacker creating inbox rules, sending phishing from the trusted account or attempting payment fraud.

```
Alert Triggered (or User Reported)
↓
Triage (Real? How urgent?) ──────────────► Obvious false positive → Close
↓
Investigation (Logs, Evidence, Scope) ───► Confirmed false positive → Close
↓
Containment
↓
Remediation
↓
Document and Report
↓
Detection Improvement
```

## 1. Alert Triggered

Common sources:
- **Email gateway account takeover alert**, e.g. Barracuda Impersonation Protection, showing suspicious sign-ins, emails sent and inbox rules
- **Entra ID Protection**: risky user or risky sign-in
- **Sentinel / Defender XDR** alerts

## 2. Triage

**Sign-ins** IP, location, user agent and the flagged issue (e.g. "unusual location and application")
**Emails sent** Any emails sent **after** the suspicious sign-in, especially to many recipients or external addresses
**Inbox rules** Any new rules that forward, delete or hide mail

# **Likely malicious**
- An IP from a **hosting provider, VPN or proxy**, or a country the user has never signed in from
- Unusual user agents (`python-requests`, `axios`, blank or "Other") or legacy protocols (IMAP, POP, SMTP)
- **Emails sent** to many recipients straight after the sign-in
- **New inbox rules**, especially forwarding externally or deleting or hiding mail
- **MFA prompts** the user didn't start

**Is it urgent?** Emails sent, inbox rules created or finance involved **High** priority

## 3. Investigation

### Sign-in logs (Entra ID)
Look at the user's sign-ins over the **last 30 days** and compare the suspicious ones with their normal pattern.

| Check | Why |
|---|---|
| **IP and ISP/ASN** | Residential ISP vs hosting, VPN or proxy (check AbuseIPDB / IPinfo) |
| **Location** | Compared with where the user normally signs in |
| **Device and browser** | Managed or compliant? Same OS and browser as usual? |
| **Application and client** | Legacy auth (IMAP, POP, SMTP) or unusual apps |
| **MFA details** | Was MFA completed, and how? Was it pushed repeatedly or denied? |
| **Conditional Access** | Did a policy block it, or allow it through? |
| **Result** | Successful sign-ins matter most. Failures show attempts |

### Mailbox: inbox rules and forwarding
Look for forwarding, deleting, moving to RSS / Archive, keywords like "invoice"

### Emails sent from the account
- Use **message trace** or the gateway to look at mail **sent by the user** since the suspicious sign-in
- Look for phishing sent to internal staff or contacts, or invoice and payment-change emails
- Check **Sent Items** and **Deleted Items**

## 4. Containment

- **Block sign-in** for the account if the attacker is still active
- **Revoke all sessions**, which signs out every device and token

## 5. Remediation
- **Purge phishing sent from the account** from internal mailboxes
- **Warn external contacts** who received malicious emails
- **Unblock the account** and confirm the user can work normally

## 6. Document and Report
- **Timeline:** first malicious sign-in → attacker actions → detection → containment
- **IOCs:** attacker IPs, user agents, rule names, forwarding addresses, phishing subjects
- **Impact:** emails sent, data accessed, other accounts affected
- **Update the user**

## 7. Detection Improvement
- Was the alert **fast enough**?
- Add the attacker's IPs or ASN to watchlists
- Make sure risky-user policies and **Conditional Access** cover this scenario