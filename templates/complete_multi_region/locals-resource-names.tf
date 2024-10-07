locals {
  ddos_protection_plan_resource_group_name  = templatestring(var.ddos_protection_plan_resource_group_name, { location = local.primary_location })
  ddos_protection_plan_name                 = templatestring(var.ddos_protection_plan_name, { location = local.primary_location })
}