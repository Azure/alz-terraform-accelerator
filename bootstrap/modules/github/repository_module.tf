resource "github_repository" "alz" {
  name                = var.repository_name
  description         = var.repository_name
  auto_init           = true
  visibility          = data.github_organization.alz.plan == local.free_plan ? "public" : "private"
  allow_update_branch = true
  allow_merge_commit  = false
  allow_rebase_merge  = false
}

resource "github_repository_file" "alz" {
  for_each            = local.repository_files
  repository          = github_repository.alz.name
  file                = each.key
  content             = each.value.content
  commit_author       = local.default_commit_email
  commit_email        = local.default_commit_email
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
    required_approving_review_count = length(var.approvers) > 1 ? 1 : 0
  }
}
