# Resource Name Setup
locals {
  resource_names = module.resource_names.resource_names
}

locals {
  plan_key  = "plan"
  apply_key = "apply"
}

locals {
  general_agent_pool_key = "general"
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

  runner_container_instances = var.use_self_hosted_runners ? {
    agent_01 = {
      container_instance_name = local.resource_names.container_instance_01
      agent_name              = local.resource_names.runner_01
      agent_pool_name         = module.github.runner_group_names[local.general_agent_pool_key]
      cpu                     = var.runner_container_cpu
      memory                  = var.runner_container_memory
      cpu_max                 = var.runner_container_cpu_max
      memory_max              = var.runner_container_memory_max
    }
    agent_02 = {
      container_instance_name = local.resource_names.container_instance_02
      agent_name              = local.resource_names.runner_02
      agent_pool_name         = module.github.runner_group_names[local.general_agent_pool_key]
      cpu                     = var.runner_container_cpu
      memory                  = var.runner_container_memory
      cpu_max                 = var.runner_container_cpu_max
      memory_max              = var.runner_container_memory_max
    }
  } : {}

  runner_groups = var.use_self_hosted_runners ? {
    (local.general_agent_pool_key) = local.resource_names.version_control_system_runner_group
  } : {}
}

locals {
  starter_module_folder_path = var.module_folder_path_relative ? ("${path.module}/${var.module_folder_path}/${var.starter_module}") : "${var.module_folder_path}/${var.starter_module}"
  pipeline_folder_path       = var.pipeline_folder_path_relative ? ("${path.module}/${var.pipeline_folder_path}") : var.pipeline_folder_path
}
