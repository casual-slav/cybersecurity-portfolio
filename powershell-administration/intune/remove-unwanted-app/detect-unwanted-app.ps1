$paths = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

$apps = foreach ($path in $paths) {
    Get-ItemProperty $path -ErrorAction SilentlyContinue | Where-Object {
        $_.DisplayName -match "^Unwanted App Name" -or
        $_.DisplayName -match "^Another Unwanted App Name"
    }
}

if ($apps) {
    Write-Output "App detected"
    exit 1
} else {
    Write-Output "App not detected"
    exit 0
}