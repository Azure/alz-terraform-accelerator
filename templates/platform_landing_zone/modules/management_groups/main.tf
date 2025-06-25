module "management_groups" {
  source                                                        = "Azure/avm-ptn-alz/azurerm"
  version                                                       = "0.12.3"
  architecture_name                                             = try(var.management_group_settings.architecture_name, "alz")
  parent_resource_id                                            = var.management_group_settings.parent_resource_id
  location                                                      = var.management_group_settings.location
  policy_default_values                                         = local.policy_default_values
  policy_assignments_to_modify                                  = local.policy_assignments_to_modify
  delays                                                        = try(var.management_group_settings.delays, {})
  enable_telemetry                                              = var.enable_telemetry
  management_group_hierarchy_settings                           = try(var.management_group_settings.management_group_hierarchy_settings, null)
  partner_id                                                    = try(var.management_group_settings.partner_id, null)
  retries                                                       = try(var.management_group_settings.retries, local.default_retries)
  subscription_placement                                        = try(var.management_group_settings.subscription_placement, {})
  timeouts                                                      = try(var.management_group_settings.timeouts, local.default_timeouts)
  dependencies                                                  = var.dependencies
  override_policy_definition_parameter_assign_permissions_set   = try(var.management_group_settings.override_policy_definition_parameter_assign_permissions_set, null)
  override_policy_definition_parameter_assign_permissions_unset = try(var.management_group_settings.override_policy_definition_parameter_assign_permissions_unset, null)
  management_group_role_assignments                             = try(var.management_group_settings.management_group_role_assignments, null)
  role_assignment_definition_lookup_enabled                     = try(var.management_group_settings.role_assignment_definition_lookup_enabled, true)
  policy_assignment_non_compliance_message_settings             = try(var.management_group_settings.policy_assignment_non_compliance_message_settings, {})
}
