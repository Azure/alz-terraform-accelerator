data "azurerm_client_config" "current" {}

locals {
  base_config_replacements = {
    default_location = var.default_location
    default_postfix  = var.default_postfix
    tenant_id        = data.azurerm_client_config.current.tenant_id
    subscription_id_connectivity = var.subscription_id_connectivity
    subscription_id_identity     = var.subscription_id_identity
    subscription_id_management   = var.subscription_id_management
  }

  initial_config = yamldecode(templatefile("${path.module}/config.yaml", local.base_config_replacements))

  management = local.initial_config.management
}

locals {
  post_management_config_replacements = merge(local.base_config_replacements, {
    management_log_analytics_workspace_id = module.alz_management_resources.log_analytics_workspace.id
  })

  post_management_config = yamldecode(templatefile("${path.module}/config.yaml", local.post_management_config_replacements))

  management_groups = local.post_management_config.management.management_groups

  hub_virtual_networks = {
    for k, v in local.config.connectivity.hubnetworking.hub_virtual_networks : k => {
      for k2, v2 in v : k2 => v2 if k2 != "virtual_network_gateway"
    }
  }
  vritual_network_gateways = {
    for k, v in local.config.connectivity.hubnetworking.hub_virtual_networks : k => merge(
      v.virtual_network_gateway,
      {
        location                            = v.location
        virtual_network_name                = v.name
        virtual_network_resource_group_name = v.resource_group_name
      }
    )
  }
  dummy_hub_virtual_network = {
    hub = {
      name                = "dummy"
      address_space       = ["0.0.0.0/0"]
      location            = "dummy"
      resource_group_name = "dummy"
    }
  }
}
