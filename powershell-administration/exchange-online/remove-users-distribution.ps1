Connect-ExchangeOnline

$groupName = "Distribution Name"

# Use display names
$names = @(
    "User One",
    "User Two"
)

foreach ($name in $names) {
    $user = Get-Recipient -Filter "DisplayName -eq '$name'"

    if ($user) {
        try {
            Remove-DistributionGroupMember -Identity $groupName -Member $user.PrimarySmtpAddress
            Write-Host "Successfully removed $name ($($user.PrimarySmtpAddress)) from $groupName"
        }
        catch {
            Write-Host "Failed to remove $name from $groupName"
        }
    } else {
        Write-Host "User with name '$name' not found in Exchange Online"
    }
}