locals {
  const = {
    connectivity = {
      virtual_wan        = "virtual_wan"
      hub_and_spoke_vnet = "hub_and_spoke_vnet"
      none               = "none"
    }
  }
}

locals {
  connectivity_enabled                    = var.connectivity_type != local.const.connectivity.none
  connectivity_virtual_wan_enabled        = var.connectivity_type == local.const.connectivity.virtual_wan
  connectivity_hub_and_spoke_vnet_enabled = var.connectivity_type == local.const.connectivity.hub_and_spoke_vnet
}

# Build an implicit dependency on the resource groups
locals {
  resource_groups = {
    resource_groups = module.resource_groups
  }
  hub_and_spoke_networks_settings = merge(module.config.outputs.hub_and_spoke_networks_settings, local.resource_groups)
  hub_virtual_networks            = (merge({ vnets = module.config.outputs.hub_virtual_networks }, local.resource_groups)).vnets
  virtual_wan_settings            = merge(module.config.outputs.virtual_wan_settings, local.resource_groups)
  virtual_hubs                    = (merge({ vhubs = module.config.outputs.virtual_hubs }, local.resource_groups)).vhubs
}

# Build policy dependencies
locals {
  management_group_dependencies = {
    policy_assignments = [
      module.management_resources,
      module.hub_and_spoke_vnet,
      module.virtual_wan
    ]
    policy_role_assignments = [
      module.management_resources,
      module.hub_and_spoke_vnet,
      module.virtual_wan
    ]
  }
}

locals {
  management_group_settings = merge(
    module.config.outputs.management_group_settings,
    {
      dependencies = local.management_group_dependencies
    }
  )
  management_resource_settings = merge(
    module.config.outputs.management_resource_settings,
    {
      tags = coalesce(module.config.outputs.management_resource_settings.tags, module.config.outputs.tags)
    }
  )
}
