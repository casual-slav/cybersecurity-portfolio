# 🎣 Phishing & Email Investigation Workflow

How I investigate suspicious emails, from the first report to closing the case. It's built around a setup with a **third-party email gateway (Barracuda) in front of Microsoft 365 / Defender for Office 365**, plus KQL for scoping.

```
Alert Triggered (or User Reported)
↓
Triage (Real? How Urgent?) ─────────────► Obvious False positive → Close
↓
Investigation (Logs, Evidence, Scope) ─────────────► Confirmed False positive → Close
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

- Gateway or Defender Alert, or a user reported email

## 2. Triage: Is it real and how urgent is it?

A quick check to decide whether it's an obvious false positive and if not how urgent is it.
- Was it **Delivered or Blocked/Quarantined**
- Did anyone **Click, open attachment or reply**
- How many **Users are affected**

**Obvious false positive** (newsletter, known sender) → release, report and close.

## 3. Investigation: Logs, Evidence, Scope

- **Headers:** `From` vs `Reply-To` vs `Return-Path`
- **SPF/DKIM/DMARC** results
- **Sender:** lookalike domains, domain age, reputation
- **URLs:** defang them, check on VirusTotal, URLscan and follow the redirects
- **Attachments:** look up the SHA256 hash, and **review in a sandbox**
- **Scope:** who else received it, who clicked anything

**Confirmed false positive** → release, report and close.

## 4. Containment

Stop it spreading.
- **Purge** every copy from all mailboxes
- **Block** the sender, domain and URLs
- If credentials were entered: **revoke sessions** and **reset the password**
- If an attachment was opened: **isolate the device**

## 5. Remidiation

Remove the threat and recover.
- Check for and remove **malicious inbox rules**
- Scan and clean affected devices, and restore access for the user
- **Submit** the email to Microsoft and the gateway vendor

## 6. Document and Report

- Timeline, analysis, IOCs, impact and actions taken
- Tell the user what happened and what to look out for next time

## 7. Detection Improvement

- Could a detection, a block rule or user training have stopped this sooner?
- Tune noisy rules, and add new detections or block rules from what you learned

