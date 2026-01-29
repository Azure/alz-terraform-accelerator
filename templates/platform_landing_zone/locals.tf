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

locals {
  policy_default_values = { for k, v in try(module.config.outputs.management_group_settings.policy_default_values, {}) : k => jsonencode({ value = v }) }
  policy_assignments_to_modify = { for management_group_key, management_group_value in try(module.config.outputs.management_group_settings.policy_assignments_to_modify, {}) : management_group_key => {
    policy_assignments = { for policy_assignment_key, policy_assignment_value in try(management_group_value.policy_assignments, {}) : policy_assignment_key => {
      enforcement_mode        = try(policy_assignment_value.enforcement_mode, null)
      identity                = try(policy_assignment_value.identity, null)
      identity_ids            = try(policy_assignment_value.identity_ids, null)
      parameters              = try({ for parameter_key, parameter_value in try(policy_assignment_value.parameters, {}) : parameter_key => jsonencode({ value = parameter_value }) }, null)
      non_compliance_messages = try(policy_assignment_value.non_compliance_messages, null)
      resource_selectors      = try(policy_assignment_value.resource_selectors, null)
      overrides               = try(policy_assignment_value.overrides, null)
    } }
  } }
}

locals {
  management_group_dependencies = [
    var.management_resources_enabled ? module.management_resources : null,
    local.connectivity_hub_and_spoke_vnet_enabled ? module.hub_and_spoke_vnet : null,
    local.connectivity_virtual_wan_enabled ? module.virtual_wan : null
  ]
}
