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
