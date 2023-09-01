locals {
  default_audience_name = "api://AzureADTokenExchange"
  github_issuer_url     = "https://token.actions.githubusercontent.com"
  azure_devops_issuer_url            = "https://vstoken.dev.azure.com/${local.azure_devops_organization_id}"
}

locals {
  github = "github"
  azure_devops = "azuredevops"
  is_github = var.version_control_system == local.github
  is_azure_devops = var.version_control_system == local.azure_devops
}

locals {
  authentication_scheme_managed_identity = "ManagedIdentity"
  authentication_scheme_workload_identity_federation = "WorkloadIdentityFederation"
  is_authentication_scheme_managed_identity = var.azure_devops_authentication_scheme == local.authentication_scheme_managed_identity
  is_authentication_scheme_workload_identity_federation = var.azure_devops_authentication_scheme == local.authentication_scheme_workload_identity_federation
}

locals {
  formatted_postfix_number = format("%03d", var.postfix_number)
  resource_names = {
    for key, value in var.resource_names : key => replace(replace(replace(replace(replace(value, 
      "{{service_name}}", var.service_name), 
      "{{environment_name}}", var.environment_name),
      "{{azure_location}}", var.azure_location),
      "{{azure_location_short}}", substr(var.azure_location,0,3)),
      "{{postfix_number}}", local.formatted_postfix_number)
  }
}