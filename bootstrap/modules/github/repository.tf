resource "github_repository" "alz" {
  name                = var.repository_name
  description         = var.repository_name
  auto_init           = true
  visibility          = var.repository_visibility
  allow_update_branch = true
  allow_merge_commit  = false
  allow_rebase_merge  = false
}

locals {
  cicd_file = { for key, value in var.repository_files : key =>
    {
      content = templatefile(value.path, {
        environment_name_plan  = var.environment_name_plan
        environment_name_apply = var.environment_name_apply
      })
    } if value.flag == "cicd"
  }
  module_files = { for key, value in var.repository_files : key =>
    {
      content = replace((file(value.path)), "# backend \"azurerm\" {}", "backend \"azurerm\" {}")
    } if value.flag == "module" || value.flag == "additional"
  }
  repository_files = merge(local.cicd_file, local.module_files)
}

resource "github_repository_file" "alz" {
  for_each            = local.repository_files
  repository          = github_repository.alz.name
  file                = each.key
  content             = each.value.content
  commit_author       = "Azure Landing Zone"
  commit_email        = "alz@microsoft.com"
  commit_message      = "Add ${each.key} [skip ci]"
  overwrite_on_create = true
}

resource "github_branch_protection" "alz" {
  depends_on                      = [github_repository_file.alz]
  repository_id                   = github_repository.alz.name
  pattern                         = "main"
  enforce_admins                  = true
  required_linear_history         = true
  require_conversation_resolution = true

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    restrict_dismissals             = true
    required_approving_review_count = 1
  }
}
