resource "azuredevops_git_repository" "alz_templates" {
  count          = var.use_template_repository ? 1 : 0
  project_id     = local.project_id
  name           = var.repository_name_templates
  default_branch = local.default_branch
  initialization {
    init_type = "Clean"
  }
}

resource "azuredevops_git_repository_file" "alz_templates" {
  for_each            = var.use_template_repository ? local.cicd_template_files : {}
  repository_id       = azuredevops_git_repository.alz_templates[0].id
  file                = each.key
  content             = each.value.content
  branch              = local.default_branch
  commit_message      = "Add ${each.key} [skip ci]"
  overwrite_on_create = true
}

resource "azuredevops_branch_policy_min_reviewers" "alz_templates" {
  count      = var.use_template_repository ? 1 : 0
  depends_on = [azuredevops_git_repository_file.alz_templates]
  project_id = local.project_id

  enabled  = length(var.approvers) > 1
  blocking = true

  settings {
    reviewer_count                         = 1
    submitter_can_vote                     = false
    last_pusher_cannot_approve             = true
    allow_completion_with_rejects_or_waits = false
    on_push_reset_approved_votes           = true

    scope {
      repository_id  = azuredevops_git_repository.alz_templates[0].id
      repository_ref = azuredevops_git_repository.alz_templates[0].default_branch
      match_type     = "Exact"
    }
  }
}

resource "azuredevops_branch_policy_merge_types" "alz_templates" {
  count      = var.use_template_repository ? 1 : 0
  depends_on = [azuredevops_git_repository_file.alz_templates]
  project_id = local.project_id

  enabled  = true
  blocking = true

  settings {
    allow_squash                  = true
    allow_rebase_and_fast_forward = false
    allow_basic_no_fast_forward   = false
    allow_rebase_with_merge       = false

    scope {
      repository_id  = azuredevops_git_repository.alz_templates[0].id
      repository_ref = azuredevops_git_repository.alz_templates[0].default_branch
      match_type     = "Exact"
    }
  }
}
