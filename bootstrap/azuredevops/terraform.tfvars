# Azure Variables
agent_container_image = "jaredfholgate/azure-devops-agent:0.0.3"

# Names
resource_names = {
  resource_group_state                                       = "rg-{{service_name}}-{{environment_name}}-state-{{azure_location}}-{{postfix_number}}"
  resource_group_identity                                    = "rg-{{service_name}}-{{environment_name}}-identity-{{azure_location}}-{{postfix_number}}"
  resource_group_agents                                      = "rg-{{service_name}}-{{environment_name}}-agents-{{azure_location}}-{{postfix_number}}"
  user_assigned_managed_identity_plan                        = "id-{{service_name}}-{{environment_name}}-{{azure_location}}-plan-{{postfix_number}}"
  user_assigned_managed_identity_apply                       = "id-{{service_name}}-{{environment_name}}-{{azure_location}}-apply-{{postfix_number}}"
  user_assigned_managed_identity_federated_credentials_plan  = "id-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number}}-plan"
  user_assigned_managed_identity_federated_credentials_apply = "id-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number}}-apply"
  storage_account                                            = "sto{{service_name}}{{environment_name}}{{azure_location_short}}{{postfix_number}}{{random_string}}"
  storage_container                                          = "{{environment_name}}-tfstate"
  container_instance_01                                      = "aci-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number}}"
  container_instance_02                                      = "aci-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number_plus_1}}"
  container_instance_03                                      = "aci-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number_plus_2}}"
  container_instance_04                                      = "aci-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number_plus_3}}"
  agent_01                                                   = "agent-{{service_name}}-{{environment_name}}-{{postfix_number}}"
  agent_02                                                   = "agent-{{service_name}}-{{environment_name}}-{{postfix_number_plus_1}}"
  agent_03                                                   = "agent-{{service_name}}-{{environment_name}}-{{postfix_number_plus_2}}"
  agent_04                                                   = "agent-{{service_name}}-{{environment_name}}-{{postfix_number_plus_3}}"
  version_control_system_repository                          = "{{service_name}}-{{environment_name}}"
  version_control_system_repository_templates                = "{{service_name}}-{{environment_name}}-templates"
  version_control_system_service_connection_plan             = "sc-{{service_name}}-{{environment_name}}-plan"
  version_control_system_service_connection_apply            = "sc-{{service_name}}-{{environment_name}}-apply"
  version_control_system_environment_plan                    = "{{service_name}}-{{environment_name}}-plan"
  version_control_system_environment_apply                   = "{{service_name}}-{{environment_name}}-apply"
  version_control_system_variable_group                      = "{{service_name}}-{{environment_name}}"
  version_control_system_agent_pool_plan                     = "{{service_name}}-{{environment_name}}-plan"
  version_control_system_agent_pool_apply                    = "{{service_name}}-{{environment_name}}-apply"
  version_control_system_group                               = "{{service_name}}-{{environment_name}}-approvers"
}

# Version Control System Variables
module_folder_path   = "../../templates"
pipeline_folder_path = "../../templates/ci_cd"

pipeline_files = {
  ci = {
    pipeline_name = "01 Azure Landing Zone Continuous Integration"
    file_path     = "azuredevops/ci.yaml"
    target_path   = ".pipelines/ci.yaml"
    environment_keys = [
      "plan"
    ]
    service_connection_keys = [
      "plan"
    ]
    agent_pool_keys = [
      "plan"
    ]
  }
  cd = {
    pipeline_name = "02 Azure Landing Zone Continuous Delivery"
    file_path     = "azuredevops/cd.yaml"
    target_path   = ".pipelines/cd.yaml"
    environment_keys = [
      "plan",
      "apply"
    ]
    service_connection_keys = [
      "plan",
      "apply"
    ]
    agent_pool_keys = [
      "plan",
      "apply"
    ]
  }
}
pipeline_template_files = {
  ci = {
    file_path   = "azuredevops/templates/ci.yaml"
    target_path = "ci.yaml"
  }
  cd = {
    file_path   = "azuredevops/templates/cd.yaml"
    target_path = "cd.yaml"
  }
  terraform-installer = {
    file_path   = "azuredevops/templates/terraform-installer.yaml"
    target_path = "terraform-installer.yaml"
  }
  terraform-init = {
    file_path   = "azuredevops/templates/terraform-init.yaml"
    target_path = "terraform-init.yaml"
  }
  terraform-plan = {
    file_path   = "azuredevops/templates/terraform-plan.yaml"
    target_path = "terraform-plan.yaml"
  }
  terrafrom-apply = {
    file_path   = "azuredevops/templates/terraform-apply.yaml"
    target_path = "terraform-apply.yaml"
  }
}
