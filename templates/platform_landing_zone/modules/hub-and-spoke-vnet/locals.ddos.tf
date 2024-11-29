locals {
  ddos_protection_plan         = try(var.hub_and_spoke_networks_settings.ddos_protection_plan.name, null) != null ? var.hub_and_spoke_networks_settings.ddos_protection_plan : null
  ddos_protection_plan_enabled = local.ddos_protection_plan != null
}
