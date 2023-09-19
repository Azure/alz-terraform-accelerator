output "connection" {
  value = data.azurerm_client_config.current
}

output "subscription" {
  value = data.azurerm_subscription.current
}

output "test_output_01" {
  value = var.test_variable_01
}

output "test_output_02" {
  value = var.test_variable_02
}
