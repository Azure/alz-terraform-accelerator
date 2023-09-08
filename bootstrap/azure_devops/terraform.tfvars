# Naming Variables
service_name     = "alz"
environment_name = "mgmt"
postfix_number   = 1

# Version Control System Variables
version_control_system_access_token = "madeupstring"
version_control_system_organization = "alz"
template_folder_path                = "../../templates"
ci_cd_module                        = ".ci_cd"
starter_module                      = "basic"
apply_approvers                     = []

# Azure Variables
azure_location        = "uksouth"
agent_container_image = "jaredfholgate/azure-devops-agent:0.0.3"

# Azure DevOps Specific Variables
azure_devops_use_organisation_legacy_url = false
azure_devops_project_name                = "alz"
azure_devops_create_project              = true
azure_devops_authentication_scheme       = "ManagedServiceIdentity"