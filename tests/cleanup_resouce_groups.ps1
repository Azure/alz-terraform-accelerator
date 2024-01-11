# This file can be used to clean up Resource Groups if there has been an issue with the End to End tests.
# CAUTION: Make sure you are connected to the correct subscription before running this script!
az account show
$resourceGroups = az group list --query "[?contains(name, '223-')]" | ConvertFrom-Json

$resourceGroups | ForEach-Object -Parallel {
    Write-Host "Deleting resource group: $($_.name)"
    az group delete --name $_.name --yes
} -ThrottleLimit 10