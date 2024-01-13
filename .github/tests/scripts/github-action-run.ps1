param (
    [string]$organizationName,
    [string]$repositoryName,
    [string]$personalAccessToken,
    [string]$workflowFileName = "cd.yaml",
    [int]$maximumRetries = 10,
    [int]$retryCount = 0,
    [int]$retryDelay = 10000
)

function Trigger-Workflow {
    param (
        [string]$organizationName,
        [string]$repositoryName,
        [string]$workflowId,
        [string]$workflowAction = "apply",
        [hashtable]$headers
    )
    $workflowDispatchUrl = "https://api.github.com/repos/$organizationName/$repositoryName/actions/workflows/$workflowId/dispatches"
    Write-Host "Workflow Dispatch URL: $workflowDispatchUrl"
    $workflowDispatchBody = @{
        ref = "main"
        inputs = @{
            terraform_action = $workflowAction
        }
    } | ConvertTo-Json -Depth 100
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

    # Trigger the apply workflow
    Write-Host "Triggering the apply workflow"
    Trigger-Workflow -organizationName $organizationName -repositoryName $repositoryName -workflowId $workflowId -workflowAction "apply" -headers $headers
    Write-Host "Apply workflow triggered successfully"

    # Wait for the apply workflow to complete
    Write-Host "Waiting for the apply workflow to complete"
    Wait-ForWorkflowRunToComplete -organizationName $organizationName -repositoryName $repositoryName -headers $headers
    Write-Host "Apply workflow completed successfully"

    # Trigger the destroy workflow
    Write-Host "Triggering the destroy workflow"
    Trigger-Workflow -organizationName $organizationName -repositoryName $repositoryName -workflowId $workflowId -workflowAction "destroy" -headers $headers
    Write-Host "Destroy workflow triggered successfully"

    # Wait for the apply workflow to complete
    Write-Host "Waiting for the destroy workflow to complete"
    Wait-ForWorkflowRunToComplete -organizationName $organizationName -repositoryName $repositoryName -headers $headers
    Write-Host "Destroy workflow completed successfully"

    $success = $true
} catch {
    Write-Host $_
    Write-Host "Failed to trigger the workflow successfully, trying again..."
}
} while ($success -eq $false -and $retryCount -lt $maximumRetries)

if ($success -eq $false) {
    throw "Failed to trigger the workflow after $maximumRetries attempts."
}
