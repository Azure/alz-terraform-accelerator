locals {
  config_file_extension = replace(lower(element(local.config_file_split, length(local.config_file_split) - 1)), local.const_yml, local.const_yaml)
  config_file_name      = var.configuration_file_path == "" ? "config.yaml" : basename(var.configuration_file_path)
  config_file_split     = split(".", local.config_file_name)
  const_yaml            = "yaml"
  const_yml             = "yml"
}
locals {
  config = (local.config_file_extension == local.const_yaml ?
    yamldecode(templatefile("${path.module}/${local.config_file_name}", local.config_template_file_variables)) :
    jsondecode(templatefile("${path.module}/${local.config_file_name}", local.config_template_file_variables))
  )
  config_template_file_variables = {
    default_location                = var.default_location
    default_postfix                 = var.default_postfix
    root_parent_management_group_id = var.root_parent_management_group_id == "" ? data.azurerm_client_config.core.tenant_id : var.root_parent_management_group_id
    subscription_id_connectivity    = var.subscription_id_connectivity
    subscription_id_identity        = var.subscription_id_identity
    subscription_id_management      = var.subscription_id_management
  }
}
locals {
  archetypes = try(merge(local.config.archetypes, {}), {})
}
locals {
  hub_virtual_networks = {
    for key, hub_virtual_network in try(merge(local.config.connectivity.hubnetworking.hub_virtual_networks, {}), {}) : key => {
      name                   = hub_virtual_network.name
      resource_group_name    = hub_virtual_network.resource_group_name
      location               = hub_virtual_network.location
      address_space          = hub_virtual_network.address_space
      subnets                = hub_virtual_network.subnets
      
      // If the `firewall` block exists, merge the new policy ID, otherwise keep the firewall block as-is
      firewall = merge(hub_virtual_network.firewall, {
        firewall_policy_id = azurerm_firewall_policy.this.id
      }) 

      // Maintain all other configuration as is
      virtual_network_gateway = hub_virtual_network.virtual_network_gateway
      // ... any other fields that your network structure has
    }
  }
 
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
        location           = hub_virtual_network.location
        virtual_network_id = module.hubnetworking[0].virtual_networks[key].id
      }
    )
    if can(hub_virtual_network.virtual_network_gateway)
  }
}
locals {
  module_vwan = try(merge(local.config.connectivity.vwan, {}), {})
}

