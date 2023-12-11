locals {
  root_management_group_id = var.root_management_group_id == "" ? data.azurerm_client_config.current.tenant_id : var.root_management_group_id

  base_config_replacements = {
    default_location             = var.default_location
    default_postfix              = var.default_postfix
    root_management_group_id     = local.root_management_group_id
    subscription_id_connectivity = var.subscription_id_connectivity
    subscription_id_identity     = var.subscription_id_identity
    subscription_id_management   = var.subscription_id_management
  }

  initial_config = yamldecode(templatefile("${path.module}/config.yaml", local.base_config_replacements))

  management   = local.initial_config.management
  connectivity = local.initial_config.connectivity

  hub_virtual_networks = {
    for k, v in local.connectivity.hub_networking.hub_virtual_networks : k => {
      for k2, v2 in v : k2 => v2 if k2 != "virtual_network_gateway"
    }
  }
  virtual_network_gateways = {
    for k, v in local.connectivity.hub_networking.hub_virtual_networks : k => merge(
      v.virtual_network_gateway,
      {
        location                            = v.location
        virtual_network_name                = v.name
        virtual_network_resource_group_name = v.resource_group_name
      }
    )
  }
}
