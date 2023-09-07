output "subject" {
    value = local.is_authentication_scheme_workload_identity_federation ? azuredevops_serviceendpoint_azurerm.alz.workload_identity_federation_subject : ""
}

output "issuer" {
    value = local.is_authentication_scheme_workload_identity_federation ? azuredevops_serviceendpoint_azurerm.alz.workload_identity_federation_issuer : ""
}