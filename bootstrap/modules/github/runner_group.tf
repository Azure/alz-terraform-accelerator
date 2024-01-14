resource "github_actions_runner_group" "alz" {
  for_each                = data.github_organization.alz.plan == local.enterprise_plan ? var.runner_groups : {}
  name                    = each.value
  visibility              = "selected"
  selected_repository_ids = var.use_template_repository ? [github_repository.alz.repo_id, github_repository.alz_templates[0].repo_id] : [github_repository.alz.repo_id]
}
