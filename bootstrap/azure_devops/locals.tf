# Azure DevOps URL Settings
locals {
  azure_devops_url = var.azure_devops_use_organisation_legacy_url ? "https://dev.azure.com/${var.version_control_system_organization}" : "https://${var.version_control_system_organization}.visualstudio.com"
}

# Azure DevOps Authentication Scheme Settings
locals {
  authentication_scheme_managed_identity = "ManagedServiceIdentity"
  authentication_scheme_workload_identity_federation = "WorkloadIdentityFederation"
  is_authentication_scheme_managed_identity = var.azure_devops_authentication_scheme == local.authentication_scheme_managed_identity
  is_authentication_scheme_workload_identity_federation = var.azure_devops_authentication_scheme == local.authentication_scheme_workload_identity_federation
}

# Resource Name Setup
locals {
  resource_names = module.resource_names.resource_names
}