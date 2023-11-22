locals {
  organization_url = startswith(lower(var.organization_name), "https://") || startswith(lower(var.organization_name), "http://") ? var.organization_name : "https://github.com/${var.organization_name}"
}

locals {
  plan_key  = "plan"
  apply_key = "apply"
}

locals {
  primary_approver     = length(var.approvers) > 0 ? var.approvers[0] : ""
  default_commit_email = coalesce(local.primary_approver, "demo@microsoft.com")
}

locals {
  repository_name_templates = var.use_template_repository ? var.repository_name_templates : var.repository_name
  template_claim_structure  = "${var.organization_name}/${local.repository_name_templates}/%s@refs/heads/main"
  ci_template_path          = var.pipeline_templates.ci.target_path
  cd_template_path          = var.pipeline_templates.cd.target_path
  ci_template_claim         = format(local.template_claim_structure, local.ci_template_path)
  cd_template_claim         = format(local.template_claim_structure, local.cd_template_path)

  oidc_subjects = {
    ("${local.plan_key}-ci") = {
      user_assigned_managed_identity_key = local.plan_key
      subject                            = "repo:${var.organization_name}/${var.repository_name}:environment:${var.environments[local.plan_key]}:job_workflow_ref:${local.ci_template_claim}"
    }
    ("${local.plan_key}-cd") = {
      user_assigned_managed_identity_key = local.plan_key
      subject                            = "repo:${var.organization_name}/${var.repository_name}:environment:${var.environments[local.plan_key]}:job_workflow_ref:${local.cd_template_claim}"
    }
    ("${local.apply_key}-cd") = {
      user_assigned_managed_identity_key = local.apply_key
      subject                            = "repo:${var.organization_name}/${var.repository_name}:environment:${var.environments[local.apply_key]}:job_workflow_ref:${local.cd_template_claim}"
    }
  }
}
