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

  oidc_subjects_flattened = flatten([for key, value in var.pipeline_templates : [
    for environment_user_assigned_managed_identity_mapping in value.environment_user_assigned_managed_identity_mappings :
    {
      subject_key                        = "${key}-${environment_user_assigned_managed_identity_mapping.user_assigned_managed_identity_key}"
      user_assigned_managed_identity_key = environment_user_assigned_managed_identity_mapping.user_assigned_managed_identity_key
      subject                            = "repo:${var.organization_name}/${var.repository_name}:environment:${var.environments[environment_user_assigned_managed_identity_mapping.environment_key]}:job_workflow_ref:${format(local.template_claim_structure, value.target_path)}"
    }
    ]
  ])

  oidc_subjects = { for oidc_subject in local.oidc_subjects_flattened : oidc_subject.subject_key => {
    user_assigned_managed_identity_key = oidc_subject.user_assigned_managed_identity_key
    subject                            = oidc_subject.subject
  } }
}
