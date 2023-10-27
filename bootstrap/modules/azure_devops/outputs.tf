output "organization_url" {
  value = local.organization_url
}

output "subjects" {
  value = {
    plan  = local.is_authentication_scheme_workload_identity_federation ? azuredevops_serviceendpoint_azurerm.alz["plan"].workload_identity_federation_subject : ""
    apply = local.is_authentication_scheme_workload_identity_federation ? azuredevops_serviceendpoint_azurerm.alz["apply"].workload_identity_federation_subject : ""
  }
}

output "issuer" {
  value = local.is_authentication_scheme_workload_identity_federation ? azuredevops_serviceendpoint_azurerm.alz["apply"].workload_identity_federation_issuer : ""
}

output "agent_pool_plan_name" {
  value = local.is_authentication_scheme_managed_identity ? azuredevops_agent_pool.alz["plan"].name : ""
}

output "agent_pool_apply_name" {
  value = local.is_authentication_scheme_managed_identity ? azuredevops_agent_pool.alz["apply"].name : ""
}

output "is_authentication_scheme_managed_identity" {
  value = local.is_authentication_scheme_managed_identity
}

output "is_authentication_scheme_workload_identity_federation" {
  value = local.is_authentication_scheme_workload_identity_federation
}
