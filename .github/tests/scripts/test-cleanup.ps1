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
    $i = $_
    $managementGroupsPrefix = $using:managementGroupsPrefix
    $managementGroupId = "{0}-{1:D2}" -f $managementGroupsPrefix, $i
    $managementGroups += $managementGroupId
}

$subscriptions = @()
$subscriptionIndexes = $subscriptionStartNumber..($subscriptionStartNumber + $subscriptionCount - 1)

foreach ($i in $subscriptionIndexes) {
    $i = $_
    $subscriptionNamePrefix = $using:subscriptionNamePrefix
    $subscriptionPostfixes = $using:subscriptionPostfixes
    foreach ($postfix in $subscriptionPostfixes) {
        $postfix = $_
        $i = $using:i
        $subscriptionNamePrefix = $using:subscriptionNamePrefix
        $subscriptionName = "{0}{1:D2}{2}" -f $subscriptionNamePrefix, $i, $postfix
        $subscriptions += $subscriptionName
    }
}

Remove-PlatformLandingZone -ManagementGroups $managementGroupNames -Subscriptions $subscriptions -Force
