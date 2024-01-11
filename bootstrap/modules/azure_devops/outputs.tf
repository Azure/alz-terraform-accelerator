output "organization_url" {
  value = local.organization_url
}

output "subjects" {
  value = local.is_authentication_scheme_workload_identity_federation ? { for key, value in var.environments : key => azuredevops_serviceendpoint_azurerm.alz[key].workload_identity_federation_subject } : {}
}

output "issuers" {
  value = local.is_authentication_scheme_workload_identity_federation ? { for key, value in var.environments : key => azuredevops_serviceendpoint_azurerm.alz[key].workload_identity_federation_issuer } : {}
}

output "agent_pool_names" {
  value = { for key, value in var.agent_pools : key => azuredevops_agent_pool.alz[key].name }
}

output "is_authentication_scheme_managed_identity" {
  value = local.is_authentication_scheme_managed_identity
}

output "is_authentication_scheme_workload_identity_federation" {
  value = local.is_authentication_scheme_workload_identity_federation
}
