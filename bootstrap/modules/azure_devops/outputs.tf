output "subject" {
    value = "sc://${var.organization_name}/${var.project_name}/${azuredevops_serviceendpoint_azurerm.alz.service_endpoint_name}"
}

output "issuer" {
    value = "https://vstoken.dev.azure.com/${local.azure_devops_organization_id}"
}