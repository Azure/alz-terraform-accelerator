locals {
  connectivity_resource_groups_json           = tostring(jsonencode(var.connectivity_resource_groups))
  connectivity_resource_groups_json_templated = templatestring(local.connectivity_resource_groups_json, local.config_template_file_variables)
  connectivity_resource_groups_json_final     = replace(replace(local.connectivity_resource_groups_json_templated, "\"[", "["), "]\"", "]")
  connectivity_resource_groups                = jsondecode(local.connectivity_resource_groups_json_final)
}
