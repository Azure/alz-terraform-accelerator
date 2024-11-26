variable "management_settings_es" {
  type        = any
  default     = {}
  description = <<DESCRIPTION
The settings for the management groups and management resources. Details of the settings can be found in the module documentation at https://registry.terraform.io/modules/Azure/caf-enterprise-scale
DESCRIPTION
}
