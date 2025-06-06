variable "management_resource_settings" {
  type        = any
  default     = {}
  description = <<DESCRIPTION
The settings for the management resources. Details of the settings can be found in the module documentation at https://registry.terraform.io/modules/Azure/avm-ptn-alz-management
DESCRIPTION
}

variable "management_group_settings" {
  type        = any
  default     = {}
  description = <<DESCRIPTION
The settings for the management groups. Details of the settings can be found in the module documentation at https://registry.terraform.io/modules/Azure/avm-ptn-alz
DESCRIPTION
}

variable "policy_default_values_filtering" {
  type = object({
    enabled = optional(bool, true)
    policy_assignment_names_to_check = optional(map(string), {
      dns  = "Deploy-Private-DNS-Zones",
      ddos = "Enable-DDoS-VNET"
    })
    policy_default_values_to_remove = optional(map(string), {
      private_dns_zone_subscription_id     = "dns"
      private_dns_zone_region              = "dns"
      private_dns_zone_resource_group_name = "dns"
      ddos_protection_plan_id              = "ddos"
    })
  })
  default     = {}
  description = <<DESCRIPTION
This variable is used to prevent the creation of policy assignment role assignments for policies that are explicitly set to 'DoNotEnforce'.

- `enabled`: Set to `true` to enable filtering of policy assignment role assignments.
- `policy_assignment_names_to_check`: A map of policy assignment names to check for filtering.
- `policy_default_values_to_remove`: A map of policy default values to remove from the policy assignment role assignments.

DESCRIPTION
}
