locals {
  default_audience_name = "api://AzureADTokenExchange"
  github_issuer_url     = "https://token.actions.githubusercontent.com"
  #azure_devops_issuer_url            = "https://vstoken.dev.azure.com/${local.azure_devops_organization_id}"
}

locals {
  github = "github"
  azure_devops = "azuredevops"
  is_github = var.version_control_system == local.github
  is_azure_devops = var.version_control_system == local.azure_devops
}