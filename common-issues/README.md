# 💡 Common Issues & Fixes

A quick-reference knowledge base of IT issues I regularly resolve across Microsoft 365, Entra ID, Intune, email security and networking.

Each fix includes the symptoms, the likely causes and the steps to resolve it, plus a **security considerations** section.

## ℹ️ Contents

1. [MFA Reset - Lost or New Phone](#mfa-reset---lost-or-new-phone)
2. [Self-Service Password Reset (SSPR)](#self-service-password-reset-sspr)
3. [User Needs Admin Rights or Wants to Install Software](#user-needs-admin-rights-or-wants-to-install-software)
4. [Device Non-Compliant in Intune](#device-non-compliant-in-intune)

---

## 👉 MFA Reset - Lost or New Phone

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

### Security considerations
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

## 👉 Self-Service Password Reset (SSPR)

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

### Security considerations
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

---

## 👉 User Needs Admin Rights or Wants to Install Software

### Symptoms
- The user gets a **User Account Control (UAC)** prompt asking for an administrator username and password
- An installer fails with "you need administrator permission" or "access denied"
- The user asks for admin rights "just to install one thing" or to run a specific app
- A printer driver, plugin or update won't install until elevated

### Common causes
- The app isn't available in the **Company Portal**
- The software needs elevation to install
- A one-off install, such as a driver or a vendor tool for a specific piece of hardware

### Fix
**One-off install** (like a driver): Remote in and elevate using the device's **LAPS** password, retrieved from Intune or Entra ID
  - Enter it yourself, **never give it to the user**
1. **Check the Company Portal first:** if the app is already approved, the user can install it themselves from Intune without admin rights
2. **New software? Raise a request:** new software goes through the **demand / request process**
  - The user submits a request with the **business reason**
  - The request is **reviewed and triaged**
  - IT reviews the software, if applicable it goes through the Change Authority Board (CAB)
3. **Deploy it through Intune:** use a packaging service such as **Robopack**, which provides pre-built, tested app packages that keep themselves updated
  - Assign it to the right group, and make it available in the Company Portal so others can install it too

### Security considerations
- **Admin rights make malware far more dangerous.** With local admin, malware can turn off security tools, install persistence and steal credentials.
- **Never sign in to a user's device with a domain admin or Global Admin account** to install something. Your credentials can be left behind in memory and stolen, use the device's LAPS account instead
- **Check where the software came from:** use a reputable packaging service or the vendor's official site, check installers are digitally signed

### Prevention
- Keep the **Company Portal up-to-date** with commonly requested apps
- Have a clear **software request process** that users know about
- Use a **packaging service with automatic updates** such as Robopack so deployed apps stay patched
- Use **LAPS** on every device, so each local admin password is unique and rotated

## 👉 Device Non-Compliant in Intune

### Symptoms
- The user can't open Outlook, Teams or SharePoint, and sees a message saying the device must meet the organisation's compliance policy
- The sign-in log shows a **Conditional Access** failure, for example error **53000** (device not compliant)
- The Company Portal and Intune shows the device as **Not compliant**

### Common causes
- **BitLocker** is off or suspended, often after a BIOS update or hardware change
- **OS version** is below the minimum, or Windows updates are overdue
- **Antivirus, firewall or real-time protection** is off, or isn't being reported to Windows Security
- The device **hasn't checked in** with Intune recently
- The device has a **risk score** from Defender for Endpoint
- **Browser issue:** such as user not signed in on the browser

### Fix
1. **Find out what's non-compliant:** in Intune, go to the device and select **Device compliance**
2. **Fix the non-compliant setting:**
   - **BitLocker:** turn it on, or resume it if suspended, then **restart**. BitLocker status is confirmed after a reboot, so it can take a few hours to show as compliant
   - **OS / updates:** install pending Windows updates and restart
   - **Antivirus / firewall:** make sure protection is on and showing as healthy in **Windows Security**
3. **Force a check-in:** Press **Sync** on the device in Intune. Then ask the user to select **Check status** on Company Portal
4. **Check Entra ID:** under **Devices**, confirm the device now shows as **Compliant**, and that it's registered or joined properly
5. **Browser problems:** use **Edge** signed in with the work profile
6. **Device risk score:** Investigate the detection in Defender

### Security considerations
- **Compliance is what lets the device in.** Conditional Access trusts compliant devices, so fix the device
- **Non-compliance can be a warning sign:** antivirus switched off, BitLocker suspended or a sudden risk score may mean tampering or malware
- **Unexpected BitLocker recovery or suspension** after a hardware change can also be a sign of physical tampering
- **Personal or unmanaged devices** shouldn't be made compliant just to get access. Use browser-only access or app protection policies instead

### Prevention
- Set **actions for non-compliance** in Intune, such as emailing the user, with a short grace period before access is blocked
- Use **Windows Update rings** so devices stay on a supported OS version
- Review the **compliance report** regularly and schedule email notifications to users when non-compliant