locals {
  config_file_extension = replace(lower(element(local.config_file_split, length(local.config_file_split) - 1)), local.const_yml, local.const_yaml)
  config_file_name      = basename(var.configuration_file_path)
  config_file_split     = split(".", local.config_file_name)
  const_yaml            = "yaml"
  const_yml             = "yml"
}
locals {
  config = (local.config_file_extension == local.const_yaml || local.config_file_extension == local.const_yml ?
    yamldecode(templatefile("${path.module}/${local.config_file_name}", local.config_template_file_variables)) :
    jsondecode(templatefile("${path.module}/${local.config_file_name}", local.config_template_file_variables))
  )
  config_template_file_variables = {
    starter_location_01             = var.starter_locations[0]
    starter_location_02             = try(var.starter_locations[1], null)
    starter_location_03             = try(var.starter_locations[2], null)
    starter_location_04             = try(var.starter_locations[3], null)
    starter_location_05             = try(var.starter_locations[4], null)
    starter_location_06             = try(var.starter_locations[5], null)
    starter_location_07             = try(var.starter_locations[6], null)
    starter_location_08             = try(var.starter_locations[7], null)
    starter_location_09             = try(var.starter_locations[8], null)
    starter_location_10             = try(var.starter_locations[9], null)
    starter_location_01_availability_zones = local.config_file_extension == local.const_yaml || local.config_file_extension == local.const_yml ? yamlencode(local.regions[var.starter_locations[0]].zones) : jsonencode(local.regions[var.starter_locations[0]].zones)
    starter_location_02_availability_zones = yamlencode(try(local.regions[var.starter_locations[11]].zones, []))
    default_postfix                 = var.default_postfix
    root_parent_management_group_id = var.root_parent_management_group_id == "" ? data.azurerm_client_config.current.tenant_id : var.root_parent_management_group_id
    subscription_id_connectivity    = var.subscription_id_connectivity
    subscription_id_identity        = var.subscription_id_identity
    subscription_id_management      = var.subscription_id_management
  }
}
locals {
  management_groups = try(merge(local.config.management_groups, {}), {})
}
locals {
  hub_virtual_networks = try(merge(local.config.connectivity.hub_and_spoke_vnet.hub_virtual_networks, {}), {})
  module_hub_and_spoke_vnet = {
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
        virtual_network_id = module.hub_and_spoke_vnet[0].virtual_networks[key].id
      }
    )
    if can(hub_virtual_network.virtual_network_gateway)
  }
}

locals {
  module_virtual_wan = try(merge(local.config.connectivity.virtual_wan, {}), {})
}

locals {
  module_private_dns = try(merge(local.config.connectivity.private_dns, {}), {})
}

locals {
  management_groups_enabled = length(local.management_groups) > 0
  hub_networking_enabled = length(local.module_hub_and_spoke_vnet) > 0
  virtual_wan_enabled   = length(local.module_virtual_wan) > 0
  private_dns_enabled   = length(local.module_private_dns) > 0
}
