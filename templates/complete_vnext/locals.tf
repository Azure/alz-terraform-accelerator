locals {
  const_yaml = "yaml"
  const_yml  = "yml"

  config_file_name      = var.configuration_file_path == "" ? "config.yaml" : basename(var.configuration_file_path)
  config_file_split     = split(".", local.config_file_name)
  config_file_extension = replace(lower(element(local.config_file_split, length(local.config_file_split) - 1)), local.const_yml, local.const_yaml)
}
locals {
  config_template_file_variables = {
    default_location                = var.default_location
    default_postfix                 = var.default_postfix
    root_parent_management_group_id = var.root_parent_management_group_id == "" ? data.azurerm_client_config.core.tenant_id : var.root_parent_management_group_id
    subscription_id_connectivity    = var.subscription_id_connectivity
    subscription_id_identity        = var.subscription_id_identity
    subscription_id_management      = var.subscription_id_management
  }

  config = (local.config_file_extension == local.const_yaml ?
    yamldecode(templatefile("${path.module}/${local.config_file_name}", local.config_template_file_variables)) :
    jsondecode(templatefile("${path.module}/${local.config_file_name}", local.config_template_file_variables))
  )
}
locals {
  management_group_resource_id_format = "/providers/Microsoft.Management/managementGroups/%s"
  root_parent_management_group_id     = local.config_template_file_variables.root_parent_management_group_id
  management_groups = { for k, v in local.config.management_groups : k => {
    id                 = v.id
    display_name       = try(v.display_name, v.id)
    parent             = v.parent
    parent_resource_id = v.parent == local.root_parent_management_group_id ? data.azurerm_management_group.root.id : format(local.management_group_resource_id_format, local.config.management_groups[v.parent].id)
    base_archetype     = v.base_archetype
    subscriptions      = try(v.subscriptions, [])
    is_root            = v.parent == local.root_parent_management_group_id
    }
  }
  management_groups_layer_1 = { for k, v in local.management_groups : k => v if v.is_root }
  management_groups_layer_2 = { for k, v in local.management_groups : k => v if contains(keys(local.management_groups_layer_1), v.parent) }
  management_groups_layer_3 = { for k, v in local.management_groups : k => v if contains(keys(local.management_groups_layer_2), v.parent) }
  management_groups_layer_4 = { for k, v in local.management_groups : k => v if contains(keys(local.management_groups_layer_3), v.parent) }
  management_groups_layer_5 = { for k, v in local.management_groups : k => v if contains(keys(local.management_groups_layer_4), v.parent) }
  management_groups_layer_6 = { for k, v in local.management_groups : k => v if contains(keys(local.management_groups_layer_5), v.parent) }
  management_groups_layer_7 = { for k, v in local.management_groups : k => v if contains(keys(local.management_groups_layer_6), v.parent) }
}
locals {
  management                 = local.config.management
  log_analytics_workspace_id = "/subscriptions/${var.subscription_id_management}/resourceGroups/${local.management.resource_group_name}/providers/Microsoft.OperationalInsights/workspaces/${local.management.log_analytics_workspace_name}"
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
