# Resource Name Setup
locals {
  resource_names = module.resource_names.resource_names
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
  managed_identities = {
    (local.plan_key)  = local.resource_names.user_assigned_managed_identity_plan
    (local.apply_key) = local.resource_names.user_assigned_managed_identity_apply
  }

  federated_credentials = module.azure_devops.is_authentication_scheme_workload_identity_federation ? {
    (local.plan_key) = {
      user_assigned_managed_identity_key = local.plan_key
      federated_credential_subject       = module.azure_devops.is_authentication_scheme_workload_identity_federation ? module.azure_devops.subjects[local.plan_key] : ""
      federated_credential_issuer        = module.azure_devops.is_authentication_scheme_workload_identity_federation ? module.azure_devops.issuers[local.plan_key] : ""
      federated_credential_name          = local.resource_names.user_assigned_managed_identity_federated_credentials_plan
    }
    (local.apply_key) = {
      user_assigned_managed_identity_key = local.apply_key
      federated_credential_subject       = module.azure_devops.is_authentication_scheme_workload_identity_federation ? module.azure_devops.subjects[local.apply_key] : ""
      federated_credential_issuer        = module.azure_devops.is_authentication_scheme_workload_identity_federation ? module.azure_devops.issuers[local.apply_key] : ""
      federated_credential_name          = local.resource_names.user_assigned_managed_identity_federated_credentials_apply
    }
  } : {}

  agent_container_instances = module.azure_devops.is_authentication_scheme_managed_identity ? {
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
  environments = {
    (local.plan_key) = {
      environment_name        = local.resource_names.version_control_system_environment_plan
      service_connection_name = local.resource_names.version_control_system_service_connection_plan
      service_connection_template_keys = [
        local.ci_key,
        local.cd_key
      ]
      agent_pool_name = local.resource_names.version_control_system_agent_pool_plan
    }
    (local.apply_key) = {
      environment_name        = local.resource_names.version_control_system_environment_apply
      service_connection_name = local.resource_names.version_control_system_service_connection_apply
      service_connection_template_keys = [
        local.cd_key
      ]
      agent_pool_name = local.resource_names.version_control_system_agent_pool_apply
    }
  }
}
