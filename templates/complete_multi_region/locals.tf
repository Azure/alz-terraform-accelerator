locals {
  enable_telemetry = try(local.config.enable_telemetry, true)
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
  hub_networking_enabled    = length(local.module_hub_and_spoke_vnet) > 0
  virtual_wan_enabled       = length(local.module_virtual_wan) > 0
  private_dns_enabled       = length(local.module_private_dns) > 0
}
