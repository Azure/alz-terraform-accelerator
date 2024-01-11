locals {
  audience  = "api://AzureADTokenExchange"
  plan_key  = "plan"
  apply_key = "apply"
}

locals {
  subscription_ids = { for subscription_id in distinct(var.target_subscriptions) : subscription_id => subscription_id }
}

locals {
  has_agent_container_instances = length(var.agent_container_instances) > 0
  use_private_networking = var.use_private_networking && local.has_agent_container_instances
}
