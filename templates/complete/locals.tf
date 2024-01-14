locals {
  config_template_file_variables = {
    default_location                = var.default_location
    root_parent_management_group_id = var.root_parent_management_group_id == "" ? data.azurerm_client_config.core.tenant_id : var.root_parent_management_group_id
    subscription_id_connectivity    = var.subscription_id_connectivity
    subscription_id_identity        = var.subscription_id_identity
    subscription_id_management      = var.subscription_id_management
  }
  config = yamldecode(templatefile("${path.module}/config.yaml", local.config_template_file_variables))
}
locals {
  archetypes = try(merge(local.config.archetypes, {}), {})
}
locals {
  hub_virtual_networks = try(merge(local.config.connectivity.hubnetworking.hub_virtual_networks, {}), {})
  module_hubnetworking = {
    hub_virtual_networks = {
      for key, hub_virtual_network in local.hub_virtual_networks : key => {
        for argument, value in hub_virtual_network : argument => value if argument != "virtual_network_gateway"
      }
    }
  }
  module_virtual_network_gateway = {
    for key, hub_virtual_network in local.hub_virtual_networks : key => merge(
      hub_virtual_network.virtual_network_gateway,
      {
        location                            = hub_virtual_network.location
        virtual_network_name                = hub_virtual_network.name
        virtual_network_resource_group_name = hub_virtual_network.resource_group_name
      }
    )
    if can(hub_virtual_network.virtual_network_gateway)
  }
}
