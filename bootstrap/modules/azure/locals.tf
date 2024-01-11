locals {
  audience  = "api://AzureADTokenExchange"
  plan_key  = "plan"
  apply_key = "apply"
}

locals {
  subscription_ids = { for subscription_id in distinct(var.target_subscriptions) : subscription_id => subscription_id }
}

locals {
  use_private_networking = var.use_private_networking && length(var.agent_container_instances) > 0
}
