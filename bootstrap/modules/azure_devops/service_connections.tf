resource "azuredevops_serviceendpoint_azurerm" "alz" {
  for_each                               = var.environments
  project_id                             = local.project_id
  service_endpoint_name                  = each.value.service_connection_name
  description                            = "Managed by Terraform"
  service_endpoint_authentication_scheme = var.authentication_scheme

  dynamic "credentials" {
    for_each = local.is_authentication_scheme_workload_identity_federation ? [1] : []
    content {
      serviceprincipalid = var.managed_identity_client_ids[each.key]
    }
  }

  azurerm_spn_tenantid      = var.azure_tenant_id
  azurerm_subscription_id   = var.azure_subscription_id
  azurerm_subscription_name = var.azure_subscription_name
}

resource "azuredevops_check_approval" "alz" {
  count                = length(var.approvers) == 0 ? 0 : 1
  project_id           = local.project_id
  target_resource_id   = azuredevops_serviceendpoint_azurerm.alz[local.apply_key].id
  target_resource_type = "endpoint"

  requester_can_approve = length(var.approvers) == 1
  approvers = [
    azuredevops_group.alz_approvers.origin_id
  ]

  timeout = 43200
}

resource "azuredevops_check_exclusive_lock" "alz" {
  for_each             = var.environments
  project_id           = local.project_id
  target_resource_id   = azuredevops_serviceendpoint_azurerm.alz[each.key].id
  target_resource_type = "endpoint"
  timeout              = 43200
}
