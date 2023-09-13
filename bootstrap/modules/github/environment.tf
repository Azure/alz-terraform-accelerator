resource "github_repository_environment" "alz_plan" {
  environment = var.environment_name_plan
  repository  = github_repository.alz.name
}

resource "github_repository_environment" "alz_apply" {
  depends_on = [ github_team_repository.alz ]
  environment = var.environment_name_apply
  repository  = github_repository.alz.name
  reviewers {
    teams = [
       github_team.alz.id
    ]
  }
  deployment_branch_policy {
    protected_branches = true
    custom_branch_policies = false
  }
}

