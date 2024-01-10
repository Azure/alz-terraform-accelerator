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

  federated_credentials = { for key, value in module.github.subjects :
    key => {
      user_assigned_managed_identity_key = value.user_assigned_managed_identity_key
      federated_credential_subject       = value.subject
      federated_credential_issuer        = module.github.issuer
      federated_credential_name          = "${local.resource_names.user_assigned_managed_identity_federated_credentials_prefix}-${key}"
    }
  }

  agent_container_instances = var.use_self_hosted_agents ? {
    agent_01 = {
      container_instance_name = local.resource_names.container_instance_01
      agent_name              = local.resource_names.agent_01
      managed_identity_key    = local.plan_key
      agent_pool_name         = module.azure_devops.is_authentication_scheme_managed_identity ? module.azure_devops.agent_pool_names[local.plan_key] : ""
    }
    agent_02 = {
      container_instance_name = local.resource_names.container_instance_02
      agent_name              = local.resource_names.agent_02
      managed_identity_key    = local.plan_key
      agent_pool_name         = module.azure_devops.is_authentication_scheme_managed_identity ? module.azure_devops.agent_pool_names[local.plan_key] : ""
    }
    agent_03 = {
      container_instance_name = local.resource_names.container_instance_03
      agent_name              = local.resource_names.agent_03
      managed_identity_key    = local.apply_key
      agent_pool_name         = module.azure_devops.is_authentication_scheme_managed_identity ? module.azure_devops.agent_pool_names[local.apply_key] : ""
    }
    agent_04 = {
      container_instance_name = local.resource_names.container_instance_04
      agent_name              = local.resource_names.agent_04
      managed_identity_key    = local.apply_key
      agent_pool_name         = module.azure_devops.is_authentication_scheme_managed_identity ? module.azure_devops.agent_pool_names[local.apply_key] : ""
    }
  } : {}
}

locals {
  starter_module_folder_path = var.module_folder_path_relative ? ("${path.module}/${var.module_folder_path}/${var.starter_module}") : "${var.module_folder_path}/${var.starter_module}"
  pipeline_folder_path       = var.pipeline_folder_path_relative ? ("${path.module}/${var.pipeline_folder_path}") : var.pipeline_folder_path
}
