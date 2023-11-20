resource "azuredevops_git_repository" "alz" {
  depends_on     = [azuredevops_environment.alz]
  project_id     = local.project_id
  name           = var.repository_name
  default_branch = local.default_branch
  initialization {
    init_type = "Clean"
  }
}

resource "azuredevops_git_repository_file" "alz" {
  for_each            = local.repository_files
  repository_id       = azuredevops_git_repository.alz.id
  file                = each.key
  content             = each.value.content
  branch              = local.default_branch
  commit_message      = "Add ${each.key} [skip ci]"
  overwrite_on_create = true
}

resource "azuredevops_branch_policy_min_reviewers" "alz" {
  depends_on = [azuredevops_git_repository_file.alz]
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
      repository_id  = azuredevops_git_repository.alz.id
      repository_ref = azuredevops_git_repository.alz.default_branch
      match_type     = "Exact"
    }
  }
}

resource "azuredevops_branch_policy_merge_types" "alz" {
  depends_on = [azuredevops_git_repository_file.alz]
  project_id = local.project_id

  enabled  = true
  blocking = true

  settings {
    allow_squash                  = true
    allow_rebase_and_fast_forward = false
    allow_basic_no_fast_forward   = false
    allow_rebase_with_merge       = false

    scope {
      repository_id  = azuredevops_git_repository.alz.id
      repository_ref = azuredevops_git_repository.alz.default_branch
      match_type     = "Exact"
    }
  }
}

resource "azuredevops_branch_policy_build_validation" "alz" {
  depends_on = [azuredevops_git_repository_file.alz]
  project_id = local.project_id

  enabled  = true
  blocking = true

  settings {
    display_name        = "Terraform Validation"
    build_definition_id = azuredevops_build_definition.alz["ci"].id
    valid_duration      = 720

    scope {
      repository_id  = azuredevops_git_repository.alz.id
      repository_ref = azuredevops_git_repository.alz.default_branch
      match_type     = "Exact"
    }
  }
}
