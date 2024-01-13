param (
    [string]$organizationName,
    [string]$repositoryName,
    [string]$personalAccessToken,
    [string]$workflowFileName = "cd.yaml",
    [switch]$skipDestroy = $false,
    [int]$maximumRetries = 10,
    [int]$retryCount = 0,
    [int]$retryDelay = 10000
)

function Trigger-Workflow {
    param (
        [string]$organizationName,
        [string]$repositoryName,
        [string]$workflowId,
        [string]$workflowAction = "",
        [hashtable]$headers
    )
    $workflowDispatchUrl = "https://api.github.com/repos/$organizationName/$repositoryName/actions/workflows/$workflowId/dispatches"
    Write-Host "Workflow Dispatch URL: $workflowDispatchUrl"

    $workflowDispatchBody = @{}
    if($workflowAction -eq "") {
        $workflowDispatchBody = @{
            ref = "main"
        } | ConvertTo-Json -Depth 100
    } else {
        $workflowDispatchBody = @{
            ref = "main"
            inputs = @{
                terraform_action = $workflowAction
            }
        } | ConvertTo-Json -Depth 100
    }

    $result = Invoke-RestMethod -Method POST -Uri $workflowDispatchUrl -Headers $headers -Body $workflowDispatchBody -StatusCodeVariable statusCode
    if ($statusCode -ne 204) {
        throw "Failed to dispatch the workflow."
    }
}

function Wait-ForWorkflowRunToComplete {
    param (
        [string]$organizationName,
        [string]$repositoryName,
        [hashtable]$headers
    )

    $workflowRunUrl = "https://api.github.com/repos/$organizationName/$repositoryName/actions/runs"
    Write-Host "Workflow Run URL: $workflowRunUrl"

    $workflowRunStatus = ""
    $workflowRunConclusion = ""
    while($workflowRunStatus -ne "completed") {
        Start-Sleep -Seconds 10
        
        $workflowRun = Invoke-RestMethod -Method GET -Uri $workflowRunUrl -Headers $headers -StatusCodeVariable statusCode
        if ($statusCode -eq 200) {
            $workflowRunStatus = $workflowRun.workflow_runs[0].status
            $workflowRunConclusion = $workflowRun.workflow_runs[0].conclusion
            Write-Host "Workflow Run Status: $workflowRunStatus - Conclusion: $workflowRunConclusion"
        } else {
            Write-Host "Failed to find the workflow run. Status Code: $statusCode"
        }
    }

    if($workflowRunConclusion -ne "success") {
        throw "The workflow run did not complete successfully. Conclusion: $workflowRunConclusion"
    }
}

# Setup Variables
$token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$personalAccessToken"))
$headers = @{
    "Authorization" = "Basic $token"
    "Accept" = "application/vnd.github+json"
}

# Run the Module in a retry loop
$success = $false

do {
$retryCount++
try {
    # Get the workflow id
    Write-Host "Getting the workflow id"
    $workflowUrl = "https://api.github.com/repos/$organizationName/$repositoryName/actions/workflows/$workflowFileName"
    Write-Host "Workflow URL: $workflowUrl"
    $workflow = Invoke-RestMethod -Method GET -Uri $workflowUrl -Headers $headers -StatusCodeVariable statusCode
    if ($statusCode -ne 200) {
        throw "Failed to find the workflow."
    }
    $workflowId = $workflow.id
    Write-Host "Workflow ID: $workflowId"

    $workflowAction = ""

    if(!($skipDestroy)) {
        $workflowAction = "apply"
    }

    # Trigger the apply workflow
    Write-Host "Triggering the $workflowAction workflow"
    Trigger-Workflow -organizationName $organizationName -repositoryName $repositoryName -workflowId $workflowId -workflowAction $workflowAction -headers $headers
    Write-Host "$workflowAction workflow triggered successfully"

    # Wait for the apply workflow to complete
    Write-Host "Waiting for the $workflowAction workflow to complete"
    Wait-ForWorkflowRunToComplete -organizationName $organizationName -repositoryName $repositoryName -headers $headers
    Write-Host "$workflowAction workflow completed successfully"

    if($skipDestroy) {
        $success = $true
        break
    }

    $workflowAction = "destroy"

    # Trigger the destroy workflow
    Write-Host "Triggering the $workflowAction workflow"
    Trigger-Workflow -organizationName $organizationName -repositoryName $repositoryName -workflowId $workflowId -workflowAction $workflowAction -headers $headers
    Write-Host "$workflowAction workflow triggered successfully"

    # Wait for the apply workflow to complete
    Write-Host "Waiting for the $workflowAction workflow to complete"
    Wait-ForWorkflowRunToComplete -organizationName $organizationName -repositoryName $repositoryName -headers $headers
    Write-Host "$workflowAction workflow completed successfully"

    $success = $true
} catch {
    Write-Host $_
    Write-Host "Failed to trigger the workflow successfully, trying again..."
}
} while ($success -eq $false -and $retryCount -lt $maximumRetries)

if ($success -eq $false) {
    throw "Failed to trigger the workflow after $maximumRetries attempts."
}
