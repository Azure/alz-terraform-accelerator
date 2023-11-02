output "user_assigned_managed_identity_client_ids" {
  value = { for key, value in var.user_assigned_managed_identities : key => azurerm_user_assigned_identity.alz[key].client_id }
}

output "role_assignments" {
  value = local.role_assignments
}
