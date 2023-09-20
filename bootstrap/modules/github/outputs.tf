output "organization_url" {
  value = local.organization_url
}

output "subjects" {
  value = {
    plan  = "repo:${var.organization_name}/${var.repository_name}:environment:${var.environment_name_plan}"
    apply = "repo:${var.organization_name}/${var.repository_name}:environment:${var.environment_name_apply}"
  }
}

output "issuer" {
  value = "https://token.actions.githubusercontent.com"
}

output "organization_users" {
  value = data.github_organization.alz.users
}
