resource "azuredevops_git_repository" "alz" {
  depends_on = [azuredevops_environment.alz]
  project_id = local.project_id
  name       = var.repository_name
  initialization {
    init_type   = "Clean"
  }
}

resource "azuredevops_git_repository_file" "alz" {
  for_each =          var.repository_files
  repository_id       = azuredevops_git_repository.alz.id
  file                = each.key
  content             = file(each.value)
}