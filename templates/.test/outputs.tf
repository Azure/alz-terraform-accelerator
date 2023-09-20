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

output "test_output_03" {
  value = var.test_variable_03
}

output "test_output_04" {
  value = var.test_variable_04
}

output "test_output_05" {
  value = var.test_variable_05
}

output "test_output_06" {
  value = var.test_variable_06
}

output "subscription_id_connectivity" {
  value = var.subscription_id_connectivity
}

output "subscription_id_identity" {
  value = var.subscription_id_identity
}

output "subscription_id_management" {
  value = var.subscription_id_management
}
