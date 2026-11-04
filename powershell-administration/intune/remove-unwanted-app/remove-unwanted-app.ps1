$paths = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

# Runs an uninstaller and stops it if it takes longer than the timeout
function Start-ProcessWithTimeout {
    param(
        [string]$FilePath,
        [string]$ArgumentList,
        [int]$TimeoutSeconds = 600
    )

    $process = Start-Process $FilePath -ArgumentList $ArgumentList -PassThru -NoNewWindow

    if (-not $process.WaitForExit($TimeoutSeconds * 1000)) {
        Write-Output "Uninstaller timed out after $TimeoutSeconds seconds, stopping it"
        $process | Stop-Process -Force
    }
    else {
        # 0 = success, 3010 = success but a restart is needed
        Write-Output "Exit code: $($process.ExitCode)"
    }
}

$apps = foreach ($path in $paths) {
    Get-ItemProperty $path -ErrorAction SilentlyContinue | Where-Object {
        $_.DisplayName -match "^Unwanted App Name" -or
        $_.DisplayName -match "^Another Unwanted App Name"
    }
}

if (-not $apps) {
    Write-Output "App not found"
    exit 0
}

$uninstallAttempted = $false

foreach ($app in $apps) {
    $displayName = $app.DisplayName
    $uninstallString = $app.UninstallString
    $quietUninstallString = $app.QuietUninstallString

    Write-Output "Found: $displayName"

    if ($quietUninstallString) {
        Write-Output "Using QuietUninstallString for $displayName"
        $uninstallAttempted = $true
        Start-ProcessWithTimeout "cmd.exe" "/c $quietUninstallString"
        continue
    }

    if ($uninstallString) {
        $uninstallAttempted = $true
        Write-Output "Using UninstallString for $displayName"

        if ($uninstallString -match "msiexec") {
            if ($uninstallString -match "\{[A-Z0-9\-]+\}") {
                $productCode = $matches[0]
                Start-ProcessWithTimeout "msiexec.exe" "/x $productCode /qn /norestart"
            } else {
                Start-ProcessWithTimeout "cmd.exe" "/c $uninstallString /qn /norestart"
            }
        }
        elseif ($uninstallString -match "unins\d{3}\.exe") {
            # Inno Setup uninstaller
            Start-ProcessWithTimeout "cmd.exe" "/c $uninstallString /VERYSILENT /SUPPRESSMSGBOXES /NORESTART"
        }
        else {
            # Unknown installer type: guessing silent switches can open a hidden prompt and hang under SYSTEM
            Write-Output "Unknown installer type for $displayName, skipping"
        }
    }
    else {
        Write-Output "No uninstall string found for $displayName"
    }
}

Start-Sleep -Seconds 5

$remaining = foreach ($path in $paths) {
    Get-ItemProperty $path -ErrorAction SilentlyContinue | Where-Object {
        $_.DisplayName -match "^Unwanted App Name" -or
        $_.DisplayName -match "^Another Unwanted App Name"
    }
}

if ($remaining) {
    Write-Output "App still present after remediation"
    exit 1
}

if ($uninstallAttempted) {
    Write-Output "App successfully removed"
    exit 0
} else {
    Write-Output "App was detected but no uninstall could be attempted"
    exit 1
}