output "organization_url" {
  value = local.organization_url
}

output "subjects" {
  value = {
    "${local.plan_key}"  = "repo:${var.organization_name}/${var.repository_name}:environment:${var.environments[local.plan_key]}"
    "${local.apply_key}" = "repo:${var.organization_name}/${var.repository_name}:environment:${var.environments[local.apply_key]}"
  }
}

output "issuer" {
  value = "https://token.actions.githubusercontent.com"
}

output "organization_users" {
  value = data.github_organization.alz.users
}
