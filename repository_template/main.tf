module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "4.2.0"

  default_location = var.default_location
  root_parent_id   = data.azurerm_client_config.core.tenant_id

  deploy_corp_landing_zones   = true
  deploy_online_landing_zones = true

  deploy_management_resources    = false
  subscription_id_management     = var.subscription_id_management
  configure_management_resources = local.configure_management_resources

  deploy_connectivity_resources    = false
  subscription_id_connectivity     = var.subscription_id_connectivity
  configure_connectivity_resources = local.configure_connectivity_resources

  deploy_identity_resources    = false
  subscription_id_identity     = var.subscription_id_identity
  configure_identity_resources = local.configure_identity_resources

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
    azurerm.management   = azurerm.management
  }
}
