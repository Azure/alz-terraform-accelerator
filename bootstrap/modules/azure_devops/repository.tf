resource "azuredevops_git_repository" "alz" {
  depends_on = [azuredevops_environment.alz]
  project_id = local.project_id
  name       = var.repository_name
  initialization {
    init_type   = "Clean"
  }
}