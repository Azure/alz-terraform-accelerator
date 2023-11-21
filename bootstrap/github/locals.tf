# Resource Name Setup
locals {
  resource_names = module.resource_names.resource_names
}

locals {
  plan_key  = "plan"
  apply_key = "apply"
}

locals {
  environments = {
    (local.plan_key)  = local.resource_names.version_control_system_environment_plan
    (local.apply_key) = local.resource_names.version_control_system_environment_apply
  }
}

locals {
  managed_identities = {
    (local.plan_key)  = local.resource_names.user_assigned_managed_identity_plan
    (local.apply_key) = local.resource_names.user_assigned_managed_identity_apply
  }

  federated_credentials = {
    (local.plan_key) = {
      federated_credential_subject = module.github.subjects[local.plan_key]
      federated_credential_issuer  = module.github.issuer
      federated_credential_name    = local.resource_names.user_assigned_managed_identity_federated_credentials_plan
    }
    (local.apply_key) = {
      federated_credential_subject = module.github.subjects[local.apply_key]
      federated_credential_issuer  = module.github.issuer
      federated_credential_name    = local.resource_names.user_assigned_managed_identity_federated_credentials_apply
    }
  }
}
