locals {
  organization_url = startswith(lower(var.organization_name), "https://") || startswith(lower(var.organization_name), "http://") ? var.organization_name : "https://github.com/${var.organization_name}"
}

locals {
  primary_approver      = length(var.approvers) > 0 ? var.approvers[0] : ""
  default_commit_email  = coalesce(local.primary_approver, "demo@microsoft.com")
}