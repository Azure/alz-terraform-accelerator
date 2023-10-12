# This file can be used to clean up Resource Groups if there has been an issue with the End to End tests.
# CAUTION: Make sure you are connected to the correct subscription before running this script!
az account show
$resourceGroups = az group list --query "[?contains(name, '20-')]" | ConvertFrom-Json
foreach($resourceGroup in $resourceGroups) {
    Write-Host "Deleting resource group: $($resourceGroup.name)"
    az group delete --name $resourceGroup.name --yes
}