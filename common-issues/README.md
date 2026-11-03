# 🛠️ Common Issues & Fixes

A quick-reference knowledge base of IT issues I regularly resolve across Microsoft 365, Entra ID, Intune, email security and networking.

Each fix includes the symptoms, the likely causes and the steps to resolve it, plus a **security considerations** section.

## ℹ️ Contents

1. [MFA Reset - Lost or New Phone](#mfa-reset---lost-or-new-phone)

---

## 🔒 Security considerations
What could go wrong, or be abused, when fixing this.

## Prevention
How to stop it happening again.

---

# MFA Reset - Lost or New Phone

## Symptoms
- The user has a new or lost phone and can't approve MFA prompts or get codes
- The user is stuck on "Approve sign-in request" or "Enter code" and can't get past it
- Microsoft Authenticator was deleted or didn't carry over to a new phone

## Common causes
- New phone, and Authenticator wasn't backed up or moved across
- Lost, stolen or broken phone

## Fix
1. **Verify the user's identity** such as caller number (are they calling from office phone?), previous device, postcode, manager's name ect.
2. **Check recent sign-ins** for the user in Entra ID. Look for failed MFA attempts or sign-ins from unusual IPs or locations
3. In the **Entra admin centre**, go to **Users → [user] → Authentication methods**
4. Select **Require re-register multifactor authentication**
5. If the phone was **lost or stolen**, also select **Revoke sessions**, so anything still signed in on that device is logged out

### 🔒 Security considerations
- **MFA resets are a top social engineering target.** Attackers call or message the service desk pretending to be the user
- **Verify identity through a trusted channel**, never just the channel the request came in on
  - Confirmation from their **line manager**
  - Don't verify by email or chat alone, because the account may already be compromised
- **Be wary of urgency and pressure** A classic social engineering tactic.
- **Check for signs of compromise first.** Failed MFA attempts or sign-ins from unknown IPs

### Prevention
- Encourage users to register **at least two MFA methods**
- Document a clear **identity verification process** for MFA resets, and stick to it every time

---



## 🔒 Security considerations
What could go wrong, or be abused, when fixing this.

## Prevention
How to stop it happening again.
