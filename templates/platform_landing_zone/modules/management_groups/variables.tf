variable "management_group_settings" {
  type        = any
  default     = {}
  description = <<DESCRIPTION
The settings for the management groups.
DESCRIPTION
}

variable "dependencies" {
  type = object({
    policy_role_assignments = optional(any, null)
    policy_assignments      = optional(any, null)
  })
  default     = {}
  description = <<DESCRIPTION
Place dependent values into this variable to ensure that resources are created in the correct order.
Ensure that the values placed here are computed/known after apply, e.g. the resource ids.

This is necessary as the unknown values and `depends_on` are not supported by this module as we use the alz provider.
See the "Unknown Values & Depends On" section above for more information.

e.g.

```hcl
dependencies = {
  policy_role_assignments = [
    module.dependency_example1.output,
    module.dependency_example2.output,
  ]
}
```
DESCRIPTION
  nullable    = false
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
