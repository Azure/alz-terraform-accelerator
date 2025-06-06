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

locals {
  management_groups_enabled    = try(var.management_group_settings.enabled, true)
  management_resources_enabled = try(var.management_resource_settings.enabled, true)
}

# Build an implicit dependency on the resource groups
locals {
  resource_groups = {
    resource_groups = module.resource_groups
  }
  hub_and_spoke_vnet_settings         = merge(module.config.hub_and_spoke_vnet_settings, local.resource_groups)
  hub_and_spoke_vnet_virtual_networks = (merge({ vnets = module.config.hub_and_spoke_vnet_virtual_networks }, local.resource_groups)).vnets
  virtual_wan_settings                = merge(module.config.virtual_wan_settings, local.resource_groups)
  virtual_wan_virtual_hubs            = (merge({ vhubs = module.config.virtual_wan_virtual_hubs }, local.resource_groups)).vhubs
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

# Handle Policy Assignment Role Assignments
locals {
  policy_assignments_to_modify = { for assignment_key, assignment_value in var.policy_default_values_filtering.policy_assignment_names_to_check : assignment_key => flatten([for policy_assignments_to_modify_key, policy_assignments_to_modify_value in try(module.config.management_group_settings.policy_assignments_to_modify, {}) : [for ef in values(policy_assignments_to_modify_value.policy_assignments) : try(ef.enforcement_mode, "Unknown") != "DoNotEnforce"] if contains(keys(policy_assignments_to_modify_value.policy_assignments), assignment_value)]) }
  policy_assignment_enforced   = { for assignment_key, assignment_value in var.policy_default_values_filtering.policy_assignment_names_to_check : assignment_key => length(local.policy_assignments_to_modify[assignment_key]) == 0 || alltrue(local.policy_assignments_to_modify[assignment_key]) }

  policy_default_values = { for policy_default_value_key, policy_default_value_value in try(module.config.management_group_settings.policy_default_values, {}) : policy_default_value_key => policy_default_value_value if try(local.policy_assignment_enforced[var.policy_default_values_filtering.policy_default_values_to_remove[policy_default_value_key]], true) }
  management_group_settings = var.policy_default_values_filtering.enabled ? merge(
    try(module.config.management_group_settings, {}),
    {
      policy_default_values = local.policy_default_values
    }
  ) : module.config.management_group_settings
}
