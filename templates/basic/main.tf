module "enterprise-scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "4.2.0"

  disable_telemetry = true

  default_location = var.default_location
  root_parent_id   = data.azurerm_client_config.core.tenant_id

  deploy_corp_landing_zones    = true
  deploy_management_resources  = true
  deploy_online_landing_zones  = true
  root_id                      = var.root_id
  root_name                    = var.root_name
  subscription_id_connectivity = var.subscription_id_connectivity
  subscription_id_identity     = var.subscription_id_identity
  subscription_id_management   = var.subscription_id_management

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
    azurerm.management   = azurerm.management
  }
}
