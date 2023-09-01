resource "azuredevops_serviceendpoint_azurerm" "alz" {
  project_id                    = local.project_id
  service_endpoint_name         = var.service_connection_name
  description                   = "Managed by Terraform"
  service_endpoint_authentication_scheme = var.authentication_scheme

  dynamic "credentials" {
    for_each = local.is_authentication_scheme_workload_identity_federation ? [1] : []
    content {
      serviceprincipalid  = var.managed_identity_client_id
    }
  }

  azurerm_spn_tenantid      = var.azure_tenant_id
  azurerm_subscription_id   = var.azure_subscription_id
  azurerm_subscription_name = var.azure_subscription_name
}

