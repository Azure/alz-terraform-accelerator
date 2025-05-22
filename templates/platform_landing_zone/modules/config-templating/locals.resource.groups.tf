locals {
  connectivity_resource_groups_json           = tostring(jsonencode(var.connectivity_resource_groups))
  connectivity_resource_groups_json_templated = templatestring(local.connectivity_resource_groups_json, local.final_replacements)
  connectivity_resource_groups_json_final     = replace(replace(replace(replace(local.connectivity_resource_groups_json_templated, "\"[", "["), "]\"", "]"), "\"true\"", "true"), "\"false\"", "false")
  connectivity_resource_groups                = jsondecode(local.connectivity_resource_groups_json_final)
}
