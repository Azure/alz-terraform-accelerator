locals {
  default_audience_name = "api://AzureADTokenExchange"
  github_issuer_url     = "https://token.actions.githubusercontent.com"
  azure_devops_issuer_url            = "https://vstoken.dev.azure.com/${local.azure_devops_organization_id}"
}