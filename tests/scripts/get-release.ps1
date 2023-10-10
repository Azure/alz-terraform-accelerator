param (
    [int]$maximumRetries = 10,
    [int]$retryCount = 0,
    [int]$retryDelay = 10000
)

$success = $false
$terraformModuleUrl = "https://github.com/Azure/alz-terraform-accelerator"
$release = ""
do {
    $retryCount++
    try {
        Write-Host "Getting the latest release version"
        $releaseObject = Get-ALZGithubRelease -directoryForReleases "." -githubRepoUrl $terraformModuleUrl -releases "latest" -queryOnly -ErrorAction Stop
        $release = $($releaseObject.name)
        $success = $true
    } catch {
        Write-Host "Failed to get the release version."
        Start-Sleep -Milliseconds $retryDelay
    }
} while ($success -eq $false -and $retryCount -lt $maximumRetries)

if ($success -eq $false) {
    throw "Failed to get the release version after $maximumRetries attempts."
}
return $release
