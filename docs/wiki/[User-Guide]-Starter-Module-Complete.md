<!-- markdownlint-disable first-line-h1 -->
The `complete` starter module provides full customization of the Azure Landing Zone using the `config.yaml` file. The `config.yaml` file provides the ability to enable and disable modules, configure module inputs and outputs, and configure module resources.
A custom `config.yaml` file can be passed to the `additional_files` argument of the ALZ PowerShell Module. This allows you to firstly design your Azure Landing Zone, and then deploy it.
If not specified, the default `config.yaml` file will be used, which is as follows:
  
  ```yaml
# This file contains templated variables to avoid repeating the same hard-coded values.
# Templated variables are denoted by the dollar curly braces token. The following details each templated variable that you can use:
# `default_location`: This is an Azure location sourced from the `default_location` variable. This can be used to set the location of resources.
# `root_parent_management_group_id`: This is the id of the management group that the ALZ hierarchy will be nested under.
# `subscription_id_identity`: The subscription ID of the subscription to deploy the identity resources to, sourced from the variable `subscription_id_identity`.
# `subscription_id_connectivity`: The subscription ID of the subscription to deploy the connectivity resources to, sourced from the variable `subscription_id_connectivity`.
# `subscription_id_management`: The subscription ID of the subscription to deploy the management resources to, sourced from the variable `subscription_id_management`.
---
archetypes: # `caf-enterprise-scale` module, add inputs as listed on the module registry where necessary.
  root_name: es
  root_id: Enterprise-Scale

  subscription_id_connectivity: ${subscription_id_connectivity}
  subscription_id_identity: ${subscription_id_identity}
  subscription_id_management: ${subscription_id_management}
  root_parent_id: ${root_parent_management_group_id}
  deploy_corp_landing_zones: true
  deploy_online_landing_zones: true
  default_location: ${default_location}
  disable_telemetry: true
  deploy_management_resources: true
  configure_management_resources:
    location: ${default_location}
    settings:
      security_center:
        config:
          email_security_contact: "security_contact@replace_me"
    advanced:
      asc_export_resource_group_name: rg-asc-export
      custom_settings_by_resource_type:
        azurerm_resource_group:
          management:
            name: rg-management
        azurerm_log_analytics_workspace:
          management:
            name: log-management
        azurerm_automation_account:
          management:
            name: aa-management
connectivity:
  hubnetworking: # `hubnetworking` module, add inputs as listed on the module registry where necessary.
    hub_virtual_networks:
      primary:
        name: vnet-hub
        resource_group_name: rg-connectivity
        location: ${default_location}
        address_space:
          - 10.0.0.0/16
        firewall:
          name: fw-hub
          sku_name: AZFW_VNet
          sku_tier: Standard
          subnet_address_prefix: 10.0.1.0/24
        virtual_network_gateway: # `vnet-gateway` module, add inputs as listed on the module registry where necessary.
          name: vgw-hub
          sku: VpnGw1
          type: Vpn
          subnet_address_prefix: 10.0.2.0/24

  ```

The `config.yaml` file also comes with helpful templated variables such as `default_location` and `root_parent_management_group_id` which get prompted for during the ALZ PowerShell Module run. Alternatively, you can opt to not use the templated variables and hard-code the values in the `config.yaml` file.

> **Note:** We recommend that you use the `caf-enterprise-scale` module for management groups and policies, and the `hubnetworking` module for connectivity resources. However, connectivity resources can be deployed using the `caf-enterprise-scale` module if you desire.

The schema for the `config.yaml` is documented here - [YAML Schema for `config.yaml`][wiki_yaml_schema_reference].

## High Level Design

![Alt text](./media/starter-module-hubnetworking.png)

## Terraform Modules

### `caf-enterprise-scale`

The `caf-enterprise-scale` module is used to deploy the management group hierarchy, policy assignments and management resources. For more information on the module itself see [here](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale).

### `hubnetworking`

