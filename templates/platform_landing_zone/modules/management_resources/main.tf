module "management_resources" {
  source                                                     = "Azure/avm-ptn-alz-management/azurerm"
  version                                                    = "0.9.0"
  automation_account_name                                    = null
  location                                                   = var.management_resource_settings.location
  log_analytics_workspace_name                               = coalesce(var.management_resource_settings.log_analytics_workspace_name, "law-management-${var.management_resource_settings.location}")
  resource_group_name                                        = coalesce(var.management_resource_settings.resource_group_name, "rg-management-${var.management_resource_settings.location}")
  data_collection_rules                                      = var.management_resource_settings.data_collection_rules
  enable_telemetry                                           = var.enable_telemetry
  linked_automation_account_creation_enabled                 = false
  log_analytics_solution_plans                               = var.management_resource_settings.log_analytics_solution_plans
  log_analytics_workspace_allow_resource_only_permissions    = var.management_resource_settings.log_analytics_workspace_allow_resource_only_permissions
  log_analytics_workspace_cmk_for_query_forced               = var.management_resource_settings.log_analytics_workspace_cmk_for_query_forced
  log_analytics_workspace_daily_quota_gb                     = var.management_resource_settings.log_analytics_workspace_daily_quota_gb
  log_analytics_workspace_internet_ingestion_enabled         = var.management_resource_settings.log_analytics_workspace_internet_ingestion_enabled
  log_analytics_workspace_internet_query_enabled             = var.management_resource_settings.log_analytics_workspace_internet_query_enabled
  log_analytics_workspace_local_authentication_enabled       = var.management_resource_settings.log_analytics_workspace_local_authentication_enabled
  log_analytics_workspace_reservation_capacity_in_gb_per_day = var.management_resource_settings.log_analytics_workspace_reservation_capacity_in_gb_per_day
  log_analytics_workspace_retention_in_days                  = var.management_resource_settings.log_analytics_workspace_retention_in_days
  log_analytics_workspace_sku                                = var.management_resource_settings.log_analytics_workspace_sku
  resource_group_creation_enabled                            = true
  sentinel_onboarding                                        = var.management_resource_settings.sentinel_onboarding
  tags                                                       = var.management_resource_settings.tags
  timeouts                                                   = var.management_resource_settings.timeouts
  user_assigned_managed_identities                           = var.management_resource_settings.user_assigned_managed_identities
}
