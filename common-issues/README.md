# 🛠️ Common Issues & Fixes

A quick-reference knowledge base of IT issues I regularly resolve across Microsoft 365, Entra ID, Intune, email security and networking.

Each fix includes the symptoms, the likely causes and the steps to resolve it, plus a **security considerations** section.

## ℹ️ Contents

1. [MFA Reset - Lost or New Phone](#mfa-reset---lost-or-new-phone)

---

## MFA Reset - Lost or New Phone

### Symptoms
- The user has a new or lost phone and can't approve MFA prompts or get codes
- The user is stuck on "Approve sign-in request" or "Enter code" and can't get past it
- Microsoft Authenticator was deleted or didn't carry over to a new phone

### Common causes
- New phone, and Authenticator wasn't backed up or moved across
- Lost, stolen or broken phone

### Fix
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

## Self-Service Password Reset (SSPR)

### Symptoms
- The user has forgotten their password or is locked out of their account
- The user has reset their password but their laptop still only accepts the **old** one

### Common causes
- Forgotten or expired password
- Account locked after too many failed attempts
- The new password doesn't meet the **on-premises AD password policy** (hybrid environments with password writeback)
- **Hybrid device off the network:** Windows still has the old password cached and can't reach a domain controller to update it

### Fix
**Forgotten password or locked account**
1. Point the user to **https://aka.ms/sspr**, or the **Can't access your account?** link on any Microsoft sign-in page
2. They verify with their registered methods (for example, an Authenticator notification or a code) and set a new password
3. If they're already signed in on a domain-joined device on the network, they can also use **Ctrl+Alt+Del → Change a password**. The change syncs to Entra ID

**Reset fails with a password policy error**
- In hybrid setups, password writeback checks the new password against the **on-premises AD policy** (length, complexity, history). Ask the user to choose a stronger or unused password

**Laptop still wants the old password (off network)**
- The device can't update its cached credentials until it reaches a domain controller
- Ask the user to sign in with the **old password** then connect to the office network when they can for the password to sync, and **lock and unlock** the device (or sign out and back in) so the new password is cached

### 🔒 Security considerations
- **SSPR is only as secure as the methods behind it.** If an attacker has registered their own MFA method on an account, they can reset the password themselves. Check for recently added methods if a reset looks suspicious
- **Prefer strong methods:** such as Authenticator notifications
- **Unexpected reset?** If a user gets a "your password was reset" email they didn't trigger, treat it as a possible account takeover
- **Monitor SSPR activity:** resets and method registrations appear in Entra **audit logs**
- **Protect registration itself:** use Conditional Access to require that security info is only registered from **trusted locations or compliant devices**, so an attacker with a stolen password can't add their own method

### Prevention
- Require users to **register for SSPR at first sign-in**, and to re-confirm their methods regularly
- Encourage **at least two methods** per user
- **Notify users** whenever their password is reset, so unexpected resets get reported quickly
- Make sure users know the **SSPR link**, so they don't call the service desk, or fall for fake "reset your password" phishing pages