The `hubnetworking` module is used to deploy connectivity resources such as Virtual Networks and Firewalls.
This module can be extended to deploy multiple Virtual Networks at scale, Route Tables, and Resource Locks. For more information on the module itself see [here](https://github.com/Azure/terraform-azurerm-hubnetworking).

### `vnet-gateway`

The `vnet-gateway` module is used to deploy a Virtual Network Gateway inside your Virtual Network. Further configuration can be added (depending on requirements) to deploy Local Network Gateways, configure Virtual Network Gateway Connections, deploy ExpressRoute Gateways, and more. Additional information on the module can be found [here](https://github.com/Azure/terraform-azurerm-vnet-gateway).

## Inputs

- `default_location`: The default location to deploy resources to.
- `root_parent_management_group_id`: The id of the management group that the ALZ hierarchy will be nested under.
- `subscription_id_connectivity`: The identifier of the Connectivity Subscription.
- `subscription_id_identity`: The identifier of the Identity Subscription.
- `subscription_id_management`: The identifier of the Management Subscription.
- `configuration_file_path`: This is the path to your custom config file if you wish to supply one. Leaving this empty will use the default `config.yaml` file. This must be specified as an absolute file paths (e.g. c:\\my-config\\my-config.yaml or /home/user/my-config/my-config.yaml). If you don't supply an absolute path, it will fail.

## Example

### Design your Azure Landing Zone through a custom config file

Create a custom yaml config to tailor to your needs, for example an Azure Landing Zone with a three-region mesh:

- Example file for hub and spoke: [config-hub-spoke.yaml][example_starter_module_complete_config_hub_spoke]
- Example file for Virtual WAN: [config-vwan.yaml][example_starter_module_complete_config_vwan]

```yaml

# Path of file: C:\users\johndoe\my-config.yaml

archetypes: # `caf-enterprise-scale` module, add inputs as listed on the module registry where necessary.
  root_name: es
  root_id: Enterprise-Scale
  deploy_corp_landing_zones: true
  deploy_online_landing_zones: true
  default_location: uksouth
  disable_telemetry: true
  deploy_management_resources: true
connectivity:
  hubnetworking: # `hubnetworking` module, add inputs as listed on the module registry where necessary.
    hub_virtual_networks:
      primary:
        name: vnet-hub-uks
        resource_group_name: rg-connectivity-uks
        location: uksouth
        mesh_peering_enabled: true
        address_space:
          - 10.0.0.0/16
      secondary:
        name: vnet-hub-ukw
        resource_group_name: rg-connectivity-ukw
        location: ukwest
        mesh_peering_enabled: true
        address_space:
          - 10.1.0.0/16
      tertiary:
        name: vnet-hub-ne
        resource_group_name: rg-connectivity-ne
        location: northeurope
        mesh_peering_enabled: true
        address_space:
          - 10.2.0.0/16
    
```

### Use the ALZ PowerShell Module to prepare your Azure Landing Zone for deployment

Set your inputs.yaml file (See [Frequently Asked Questions][wiki_frequently_asked_questions] for more information on the `inputs.yaml` file.) for the `New-ALZEnvironment` command as follows:

> **Note:** This is an alternative way of supplying the input arguments to the ALZ PowerShell Module, you can still run it as documented in the Quick Start guide and be prompted for inputs.

GitHub Example:

- Example file: [inputs-github.yaml][example_powershell_inputs_github]

```yaml
# Path of file: C:\users\johndoe\inputs.yaml

starter_module: "complete"
azure_location: "uksouth"
github_personal_system_access_token: "xxxxxxxxxx"
github_organization_name: "contoso"
azure_location": "uksouth"
azure_subscription_id: "00000000-0000-0000-0000-000000000000"
service_name: "alz"
environment_name: "mgmt"
postfix_number: "1"
root_parent_management_group_display_name: "Tenant Root Group"
version_control_system_use_separate_repository_for_templates: "true"
use_self_hosted_agents: "true"
use_private_networking: "true"
allow_storage_access_from_my_ip: "false"

# Starter Module Specific Variables
subscription_id_connectivity: "00000000-0000-0000-0000-000000000000"
subscription_id_identity: "00000000-0000-0000-0000-000000000000"
subscription_id_management: "00000000-0000-0000-0000-000000000000"
configuration_file_path: "C:\users\johndoe\config.yaml"
```

Azure DevOps Example:

- Example file: [inputs-azure-devops.yaml][example_powershell_inputs_azure_devops]

```yaml
# Path of file: C:\users\johndoe\inputs.yaml

starter_module: "complete"
azure_location: "uksouth"
azure_devops_personal_system_access_token: "xxxxxxxxxx"
azure_devops_organization_name: "contoso"
azure_location": "uksouth"
azure_subscription_id: "00000000-0000-0000-0000-000000000000"
service_name: "alz"
environment_name: "mgmt"
postfix_number: "1"
azure_devops_use_organisation_legacy_url: "false"
azure_devops_create_project: "true"
azure_devops_project_name: "alz-demo"
azure_devops_authentication_scheme: "WorkloadIdentityFederation"
root_parent_management_group_display_name: "Tenant Root Group"
version_control_system_use_separate_repository_for_templates: "true"
use_self_hosted_agents: "true"
use_private_networking: "true"
allow_storage_access_from_my_ip: "false"

# Starter Module Specific Variables
subscription_id_connectivity: "00000000-0000-0000-0000-000000000000"
subscription_id_identity: "00000000-0000-0000-0000-000000000000"
subscription_id_management: "00000000-0000-0000-0000-000000000000"
configuration_file_path: "C:\users\johndoe\config.yaml"
```

Run the accelerator:

```powershell
# Working Directory: C:\users\johndoe
New-ALZEnvironment -i "terraform" -c "azuredevops" -Inputs "inputs.yaml" -autoApprove -v "v0.4.0"
```

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[wiki_yaml_schema_reference]: %5BUser-Guide%5D-YAML-Schema-Reference "Wiki - YAML Schema Reference"
[wiki_frequently_asked_questions]: Frequently-Asked-Questions "Wiki - Frequently Asked Questions"
[example_powershell_inputs_azure_devops]: examples/powershell-inputs/inputs-azure-devops.yaml "Example - PowerShell Inputs - Azure DevOps"
[example_powershell_inputs_github]: examples/powershell-inputs/inputs-github.yaml "Example - PowerShell Inputs - GitHub"
[example_starter_module_complete_config_hub_spoke]: examples/starter-module-complete/config-huib-spoke.yaml "Example - Starter Module Config - Complete - Hub and Spoke"
[example_starter_module_complete_config_vwan]: examples/starter-module-complete/config-vwan.yaml "Example - Starter Module Config - Complete - Virtual WAN"
