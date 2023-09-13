resource "github_repository_environment" "alz_plan" {
  environment = var.environment_name_plan
  repository  = github_repository.alz.name
}

resource "github_repository_environment" "alz_apply" {
  environment = var.environment_name_apply
  repository  = github_repository.alz.name
}

