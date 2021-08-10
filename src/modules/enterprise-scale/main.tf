data "azurerm_client_config" "core" {
  provider = azurerm.core
}

data "azurerm_client_config" "management" {
  provider = azurerm.management
}

data "azurerm_client_config" "connectivity" {
  provider = azurerm.connectivity
}

module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "~> 0.4.0"
  providers = {
    azurerm              = azurerm.core
    azurerm.management   = azurerm.management
    azurerm.connectivity = azurerm.connectivity
  }

  # Base module configuration settings.
  root_parent_id           = data.azurerm_client_config.core.tenant_id
  root_id                  = local.root_id
  root_name                = local.root_name
  library_path             = "${path.root}/lib"
  default_location         = local.default_location
  disable_base_module_tags = false


  # Configure deployment of core and demo landing zones.
  deploy_core_landing_zones   = true
  deploy_demo_landing_zones   = local.deploy_demo_landing_zones
  deploy_corp_landing_zones   = local.deploy_corp_landing_zones
  deploy_online_landing_zones = local.deploy_online_landing_zones
  deploy_sap_landing_zones    = local.deploy_sap_landing_zones

  # Configuration settings for core resources.
  # Please refer to file: settings.core.tf
  custom_landing_zones       = local.custom_landing_zones
  archetype_config_overrides = local.archetype_config_overrides
  subscription_id_overrides  = local.subscription_id_overrides

  # Configuration settings for management resources.
  # These are used to ensure Azure Policy is correctly
  # configured with the same settings as the resources
  # deployed by module.enterprise_scale_management.
  # Please refer to file: settings.management.tf
  deploy_management_resources    = local.deploy_management_resources
  configure_management_resources = local.configure_management_resources
  subscription_id_management     = data.azurerm_client_config.management.subscription_id

  # Configuration settings for connectivity resources.
  # These are used to ensure Azure Policy is correctly
  # configured with the same settings as the resources
  # deployed by module.enterprise_scale_connectivity.
  # Please refer to file: settings.connectivity.tf
  deploy_connectivity_resources    = local.deploy_connectivity_resources
  configure_connectivity_resources = local.configure_connectivity_resources
  subscription_id_connectivity     = data.azurerm_client_config.connectivity.subscription_id

  # Configuration settings for tuning module deployment.
  # Please refer to file: settings.tuning.tf
  create_duration_delay  = local.create_duration_delay
  destroy_duration_delay = local.destroy_duration_delay

}
