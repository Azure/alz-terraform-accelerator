# Azure Variables
runner_container_image = "jaredfholgate/github-runner:0.0.4"

# Naming
resource_names = {
  resource_group_state                                        = "rg-{{service_name}}-{{environment_name}}-state-{{azure_location}}-{{postfix_number}}"
  resource_group_identity                                     = "rg-{{service_name}}-{{environment_name}}-identity-{{azure_location}}-{{postfix_number}}"
  resource_group_agents                                       = "rg-{{service_name}}-{{environment_name}}-agents-{{azure_location}}-{{postfix_number}}"
  resource_group_network                                      = "rg-{{service_name}}-{{environment_name}}-network-{{azure_location}}-{{postfix_number}}"
  user_assigned_managed_identity_plan                         = "id-{{service_name}}-{{environment_name}}-{{azure_location}}-plan-{{postfix_number}}"
  user_assigned_managed_identity_apply                        = "id-{{service_name}}-{{environment_name}}-{{azure_location}}-apply-{{postfix_number}}"
  user_assigned_managed_identity_federated_credentials_prefix = "{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number}}"
  storage_account                                             = "sto{{service_name}}{{environment_name}}{{azure_location_short}}{{postfix_number}}{{random_string}}"
  storage_container                                           = "{{environment_name}}-tfstate"
  container_instance_01                                       = "aci-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number}}"
  container_instance_02                                       = "aci-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number_plus_1}}"
  runner_01                                                   = "runner-{{service_name}}-{{environment_name}}-{{postfix_number}}"
  runner_02                                                   = "runner-{{service_name}}-{{environment_name}}-{{postfix_number_plus_1}}"
  version_control_system_repository                           = "{{service_name}}-{{environment_name}}"
  version_control_system_repository_templates                 = "{{service_name}}-{{environment_name}}-templates"
  version_control_system_environment_plan                     = "{{service_name}}-{{environment_name}}-plan"
  version_control_system_environment_apply                    = "{{service_name}}-{{environment_name}}-apply"
  version_control_system_team                                 = "{{service_name}}-{{environment_name}}-approvers"
  version_control_system_runner_group                         = "{{service_name}}-{{environment_name}}"
  virtual_network                                             = "vnet-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number}}"
  subnet_container_instances                                  = "subnet-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number}}-aci"
  subnet_storage                                              = "subnet-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number}}-sto"
  private_endpoint                                            = "pe-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number}}"
}

# Version Control System Variables
module_folder_path   = "../../templates"
pipeline_folder_path = "../../templates/ci_cd"
pipeline_files = {
  ci = {
    file_path   = "github/ci.yaml"
    target_path = ".github/workflows/ci.yaml"
  }
  cd = {
    file_path   = "github/cd.yaml"
    target_path = ".github/workflows/cd.yaml"
  }
}
pipeline_template_files = {
  ci = {
    file_path   = "github/templates/ci.yaml"
    target_path = ".github/workflows/ci_template.yaml"
    environment_user_assigned_managed_identity_mappings = [{
      environment_key                    = "plan"
      user_assigned_managed_identity_key = "plan"
    }]
  }
  cd = {
    file_path   = "github/templates/cd.yaml"
    target_path = ".github/workflows/cd_template.yaml"
    environment_user_assigned_managed_identity_mappings = [{
      environment_key                    = "plan"
      user_assigned_managed_identity_key = "plan"
      },
      {
        environment_key                    = "apply"
        user_assigned_managed_identity_key = "apply"
    }]
  }
}
