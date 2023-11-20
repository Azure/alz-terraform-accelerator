locals { 
 management_groups_raw       = local.raw_config.management_groups

  management_groups = {
    for key, value in local.management_groups_raw : key => {
      id             = replace(value.id, "$${default_postfix}", local.base_config_replacements.default_postfix)
      parent_id      = replace(replace(value.parent_id, "$${default_postfix}", local.base_config_replacements.default_postfix), "$${tenant_root_management_group_id}", local.base_config_replacements.tenant_root_management_group_id)
      base_archetype = value.base_archetype
    }
  }

  management_groups_templated = local.templated_config.management_groups

  management_groups_layer_1 = { for k, v in local.management_groups : k => v if v.parent_id == "$${tenant_root_management_group_id}" }
  management_groups_layer_2 = { for k, v in local.management_groups : k => v if contains(values(local.management_groups_layer_1)[*].id, v.parent_id) }
  management_groups_layer_3 = { for k, v in local.management_groups : k => v if contains(values(local.management_groups_layer_2)[*].id, v.parent_id) }
  management_groups_layer_4 = { for k, v in local.management_groups : k => v if contains(values(local.management_groups_layer_3)[*].id, v.parent_id) }
  management_groups_layer_5 = { for k, v in local.management_groups : k => v if contains(values(local.management_groups_layer_4)[*].id, v.parent_id) }
  management_groups_layer_6 = { for k, v in local.management_groups : k => v if contains(values(local.management_groups_layer_5)[*].id, v.parent_id) }
  management_groups_layer_7 = { for k, v in local.management_groups : k => v if contains(values(local.management_groups_layer_6)[*].id, v.parent_id) }
}
