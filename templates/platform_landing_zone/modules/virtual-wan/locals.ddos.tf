locals {
  ddos_protection_plan         = try(var.virtual_wan_settings.ddos_protection_plan.name, null) != null ? var.virtual_wan_settings.ddos_protection_plan : null
  ddos_protection_plan_enabled = local.ddos_protection_plan != null
}
