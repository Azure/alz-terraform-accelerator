locals {
  audience  = "api://AzureADTokenExchange"
  plan_key  = "plan"
  apply_key = "apply"
  user_assigned_managed_identities = {
    plan  = var.user_assigned_managed_identity_plan_name
    apply = var.user_assigned_managed_identity_apply_name
  }
}
