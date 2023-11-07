module "management_groups_layer_1" {
  source                             = "Azure/avm-ptn-alz/azurerm"
  version                            = "~> 0.4.1"
  for_each                           = local.management_groups_layer_1
  id                                 = each.value.id
  display_name                       = try(each.value.display_name, each.value.id)
  parent_id                          = each.value.parent_id
  base_archetype                     = each.value.base_archetype
  default_location                   = var.default_location
  default_log_analytics_workspace_id = module.management_resources.log_analytics_workspace.id
  subscription_ids                   = try(each.value.subscription_ids, [])
}

module "management_groups_layer_2" {
  source                             = "Azure/avm-ptn-alz/azurerm"
  version                            = "~> 0.4.1"
  for_each                           = local.management_groups_layer_2
  id                                 = each.value.id
  display_name                       = try(each.value.display_name, each.value.id)
  parent_id                          = each.value.parent_id
  base_archetype                     = each.value.base_archetype
  default_location                   = var.default_location
  default_log_analytics_workspace_id = module.management_resources.log_analytics_workspace.id
  subscription_ids                   = try(each.value.subscription_ids, [])
  depends_on = [module.management_groups_layer_1]
}

module "management_groups_layer_3" {
  source                             = "Azure/avm-ptn-alz/azurerm"
  version                            = "~> 0.4.1"
  for_each                           = local.management_groups_layer_3
  id                                 = each.value.id
  display_name                       = try(each.value.display_name, each.value.id)
  parent_id                          = each.value.parent_id
  base_archetype                     = each.value.base_archetype
  default_location                   = var.default_location
  default_log_analytics_workspace_id = module.management_resources.log_analytics_workspace.id
  subscription_ids                   = try(each.value.subscription_ids, [])
  depends_on = [module.management_groups_layer_2]
}

module "management_groups_layer_4" {
  source                             = "Azure/avm-ptn-alz/azurerm"
  version                            = "~> 0.4.1"
  for_each                           = local.management_groups_layer_4
  id                                 = each.value.id
  display_name                       = try(each.value.display_name, each.value.id)
  parent_id                          = each.value.parent_id
  base_archetype                     = each.value.base_archetype
  default_location                   = var.default_location
  default_log_analytics_workspace_id = module.management_resources.log_analytics_workspace.id
  subscription_ids                   = try(each.value.subscription_ids, [])
  depends_on = [module.management_groups_layer_3]
}

module "management_groups_layer_5" {
  source                             = "Azure/avm-ptn-alz/azurerm"
  version                            = "~> 0.4.1"
  for_each                           = local.management_groups_layer_5
  id                                 = each.value.id
  display_name                       = try(each.value.display_name, each.value.id)
  parent_id                          = each.value.parent_id
  base_archetype                     = each.value.base_archetype
  default_location                   = var.default_location
  default_log_analytics_workspace_id = module.management_resources.log_analytics_workspace.id
  subscription_ids                   = try(each.value.subscription_ids, [])
  depends_on = [module.management_groups_layer_4]
}

module "management_groups_layer_6" {
  source                             = "Azure/avm-ptn-alz/azurerm"
  version                            = "~> 0.4.1"
  for_each                           = local.management_groups_layer_6
  id                                 = each.value.id
  display_name                       = try(each.value.display_name, each.value.id)
  parent_id                          = each.value.parent_id
  base_archetype                     = each.value.base_archetype
  default_location                   = var.default_location
  default_log_analytics_workspace_id = module.management_resources.log_analytics_workspace.id
  subscription_ids                   = try(each.value.subscription_ids, [])
  depends_on = [module.management_groups_layer_5]
}

module "management_groups_layer_7" {
  source                             = "Azure/avm-ptn-alz/azurerm"
  version                            = "~> 0.4.1"
  for_each                           = local.management_groups_layer_7
  id                                 = each.value.id
  display_name                       = try(each.value.display_name, each.value.id)
  parent_id                          = each.value.parent_id
  base_archetype                     = each.value.base_archetype
  default_location                   = var.default_location
  default_log_analytics_workspace_id = module.management_resources.log_analytics_workspace.id
  subscription_ids                   = try(each.value.subscription_ids, [])
  depends_on = [module.management_groups_layer_6]
}
