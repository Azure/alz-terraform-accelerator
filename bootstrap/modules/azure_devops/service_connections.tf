locals {
  service_connections = {
    plan = {
      name                 = var.service_connection_plan_name
      service_principal_id = var.managed_identity_plan_client_id
    }
    apply = {
      name                 = var.service_connection_apply_name
      service_principal_id = var.managed_identity_apply_client_id
    }
  }
}

resource "azuredevops_serviceendpoint_azurerm" "alz" {
  for_each                               = local.service_connections
  project_id                             = local.project_id
  service_endpoint_name                  = each.value.name
  description                            = "Managed by Terraform"
  service_endpoint_authentication_scheme = var.authentication_scheme

  dynamic "credentials" {
    for_each = local.is_authentication_scheme_workload_identity_federation ? [1] : []
    content {
      serviceprincipalid = each.value.service_principal_id
    }
  }

  azurerm_spn_tenantid      = var.azure_tenant_id
  azurerm_subscription_id   = var.azure_subscription_id
  azurerm_subscription_name = var.azure_subscription_name
}
