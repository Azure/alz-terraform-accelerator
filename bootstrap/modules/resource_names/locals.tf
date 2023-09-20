# Resource Name Setup
resource "random_string" "alz" {
  length  = 4
  special = false
  upper   = false
}

locals {
  formatted_postfix_number          = format("%03d", var.postfix_number)
  formatted_postfix_number_plus_one = format("%03d", var.postfix_number + 1)
  random_string                     = random_string.alz.result
  resource_names = {
    for key, value in var.resource_names : key => replace(replace(replace(replace(replace(replace(replace(value,
      "{{service_name}}", var.service_name),
      "{{environment_name}}", var.environment_name),
      "{{azure_location}}", var.azure_location),
      "{{azure_location_short}}", substr(var.azure_location, 0, 3)),
      "{{postfix_number}}", local.formatted_postfix_number),
      "{{postfix_number_plus_one}}", local.formatted_postfix_number_plus_one),
    "{{random_string}}", local.random_string)
  }
}
