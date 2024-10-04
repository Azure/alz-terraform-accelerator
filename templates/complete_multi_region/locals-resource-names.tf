locals {
  private_dns_zones_resource_group_name = templatestring(var.private_dns_zones_resource_group_name, { location = var.location })
  ddos_protection_plan_resource_group_name = templatestring(var.ddos_protection_plan_resource_group_name, { location = var.location })
  ddos_protection_plan_name = templatestring(var.ddos_protection_plan_name, { location = var.location })
  virtual_wan_resource_group_name = templatestring(var.virtual_wan_resource_group_name, { location = var.location })
  management_resource_group_name = templatestring(var.management_resource_group_name, { location = var.location })
  management_log_analytics_workspace_name = templatestring(var.management_log_analytics_workspace_name, { location = var.location })
  management_automation_account_name = templatestring(var.management_automation_account_name, { location = var.location })
}