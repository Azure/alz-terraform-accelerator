param (
    [string]$managementGroupsPrefix = "alz-acc-avm-test",
    [int]$managementGroupStartNumber = 1,
    [int]$managementGroupCount = 11,
    [string]$subscriptionNamePrefix = "alz-acc-avm-test-",
    [int]$subscriptionStartNumber = 1,
    [int]$subscriptionCount = 11,
    [string[]]$subscriptionPostfixes = @("-connectivity", "-management", "-identity", "-security")
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

        $children = $managementGroup.children | Where-Object { $_.type -eq "Microsoft.Management/managementGroups" }

        if ($children -and $children.Count -gt 0) {
            Write-Host "Management group has children: $($managementGroup.name)"
            if(!$managementGroupsFound.ContainsKey($depth + 1)) {
                $managementGroupsFound[$depth + 1] = @()
            }
            Get-ManagementGroupChildrenRecursive -managementGroups $children -depth ($depth + 1) -managementGroupsFound $managementGroupsFound
        } else {
            Write-Host "Management group has no children: $($managementGroup.name)"
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
        Write-Host "Management group has no children: $managementGroupId"
    }

    $reverseKeys = $managementGroupsToDelete.Keys | Sort-Object -Descending
    foreach($depth in $reverseKeys) {
        $managementGroups = $managementGroupsToDelete[$depth]

        Write-Host "Deleting management groups at depth: $depth"

        $managementGroups | ForEach-Object -Parallel {
            $subscriptions = (az account management-group subscription show-sub-under-mg --name $_) | ConvertFrom-Json
            if ($subscriptions.Count -gt 0) {
                Write-Host "Management group has subscriptions: $_"
                foreach ($subscription in $subscriptions) {
                    Write-Host "Removing subscription from management group: $_, subscription: $($subscription.displayName)"
                    az account management-group subscription remove --name $_ --subscription $subscription.name
                }
            } else {
                Write-Host "Management group has no subscriptions: $_"
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
        Write-Host "Finding resource groups for subscription: $subscriptionName"

        $subscriptionId = (az account list --all --query "[?name=='$subscriptionName'].id" -o tsv)
        if (-not $subscriptionId) {
            Write-Host "Subscription not found, skipping: $subscriptionName"
            continue
        }

        $resourceGroups = (az group list --subscription $subscriptionId) | ConvertFrom-Json

        if ($resourceGroups.Count -eq 0) {
            Write-Host "No resource groups found for subscription: $subscriptionName"
            continue
        }

        Write-Host "Found resource groups for subscription: $subscriptionName, count: $($resourceGroups.Count)"

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
                Write-Host "Deleting resource group for subscription: $subscriptionName, resource group: $($_.ResourceGroupName)"
                $result = az group delete --name $_.ResourceGroupName --subscription $_.SubscriptionId --yes 2>&1

                if (!$result) {
                    Write-Host "Deleted resource group for subscription: $subscriptionName, resource group: $($_.ResourceGroupName)"
                } else {
                    Write-Host "Delete resource group failed for subscription: $subscriptionName, resource group: $($_.ResourceGroupName)"
                    Write-Host "It will be retried once the other resource groups in the subscription have reported their status."
                    Write-Verbose "$result"
                    $retries = $using:resourceGroupsToRetry
                    $retries.Add($_)
                }
            } -ThrottleLimit 10

            if($resourceGroupsToRetry.Count -gt 0) {
                Write-Host "Some resource groups failed to delete and will be retried in subscription: $subscriptionName"
                $shouldRetry = $true
                $resourceGroupsToDelete = $resourceGroupsToRetry.ToArray()
            } else {
                Write-Host "All resource groups deleted successfully in subscription: $subscriptionName."
            }
        }
    } -ThrottleLimit 11
} -ThrottleLimit 11

Write-Host "Cleanup completed."
