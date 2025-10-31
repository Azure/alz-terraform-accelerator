locals {
  starter_locations = { for i, location in var.starter_locations : "starter_location_${format("%02d", i + 1)}" => location }
  built_in_replacements = merge(
    local.starter_locations,
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
