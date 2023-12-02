param(
    [string]$patToken,
    [string]$organizationName
)

# Install the Azure DevOps Terraform extension
Write-Host "Checking and Installing the Azure DevOps Microsoft DevLabs Terraform extension..."
$extensionName = "custom-terraform-tasks"
$extensionPublisher = "ms-devlabs"
$extensionInstallUrl = "https://extmgmt.dev.azure.com/${organizationName}/_apis/extensionmanagement/installedextensionsbyname/${extensionPublisher}/${extensionName}?api-version=7.0-preview.1"

$base64PatToken = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("`:$patToken"))

$headers=@{
    "Authorization" = "Basic $base64PatToken"
}

Invoke-RestMethod -Uri $extensionInstallUrl `
                  -Method 'POST' `
                  -ContentType 'application/json' `
                  -Headers $headers `
                  -StatusCodeVariable statusCode `
                  -SkipHttpErrorCheck `
                  | Set-Variable result

if($statusCode -eq 409)
{
    Write-Host "Extension already installed"
}
else
{
    Write-Host "Installed version $($result.version) of extension $($result.publisherName) $($result.extensionName)"
}
