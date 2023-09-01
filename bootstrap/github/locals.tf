# Version Control System Settings
locals {
  github = "github"
  azure_devops = "azuredevops"
  is_github = var.version_control_system == local.github
  is_azure_devops = var.version_control_system == local.azure_devops
}

# Azure DevOps URL Settings
locals {
  azure_devops_url = var.azure_devops_use_organisation_legacy_url ? "https://dev.azure.com/${var.version_control_system_organization}" : "https://${var.version_control_system_organization}.visualstudio.com"
}

# Workload Identity Federation (OpenID Connect) Settings
locals {
  github_issuer     = "https://token.actions.githubusercontent.com"
  github_subject = "repo:${var.version_control_system_organization}/${local.resource_names.version_control_system_repository}:environment:${local.resource_names.version_control_system_environment}"
  
  azure_devops_issuer  = local.is_azure_devops ? "https://vstoken.dev.azure.com/${module.azure_devops[0].organization_id}" : ""
  azure_devops_subject = "sc://${var.version_control_system_organization}/${var.azure_devops_project_name}/${local.resource_names.version_control_system_service_connection}}"
  
  audience = "api://AzureADTokenExchange"
  issuer = local.is_azure_devops ? local.azure_devops_issuer : local.github_issuer
  subject = local.is_azure_devops ? local.azure_devops_subject : local.github_subject
}

# Azure DevOps Authentication Scheme Settings
locals {
  authentication_scheme_managed_identity = "ManagedIdentity"
  authentication_scheme_workload_identity_federation = "WorkloadIdentityFederation"
  is_authentication_scheme_managed_identity = var.azure_devops_authentication_scheme == local.authentication_scheme_managed_identity
  is_authentication_scheme_workload_identity_federation = var.azure_devops_authentication_scheme == local.authentication_scheme_workload_identity_federation
}

# Resource Name Setup
locals {
  resource_names = module.resource_names.resource_names
}