locals {
  organization_url = startswith(lower(var.organization_name), "https://") || startswith(lower(var.organization_name), "http://") ? var.organization_name : (var.use_legacy_organization_url ? "https://${var.organization_name}.visualstudio.com" : "https://dev.azure.com/${var.organization_name}")
}

locals {
  plan_key  = "plan"
  apply_key = "apply"
}

locals {
  ci_key = "ci"
  cd_key = "cd"
}

locals {
  authentication_scheme_managed_identity                = "ManagedServiceIdentity"
  authentication_scheme_workload_identity_federation    = "WorkloadIdentityFederation"
  is_authentication_scheme_managed_identity             = var.authentication_scheme == local.authentication_scheme_managed_identity
  is_authentication_scheme_workload_identity_federation = var.authentication_scheme == local.authentication_scheme_workload_identity_federation
}

locals {
  default_branch = "refs/heads/main"
}
