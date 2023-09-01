resource "azuredevops_serviceendpoint_azurerm" "oidc" {
  for_each = local.oidc_environments
  project_id                    = data.azuredevops_project.example.id
  service_endpoint_name         = "service_connection_${each.value}"
  description                   = "Managed by Terraform"
  service_endpoint_authentication_scheme = "WorkloadIdentityFederation"
  credentials {
    serviceprincipalid  = local.security_option.oidc_with_app_registration ? azuread_application.github_oidc[each.value].application_id : azurerm_user_assigned_identity.example[each.value].client_id
  }
  azurerm_spn_tenantid      = data.azurerm_client_config.current.tenant_id
  azurerm_subscription_id   = data.azurerm_client_config.current.subscription_id
  azurerm_subscription_name = data.azurerm_subscription.current.display_name
}

resource "azuredevops_serviceendpoint_azurerm" "mi" {
  for_each = local.mi_environments
  project_id                    = data.azuredevops_project.example.id
  service_endpoint_name         = "service_connection_${each.value}"
  description                   = "Managed by Terraform"
  service_endpoint_authentication_scheme = "ManagedServiceIdentity"
  azurerm_spn_tenantid      = data.azurerm_client_config.current.tenant_id
  azurerm_subscription_id   = data.azurerm_client_config.current.subscription_id
  azurerm_subscription_name = data.azurerm_subscription.current.display_name
}

resource "azuredevops_pipeline_authorization" "oidc_endpoint" {
  for_each    = local.oidc_environments
  project_id  = data.azuredevops_project.example.id
  resource_id = azuredevops_serviceendpoint_azurerm.oidc[each.value].id
  type        = "endpoint"
  pipeline_id = azuredevops_build_definition.oidc[0].id
}

resource "azuredevops_pipeline_authorization" "mi_endpoint" {
  for_each    = local.mi_environments
  project_id  = data.azuredevops_project.example.id
  resource_id = azuredevops_serviceendpoint_azurerm.mi[each.value].id
  type        = "endpoint"
  pipeline_id = azuredevops_build_definition.mi[0].id
}