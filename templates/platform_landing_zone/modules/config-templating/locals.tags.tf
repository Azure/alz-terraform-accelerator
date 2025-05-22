locals {
  tags_json           = tostring(jsonencode(var.tags))
  tags_json_templated = templatestring(local.tags_json, local.final_replacements)
  tags_json_final     = replace(replace(replace(replace(local.tags_json_templated, "\"[", "["), "]\"", "]"), "\"true\"", "true"), "\"false\"", "false")
  tags                = jsondecode(local.tags_json_final)
}
