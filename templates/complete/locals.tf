locals {
  starter_location = var.starter_locations[0]
}
locals {
  config_file_extension = replace(lower(element(local.config_file_split, length(local.config_file_split) - 1)), local.const_yml, local.const_yaml)
  config_file_name      = var.configuration_file_path == "" ? "config.yaml" : basename(var.configuration_file_path)
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
    starter_location                = local.starter_location
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
