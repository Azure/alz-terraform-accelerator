locals {
  starter_locations = { for i, location in var.starter_locations : "starter_location_${format("%02d", i + 1)}" => location }
  starter_locations_short = {
    for i, location in var.starter_locations :
    "starter_location_${format("%02d", i + 1)}_short" => coalesce(
      # 1. User override (if provided)
      try(var.starter_locations_short["starter_location_${format("%02d", i + 1)}_short"], null),
      # 2. Official geo_code from regions module
      try(module.regions.regions_by_name[location].geo_code, null),
      # 3. Calculated short_name from regions module
      try(module.regions.regions_by_name[location].short_name, null),
      # 4. Last resort: full region name
      location
    )
  }
  built_in_replacements = merge(
    local.starter_locations,
    local.starter_locations_short,
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
  custom_names_json           = replace(replace(tostring(jsonencode(var.custom_replacements.names)), "\"true\"", "{{string_true}}"), "\"false\"", "{{string_false}}")
  custom_names_json_templated = templatestring(local.custom_names_json, local.built_in_replacements)
  custom_names_json_final     = replace(replace(replace(replace(local.custom_names_json_templated, "\"true\"", "true"), "\"false\"", "false"), "{{string_true}}", "\"true\""), "{{string_false}}", "\"false\"")
  custom_names                = jsondecode(local.custom_names_json_final)
}

locals {
  custom_name_replacements = merge(local.built_in_replacements, local.custom_names)
}

# Custom resource group identifiers
locals {
  custom_resource_group_identifiers_json           = replace(replace(tostring(jsonencode(var.custom_replacements.resource_group_identifiers)), "\"true\"", "{{string_true}}"), "\"false\"", "{{string_false}}")
  custom_resource_group_identifiers_json_templated = templatestring(local.custom_resource_group_identifiers_json, local.custom_name_replacements)
  custom_resource_group_identifiers_json_final     = replace(replace(replace(replace(local.custom_resource_group_identifiers_json_templated, "\"true\"", "true"), "\"false\"", "false"), "{{string_true}}", "\"true\""), "{{string_false}}", "\"false\"")
  custom_resource_group_identifiers                = jsondecode(local.custom_resource_group_identifiers_json_final)
}

locals {
  custom_resource_group_replacements = merge(local.custom_name_replacements, local.custom_resource_group_identifiers)
}

# Custom resource identifiers
locals {
  custom_resource_identifiers_json           = replace(replace(tostring(jsonencode(var.custom_replacements.resource_identifiers)), "\"true\"", "{{string_true}}"), "\"false\"", "{{string_false}}")
  custom_resource_identifiers_json_templated = templatestring(local.custom_resource_identifiers_json, local.custom_resource_group_replacements)
  custom_resource_identifiers_json_final     = replace(replace(replace(replace(local.custom_resource_identifiers_json_templated, "\"true\"", "true"), "\"false\"", "false"), "{{string_true}}", "\"true\""), "{{string_false}}", "\"false\"")
  custom_resource_identifiers                = jsondecode(local.custom_resource_identifiers_json_final)
}

locals {
  final_replacements = merge(local.custom_resource_group_replacements, local.custom_resource_identifiers)
}

locals {
  outputs_json           = { for key, value in var.inputs : key => replace(replace(tostring(jsonencode(value)), "\"true\"", "{{string_true}}"), "\"false\"", "{{string_false}}") }
  outputs_json_templated = { for key, value in local.outputs_json : key => templatestring(value, local.final_replacements) }
  outputs_json_final     = { for key, value in local.outputs_json_templated : key => replace(replace(replace(replace(value, "\"true\"", "true"), "\"false\"", "false"), "{{string_true}}", "\"true\""), "{{string_false}}", "\"false\"") }
  outputs                = { for key, value in local.outputs_json_final : key => jsondecode(value) }
}
