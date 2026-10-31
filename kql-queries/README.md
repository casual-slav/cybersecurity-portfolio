# 🔍 KQL Queries
Detection and hunting queries for **Microsoft Sentinel** and **Microsoft Defender XDR**, organised by what they investigate. 
---

### 🪪 Identity

| [Password Spray](identity/password-spray.kql) | One IP failing against many accounts
| [MFA Push Bombing](identity/mfa-push-bombing.kql) | Bursts of denied MFA prompts
| [Impossible Travel (Unmanaged)](identity/impossible-travel-unmanaged.kql) | Sign-ins from two countries within an hour on unmanaged devices, with calculated travel speed
| [IP Pivot](identity/ip-pivot.kql) | Investigation query: which accounts a suspicious IP touched and whether any logons succeeded

### 📧 Email

| [Phishing Clicked Links](email/phishing-clicked-links.kql) | Users who clicked links in phishing emails, including emails removed after delivery by ZAP
| [Suspicious Inbox Rules](email/suspicious-inbox-rules.kql) | Risk-scored inbox rules that forward
### 💻 Endpoint

| [Office Spawning Shells](endpoint/office-spawning-shells.kql) | Word, Excel or Outlook launching PowerShell, cmd or LOLBins, scored by command line

---

## 🚀 How to use

1. Open **Microsoft Sentinel → Logs** or **Defender XDR → Advanced Hunting**.
2. Paste the query and adjust the settings at the top
3. Run it. To use it as a detection, save it as an **analytic rule** in Sentinel or a **custom detection** in Defender.