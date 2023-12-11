locals {
  management_groups = local.initial_config.management_groups

  management_groups_layer_1 = { for k, v in local.management_groups : k => v if v.parent == local.root_management_group_id }
  management_groups_layer_2 = { for k, v in local.management_groups : k => v if contains(keys(local.management_groups_layer_1), v.parent) }
  management_groups_layer_3 = { for k, v in local.management_groups : k => v if contains(keys(local.management_groups_layer_2), v.parent) }
  management_groups_layer_4 = { for k, v in local.management_groups : k => v if contains(keys(local.management_groups_layer_3), v.parent) }
  management_groups_layer_5 = { for k, v in local.management_groups : k => v if contains(keys(local.management_groups_layer_4), v.parent) }
  management_groups_layer_6 = { for k, v in local.management_groups : k => v if contains(keys(local.management_groups_layer_5), v.parent) }
  management_groups_layer_7 = { for k, v in local.management_groups : k => v if contains(keys(local.management_groups_layer_6), v.parent) }
}

output "test" {
  value = {
    management_groups_layer_1 = local.management_groups_layer_1
    management_groups_layer_2 = local.management_groups_layer_2
    management_groups_layer_3 = local.management_groups_layer_3
    management_groups_layer_4 = local.management_groups_layer_4
    management_groups_layer_5 = local.management_groups_layer_5
    management_groups_layer_6 = local.management_groups_layer_6
    management_groups_layer_7 = local.management_groups_layer_7
  }
}
