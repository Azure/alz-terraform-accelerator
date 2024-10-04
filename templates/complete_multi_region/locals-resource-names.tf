locals {
  private_dns_zones_resource_group_name = templatestring(var.private_dns_zones_resource_group_name, { location = var.location })
  ddos_protection_plan_resource_group_name = templatestring(var.ddos_protection_plan_resource_group_name, { location = var.location })
  ddos_protection_plan_name = templatestring(var.ddos_protection_plan_name, { location = var.location })
}