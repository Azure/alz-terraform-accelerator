# Not used in the test, but saving for reference to be able to examine the plan file

$json = Get-Content .\tfplan.json -Raw | ConvertFrom-Json

$resources = $json.resource_changes | Where-Object { $_.address -like 'module.management_groups.module.management_groups.azapi_resource.policy_role_assignments*' }

$result = @()

foreach($resource in $resources) {
    $body = $resource.change.after.body
    $roleDefinitionId = $body.properties.roleDefinitionId
    $parentId = $resource.change.after.parent_id

    if($parentId -like "/providers/Microsoft.Management/managementGroups/*") {
        continue
    }

    Write-Output "Role Definition ID: $roleDefinitionId"
    Write-Output "Parent ID: $parentId"
    Write-Output "----------------------"

    $result += [PSCustomObject]@{
        RoleDefinitionId = $roleDefinitionId
        ParentId = $parentId
    }
}

$result | ConvertTo-Json | Out-File .\output.json
