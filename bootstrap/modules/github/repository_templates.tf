resource "github_repository" "alz_templates" {
  count               = var.use_template_repository ? 1 : 0
  name                = var.repository_name_templates
  description         = var.repository_name_templates
  auto_init           = true
  visibility          = data.github_organization.alz.plan == "free" ? "public" : "private"
  allow_update_branch = true
  allow_merge_commit  = false
  allow_rebase_merge  = false
}

resource "github_repository_file" "alz_templates" {
  for_each            = var.use_template_repository ? local.cicd_template_files : {}
  repository          = github_repository.alz_templates[0].name
  file                = each.key
  content             = each.value.content
  commit_author       = local.default_commit_email
  commit_email        = local.default_commit_email
  commit_message      = "Add ${each.key} [skip ci]"
  overwrite_on_create = true
}

resource "github_branch_protection" "alz_templates" {
  count                           = var.use_template_repository ? 1 : 0
  depends_on                      = [github_repository_file.alz_templates]
  repository_id                   = github_repository.alz_templates[0].name
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
