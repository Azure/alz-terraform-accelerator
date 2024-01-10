resource "azuredevops_agent_pool" "alz" {
  for_each       = var.agent_pools
  name           = each.value
  auto_provision = false
  auto_update    = true
}

resource "azuredevops_agent_queue" "alz" {
  for_each      = var.agent_pools
  project_id    = local.project_id
  agent_pool_id = azuredevops_agent_pool.alz[each.key].id
}
