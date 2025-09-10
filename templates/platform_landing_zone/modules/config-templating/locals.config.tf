locals {
  regions = { for region in module.regions.regions_by_name : region.name => {
    display_name = region.display_name
    zones        = region.zones == null ? [] : region.zones
    }
  }
}

locals {
  starter_locations                    = { for i, location in var.starter_locations : "starter_location_${format("%02d", i + 1)}" => location }
  starter_locations_availability_zones = { for i, location in var.starter_locations : "starter_location_${format("%02d", i + 1)}_availability_zones" => jsonencode(local.regions[location].zones) }
  starter_locations_er_vgw_sku         = { for i, location in var.starter_locations : "starter_location_${format("%02d", i + 1)}_virtual_network_gateway_sku_express_route" => local.hub_and_spoke_vnet_gateway_default_skus[location].express_route }
  starter_locations_vpn_vgw_sku        = { for i, location in var.starter_locations : "starter_location_${format("%02d", i + 1)}_virtual_network_gateway_sku_vpn" => local.hub_and_spoke_vnet_gateway_default_skus[location].vpn }

  built_in_replacements = merge(
    local.starter_locations,
    local.starter_locations_availability_zones,
    local.starter_locations_er_vgw_sku,
    local.starter_locations_vpn_vgw_sku,
    {
      root_parent_management_group_id = var.root_parent_management_group_id == "" ? data.azurerm_client_config.current.tenant_id : var.root_parent_management_group_id
      subscription_id_connectivity    = var.subscription_id_connectivity
      subscription_id_identity        = var.subscription_id_identity
      subscription_id_management      = var.subscription_id_management
      subscription_id_security        = var.subscription_id_security
  })
}

# Custom name replacements
locals {
  custom_names_json           = tostring(jsonencode(var.custom_replacements.names))
  custom_names_json_templated = templatestring(local.custom_names_json, local.built_in_replacements)
  custom_names_json_final     = replace(replace(replace(replace(local.custom_names_json_templated, "\"[", "["), "]\"", "]"), "\"true\"", "true"), "\"false\"", "false")
  custom_names                = jsondecode(local.custom_names_json_final)
}

locals {
  custom_name_replacements = merge(local.built_in_replacements, local.custom_names)
}

# Custom resource group identifiers
locals {
  custom_resource_group_identifiers_json           = tostring(jsonencode(var.custom_replacements.resource_group_identifiers))
  custom_resource_group_identifiers_json_templated = templatestring(local.custom_resource_group_identifiers_json, local.custom_name_replacements)
  custom_resource_group_identifiers_json_final     = replace(replace(replace(replace(local.custom_resource_group_identifiers_json_templated, "\"[", "["), "]\"", "]"), "\"true\"", "true"), "\"false\"", "false")
  custom_resource_group_identifiers                = jsondecode(local.custom_resource_group_identifiers_json_final)
}

locals {
  custom_resource_group_replacements = merge(local.custom_name_replacements, local.custom_resource_group_identifiers)
}

# Custom resource identifiers
locals {
  custom_resource_identifiers_json           = tostring(jsonencode(var.custom_replacements.resource_identifiers))
  custom_resource_identifiers_json_templated = templatestring(local.custom_resource_identifiers_json, local.custom_resource_group_replacements)
  custom_resource_identifiers_json_final     = replace(replace(replace(replace(local.custom_resource_identifiers_json_templated, "\"[", "["), "]\"", "]"), "\"true\"", "true"), "\"false\"", "false")
  custom_resource_identifiers                = jsondecode(local.custom_resource_identifiers_json_final)
}

locals {
  final_replacements = merge(local.custom_resource_group_replacements, local.custom_resource_identifiers)
}
