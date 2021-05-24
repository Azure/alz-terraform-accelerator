data "azurerm_client_config" "core" {
  provider = azurerm.core
}

data "azurerm_client_config" "management" {
  provider = azurerm.management
}

module "es_core" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "~> 0.3.2"
  providers = {
    azurerm = azurerm.management
  }

  # Base module configuration settings.
  root_parent_id   = data.azurerm_client_config.core.tenant_id
  root_id          = local.root_id
  root_name        = local.root_name
  library_path     = "${path.root}/lib"
  default_location = local.default_location

  # Configure deployment of core and demo landing zones
  deploy_core_landing_zones = true
  deploy_demo_landing_zones = local.deploy_demo_landing_zones

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
  deploy_management_resources    = false
  configure_management_resources = local.configure_management_resources
  subscription_id_management     = data.azurerm_client_config.management.subscription_id

  # Configuration settings for tuning module deployment
  # Please refer to file: settings.tuning.tf
  create_duration_delay  = local.create_duration_delay
  destroy_duration_delay = local.destroy_duration_delay

}

module "es_mgmt" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "~> 0.3.2"
  providers = {
    azurerm = azurerm.management
  }

  # Base module configuration settings.
  root_parent_id   = data.azurerm_client_config.core.tenant_id
  root_id          = local.root_id
  root_name        = local.root_name
  library_path     = "${path.root}/lib"
  default_location = local.default_location

  # Configure deployment of core and demo landing zones
  # These should bother be set to false in the management
  # resources deployment
  deploy_core_landing_zones = false
  deploy_demo_landing_zones = false

  # Configuration settings for management resources.
  # If deploy_management_resources is set to false,
  # module.enterprise_scale_management will not deploy
  # any resources.
  # Please refer to file: settings.management.tf
  deploy_management_resources    = local.deploy_management_resources
  configure_management_resources = local.configure_management_resources
  subscription_id_management     = data.azurerm_client_config.management.subscription_id

  # Configuration settings for tuning module deployment
  # Only used for core resources

}
