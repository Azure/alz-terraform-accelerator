# Version Control System Variables
template_folder_path = "../../templates"
ci_cd_module         = ".ci_cd"

# Azure Variables
agent_container_image = "jaredfholgate/azure-devops-agent:0.0.3"

# Names
resource_names = {
  resource_group_state                                 = "rg-{{service_name}}-{{environment_name}}-state-{{azure_location}}-{{postfix_number}}"
  resource_group_identity                              = "rg-{{service_name}}-{{environment_name}}-identity-{{azure_location}}-{{postfix_number}}"
  resource_group_agents                                = "rg-{{service_name}}-{{environment_name}}-agents-{{azure_location}}-{{postfix_number}}"
  user_assigned_managed_identity                       = "id-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number}}"
  user_assigned_managed_identity_federated_credentials = "id-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number}}"
  storage_account                                      = "sto{{service_name}}{{environment_name}}{{azure_location_short}}{{postfix_number}}{{random_string}}"
  storage_container                                    = "{{environment_name}}-tfstate"
  container_instance_01                                = "aci-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number}}"
  container_instance_02                                = "aci-{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number_plus_one}}"
  agent_01                                             = "agent-{{service_name}}-{{environment_name}}-{{postfix_number}}"
  agent_02                                             = "agent-{{service_name}}-{{environment_name}}-{{postfix_number_plus_one}}"
  version_control_system_repository                    = "{{service_name}}-{{environment_name}}"
  version_control_system_service_connection            = "sc-{{service_name}}-{{environment_name}}"
  version_control_system_environment_plan              = "{{service_name}}-{{environment_name}}-plan"
  version_control_system_environment_apply             = "{{service_name}}-{{environment_name}}-apply"
  version_control_system_variable_group                = "{{service_name}}-{{environment_name}}"
  version_control_system_agent_pool                    = "{{service_name}}-{{environment_name}}"
  version_control_system_group                         = "{{service_name}}-{{environment_name}}-approvers"
}