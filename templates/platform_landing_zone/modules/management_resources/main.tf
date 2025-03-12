module "management_resources" {
  source  = "Azure/avm-ptn-alz-management/azurerm"
  version = "0.6.0"

  automation_account_name                                    = try(var.management_resource_settings.automation_account_name, "aa-management-${var.management_resource_settings.location}")
  location                                                   = var.management_resource_settings.location
  log_analytics_workspace_name                               = try(var.management_resource_settings.log_analytics_workspace_name, "law-management-${var.management_resource_settings.location}")
  resource_group_name                                        = try(var.management_resource_settings.resource_group_name, "rg-management-${var.management_resource_settings.location}")
  automation_account_encryption                              = try(var.management_resource_settings.automation_account_encryption, null)
  automation_account_identity                                = try(var.management_resource_settings.automation_account_identity, null)
  automation_account_local_authentication_enabled            = try(var.management_resource_settings.automation_account_local_authentication_enabled, true)
  automation_account_location                                = try(var.management_resource_settings.automation_account_location, null)
  automation_account_public_network_access_enabled           = try(var.management_resource_settings.automation_account_public_network_access_enabled, true)
  automation_account_sku_name                                = try(var.management_resource_settings.automation_account_sku_name, null)
  data_collection_rules                                      = try(var.management_resource_settings.data_collection_rules, null)
  enable_telemetry                                           = var.enable_telemetry
  linked_automation_account_creation_enabled                 = try(var.management_resource_settings.linked_automation_account_creation_enabled, false)
  log_analytics_solution_plans                               = try(var.management_resource_settings.log_analytics_solution_plans, null)
  log_analytics_workspace_allow_resource_only_permissions    = try(var.management_resource_settings.log_analytics_workspace_allow_resource_only_permissions, true)
  log_analytics_workspace_cmk_for_query_forced               = try(var.management_resource_settings.log_analytics_workspace_cmk_for_query_forced, null)
  log_analytics_workspace_daily_quota_gb                     = try(var.management_resource_settings.log_analytics_workspace_daily_quota_gb, null)
  log_analytics_workspace_internet_ingestion_enabled         = try(var.management_resource_settings.log_analytics_workspace_internet_ingestion_enabled, true)
  log_analytics_workspace_internet_query_enabled             = try(var.management_resource_settings.log_analytics_workspace_internet_query_enabled, true)
  log_analytics_workspace_local_authentication_disabled      = try(var.management_resource_settings.log_analytics_workspace_local_authentication_disabled, false)
  log_analytics_workspace_reservation_capacity_in_gb_per_day = try(var.management_resource_settings.log_analytics_workspace_reservation_capacity_in_gb_per_day, null)
  log_analytics_workspace_retention_in_days                  = try(var.management_resource_settings.log_analytics_workspace_retention_in_days, null)
  log_analytics_workspace_sku                                = try(var.management_resource_settings.log_analytics_workspace_sku, null)
  resource_group_creation_enabled                            = try(var.management_resource_settings.resource_group_creation_enabled, true)
  sentinel_onboarding                                        = try(var.management_resource_settings.sentinel_onboarding, null)
  tags                                                       = try(var.management_resource_settings.tags, var.tags)
  user_assigned_managed_identities                           = try(var.management_resource_settings.user_assigned_managed_identities, null)
}
