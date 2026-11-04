# 🧹 Remove Unwanted App (Intune Remediation)

An **Intune Remediations** script pair that finds an unwanted application on Windows devices and removes it silently, without user interaction.

---

## 📁 Files

`detect-unwanted-app.ps1` Detection Script
`remove-unwanted-app.ps1` Remediation Script

---

## ✏️ Changing the app name

The app names appear in **three places**, and all three must match.
Change these to match the app you want to remove.

### 1. `detect-unwanted-app.ps1`: inside the `$apps` block (lines 8–9)

```powershell
$_.DisplayName -match "^Unwanted App Name" -or
$_.DisplayName -match "^Another Unwanted App Name"
```

### 2. `remove-unwanted-app.ps1`: inside the `$apps` block (lines 28–29)

```powershell
$_.DisplayName -match "^Unwanted App Name" -or
$_.DisplayName -match "^Another Unwanted App Name"
```

### 3. `remove-unwanted-app.ps1`: inside the `$remaining` block (lines 84–85)

```powershell
$_.DisplayName -match "^Unwanted App Name" -or
$_.DisplayName -match "^Another Unwanted App Name"
```

### Tips
- Use the app's name **exactly as it appears in Settings → Apps → Installed apps**
- `^` means **"starts with"**. Keep it, so the pattern doesn't match other apps by accident
- `(PDF )?` means "PDF " is **optional**, which is handy when vendors rename products
- ⚠️ Avoid short, broad names. `"Reader"` on its own would also match Adobe Acrobat Reader and others
- **Test first:** run the detection script on a test device and check exactly which apps it finds

---

## 🚀 Deploying in Intune

1. Go to **Intune → Devices → Scripts and remediations → Remediations → Create**
2. Upload `detect-unwanted-app.ps1` as the **detection script** and `remove-unwanted-app.ps1` as the **remediation script**