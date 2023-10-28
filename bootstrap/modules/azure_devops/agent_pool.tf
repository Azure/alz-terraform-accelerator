locals {
  agent_pools = local.is_authentication_scheme_managed_identity ? var.environments : {}
}

resource "azuredevops_agent_pool" "alz" {
  for_each       = local.agent_pools
  name           = each.value.agent_pool_name
  auto_provision = false
  auto_update    = true
}

resource "azuredevops_agent_queue" "alz" {
  for_each      = local.agent_pools
  project_id    = local.project_id
  agent_pool_id = azuredevops_agent_pool.alz[each.key].id
}
