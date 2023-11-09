locals {
  audience  = "api://AzureADTokenExchange"
  plan_key  = "plan"
  apply_key = "apply"
}

locals {
  subscription_ids = { for subscription_id in distinct(var.target_subscriptions) : subscription_id => subscription_id }
}
