
resource "azuredevops_agent_pool" "alz" {
  name           = var.agent_pool_name
  auto_provision = false
  auto_update    = true
}

resource "azuredevops_agent_queue" "alz" {
  project_id    = local.project_id
  agent_pool_id = azuredevops_agent_pool.alz.id
}