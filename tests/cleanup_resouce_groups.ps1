# This file can be used to clean up Resource Groups if there has been an issue with the End to End tests.
# CAUTION: Make sure you are connected to the correct subscription before running this script!
az account show
$resourceGroups = az group list --query "[?contains(name, '227-')]" | ConvertFrom-Json

$resourceGroups | ForEach-Object -Parallel {
    Write-Host "Deleting resource group: $($_.name)"
    az group delete --name $_.name --yes
} -ThrottleLimit 10


# GitHub
$repos = gh repo list microsoft-azure-landing-zones-cd-tests --json name,owner | ConvertFrom-Json

$repos | ForEach-Object -Parallel {
    $match = "*168*"
    $repoName = "$($_.owner.login)/$($_.name)"
    
    if($repoName -like $match)
    {
        Write-Host "Deleting repo: $repoName"
        gh repo delete $repoName --yes
    
    }
} -ThrottleLimit 10