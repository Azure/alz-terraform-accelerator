output "organization_url" {
    value = local.organization_url
}

output "subject" {
    value = local.is_authentication_scheme_workload_identity_federation ? azuredevops_serviceendpoint_azurerm.alz.workload_identity_federation_subject : ""
}

output "issuer" {
    value = local.is_authentication_scheme_workload_identity_federation ? azuredevops_serviceendpoint_azurerm.alz.workload_identity_federation_issuer : ""
}

output "agent_pool_name" {
    value = local.is_authentication_scheme_managed_identity ? azuredevops_agent_pool.alz.name : ""
}

output "is_authentication_scheme_managed_identity" {
    value = local.is_authentication_scheme_managed_identity
}

output "is_authentication_scheme_workload_identity_federation" {
    value = local.is_authentication_scheme_workload_identity_federation
}