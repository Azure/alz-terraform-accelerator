output "user_assigned_managed_identity_plan_client_id" {
  value = azurerm_user_assigned_identity.alz[local.plan_key].client_id
}

output "user_assigned_managed_identity_apply_client_id" {
  value = azurerm_user_assigned_identity.alz[local.apply_key].client_id
}

output "role_assignments" {
  value = local.role_assignments
}