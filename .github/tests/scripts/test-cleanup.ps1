param (
    [string]$managementGroupsPrefix = "alz-acc-avm-test",
    [int]$managementGroupStartNumber = 1,
    [int]$managementGroupCount = 11,
    [string]$subscriptionNamePrefix = "alz-acc-avm-test-",
    [int]$subscriptionStartNumber = 1,
    [int]$subscriptionCount = 11,
    [string[]]$subscriptionPostfixes = @("-connectivity", "-management", "-identity", "-security")
)

Install-Module -Name ALZ -Force -AllowClobber -Scope CurrentUser

$managementGroups = @()
$managementGroupIndexes = $managementGroupStartNumber..($managementGroupStartNumber + $managementGroupCount - 1)
foreach ($i in $managementGroupIndexes) {
    $managementGroupsPrefix = $managementGroupsPrefix
    $managementGroupName = "{0}-{1:D2}" -f $managementGroupsPrefix, $i
    $managementGroups += $managementGroupName
}

$subscriptions = @()
$subscriptionIndexes = $subscriptionStartNumber..($subscriptionStartNumber + $subscriptionCount - 1)

foreach ($i in $subscriptionIndexes) {
    $subscriptionNamePrefix = $subscriptionNamePrefix
    $subscriptionPostfixes = $subscriptionPostfixes
    foreach ($postfix in $subscriptionPostfixes) {
        $subscriptionNamePrefix = $subscriptionNamePrefix
        $subscriptionName = "{0}{1:D2}{2}" -f $subscriptionNamePrefix, $i, $postfix
        $subscriptions += $subscriptionName
    }
}

Remove-PlatformLandingZone `
    -ManagementGroups $managementGroups `
    -Subscriptions $subscriptions `
    -BypassConfirmation `
    -BypassConfirmationTimeoutSeconds 0
