locals {
  policy_default_values = { for k, v in try(var.management_group_settings.policy_default_values, {}) : k => jsonencode({
    value = v
  }) }
}
