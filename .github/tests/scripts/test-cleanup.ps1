param (
    [string]$managementGroupsPrefix = "alz-acc-avm-test",
    [int]$managementGroupStartNumber = 1,
    [int]$managementGroupCount = 11,
    [string]$subscriptionNamePrefix = "alz-acc-avm-test-",
    [int]$subscriptionStartNumber = 1,
    [int]$subscriptionCount = 11,
    [string[]]$subscriptionPostfixes = @("-connectivity", "-management", "-identity")
)
function Get-ManagementGroupChildrenRecursive {
    param (
        [object[]]$managementGroups,
        [int]$depth = 0,
        [hashtable]$managementGroupsFound = @{}
    )

    foreach($managementGroup in $managementGroups) {
        if(!$managementGroupsFound.ContainsKey($depth)) {
            $managementGroupsFound[$depth] = @()
        }

        $managementGroupsFound[$depth] += $managementGroup.name

        if ($managementGroup.children -and $managementGroup.children.Count -gt 0) {
            Write-Host "Management group: $($managementGroup.name) has children."
            if(!$managementGroupsFound.ContainsKey($depth + 1)) {
                $managementGroupsFound[$depth + 1] = @()
            }
            Get-ManagementGroupChildrenRecursive -managementGroups $managementGroup.children -depth ($depth + 1) -managementGroupsFound $managementGroupsFound
        } else {
            Write-Host "Management group: $($managementGroup.name) has no children."
        }
    }

    if($depth -eq 0) {
       return $managementGroupsFound
    }
}

$funcDef = ${function:Get-ManagementGroupChildrenRecursive}.ToString()

$managementGroupIndexes = $managementGroupStartNumber..($managementGroupStartNumber + $managementGroupCount - 1)
$managementGroupIndexes | ForEach-Object -Parallel {
    $i = $_
    $managementGroupsPrefix = $using:managementGroupsPrefix

    $managementGroupId = "{0}-{1:D2}" -f $managementGroupsPrefix, $i
    Write-Host "Finding management group: $managementGroupId"
    $topLevelManagementGroup = (az account management-group show --name $managementGroupId --expand --recurse) | ConvertFrom-Json

    $hasChildren = $topLevelManagementGroup.children -and $topLevelManagementGroup.children.Count -gt 0

    $managementGroupsToDelete = @{}

    if($hasChildren) {
        ${function:Get-ManagementGroupChildrenRecursive} = $using:funcDef
        $managementGroupsToDelete = Get-ManagementGroupChildrenRecursive -managementGroups @($topLevelManagementGroup.children)
    } else {
        Write-Host "Management group: $managementGroupId has no children"
    }

    $reverseKeys = $managementGroupsToDelete.Keys | Sort-Object -Descending
    foreach($depth in $reverseKeys) {
        $managementGroups = $managementGroupsToDelete[$depth]

        Write-Host "Deleting management groups at depth $depth"

        $managementGroups | ForEach-Object -Parallel {
            $subscriptions = (az account management-group subscription show-sub-under-mg --name $_) | ConvertFrom-Json
            if ($subscriptions.Count -gt 0) {
                Write-Host "Management group: $_ has subscriptions."
                foreach ($subscription in $subscriptions) {
                    Write-Host "Removing subscription: $($subscription.subscriptionId) from management group: $_"
                    az account management-group subscription remove --name $_ --subscription $subscription.name
                }
            } else {
                Write-Host "Management group: $_ has no subscriptions."
            }

            Write-Host "Deleting management group: $_"
            az account management-group delete --name $_
        } -ThrottleLimit 11
    }
} -ThrottleLimit 11

$subscriptionIndexes = $subscriptionStartNumber..($subscriptionStartNumber + $subscriptionCount - 1)

$subscriptionIndexes | ForEach-Object -Parallel {
    $i = $_
    $subscriptionNamePrefix = $using:subscriptionNamePrefix
    $subscriptionPostfixes = $using:subscriptionPostfixes
    $subscriptionPostfixes | ForEach-Object -Parallel {
        $postfix = $_
        $i = $using:i
        $subscriptionNamePrefix = $using:subscriptionNamePrefix
        $subscriptionName = "{0}{1:D2}{2}" -f $subscriptionNamePrefix, $i, $postfix
        Write-Host "Finding subscription resource groups for: $subscriptionName"

        $subscriptionId = (az account list --all --query "[?name=='$subscriptionName'].id" -o tsv)
        if (-not $subscriptionId) {
            Write-Host "Subscription $subscriptionName not found, skipping."
            continue
        }

        $resourceGroups = (az group list --subscription $subscriptionId) | ConvertFrom-Json

        if ($resourceGroups.Count -eq 0) {
            Write-Host "No resource groups found for subscription: $subscriptionName"
            continue
        }

        Write-Host "Found $($resourceGroups.Count) resource groups for subscription: $subscriptionName"

        $resourceGroupsToDelete = @()

        foreach ($resourceGroup in $resourceGroups) {
            $resourceGroupsToDelete += @{
                ResourceGroupName = $resourceGroup.name
                SubscriptionId = $subscriptionId
            }
        }

        $shouldRetry = $true

        while($shouldRetry) {
            $shouldRetry = $false
            $resourceGroupsToRetry = [System.Collections.Concurrent.ConcurrentBag[hashtable]]::new()
            $resourceGroupsToDelete | ForEach-Object -Parallel {
                $subscriptionName = $using:subscriptionName
                Write-Host "Deleting resource group: $($_.ResourceGroupName) in subscription: $subscriptionName"
                $result = az group delete --name $_.ResourceGroupName --subscription $_.SubscriptionId --yes 2>&1

                if (!$result) {
                    Write-Host "Resource group $($_.ResourceGroupName) in subscription: $subscriptionName deleted successfully."
                } else {
                    Write-Host "Failed to delete resource group: $($_.ResourceGroupName) in subscription: $subscriptionName. It will be retried once the other resource groups in the subscription have reported their status."
                    Write-Verbose "$result"
                    $retries = $using:resourceGroupsToRetry
                    $retries.Add($_)
                }
            } -ThrottleLimit 10

            if($resourceGroupsToRetry.Count -gt 0) {
                Write-Host "Some resource groups failed to delete in subscription: $subscriptionName, retrying..."
                $shouldRetry = $true
                $resourceGroupsToDelete = $resourceGroupsToRetry.ToArray()
            } else {
                Write-Host "All resource groups deleted successfully in subscription: $subscriptionName."
            }
        }
    } -ThrottleLimit 11
} -ThrottleLimit 11