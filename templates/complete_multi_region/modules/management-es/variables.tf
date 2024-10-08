variable "settings" {
  type        = any
  default     = {}
  description = <<DESCRIPTION
The settings for the management groups and management resources. Details of the settings can be found in the module documentation at https://registry.terraform.io/modules/Azure/caf-enterprise-scale
DESCRIPTION
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
  nullable    = false
}
