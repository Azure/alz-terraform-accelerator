module "management_groups" {
  source                              = "Azure/avm-ptn-alz/azurerm"
  version                             = "0.11.0"
  architecture_name                   = try(var.management_group_settings.architecture_name, "alz")
  parent_resource_id                  = var.management_group_settings.parent_resource_id
  location                            = var.management_group_settings.location
  policy_default_values               = local.policy_default_values
  policy_assignments_to_modify        = local.policy_assignments_to_modify
  delays                              = try(var.management_group_settings.delays, {})
  enable_telemetry                    = var.enable_telemetry
  management_group_hierarchy_settings = try(var.management_group_settings.management_group_hierarchy_settings, null)
  partner_id                          = try(var.management_group_settings.partner_id, null)
  retries                             = try(var.management_group_settings.retries, local.default_retries)
  subscription_placement              = try(var.management_group_settings.subscription_placement, {})
  timeouts                            = try(var.management_group_settings.timeouts, local.default_timeouts)
  dependencies                        = var.dependencies
}
