param (
    [int]$maximumRetries = 50,
    [int]$retryCount = 0,
    [int]$retryDelay = 10000
)

$success = $false
$releaseTag = ""
do {
    $retryCount++
    try {
        Write-Host "Getting the latest release version"
        $releaseTag = Get-ALZGithubRelease -o "." -i "terraform" -v "latest" -queryOnly -ErrorAction Stop
        $success = $true
    } catch {
        Write-Host "Failed to get the release version. Retrying after $retryDelay ms..."
        Start-Sleep -Milliseconds $retryDelay
    }
} while ($success -eq $false -and $retryCount -lt $maximumRetries)

if ($success -eq $false) {
    throw "Failed to get the release version after $maximumRetries attempts."
}
return $releaseTag
