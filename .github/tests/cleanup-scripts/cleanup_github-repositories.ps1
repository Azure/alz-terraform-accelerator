# This file can be used to clean up GitHub repositories if there has been an issue with the End to End tests.
# CAUTION: Make sure you are connected to the correct organization before running this script!
$repos = gh repo list microsoft-azure-landing-zones-cd-tests --json name,owner | ConvertFrom-Json

$repos | ForEach-Object -Parallel {
    $match = "*229*"
    $repoName = "$($_.owner.login)/$($_.name)"
    
    if($repoName -like $match)
    {
        Write-Host "Deleting repo: $repoName"
        gh repo delete $repoName --yes
    
    }
} -ThrottleLimit 10
