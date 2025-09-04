# Quickstart

This readme will help you get started quickly with a set of files based on the [ALZ + Management](https://registry.terraform.io/modules/Azure/avm-ptn-alz/azurerm/latest/examples/management) example.

It is assumed that you have already followed a [bootstrap](./BOOTSTRAP.md) process to create your repo and plumb it in with the managed identities, federated credentials, remote state, and private runners.

## Clone

Your repository will be named `https://github.com/my_org_name/alz-mgmt` if you have used the default values in the inputs.yml, i.e. `service_name: "alz"` and `environment_name: "mgmt"`.

1. Example git clone command.

    ```shell
    git clone https://github.com/my_org_name/alz-mgmt.git
    ```

    Your GitHub organisation name will be different.

1. Open in Visual Studio Code.

    ```shell
    cd alz-mgmt
    code .
    ```

## Create a branch

The branch protection rules will prevent a direct commit to the main branch. Create a new branch and give it a name, e.g. `alz`.

You can use any of these approaches:

- Command Palette (`CTRL`+`SHIFT`+`P`) >  _Git: Create Branch_
- click on the branch name in the status bar and _Create new branch_
- `git checkout -b alz` in the terminal

## Example config

Below is a set of example Terraform files based on the example for you to copy and paste.

1. Update terraform.tf

    Add an alz provider block to terraform.tf.

    ```ruby
    provider "alz" {
      library_references = [
        {
          path = "platform/alz"
          ref  = "2025.02.0"
        }
      ]
    }
    ```

1. Update variables.tf

    Add to the variables in variables.tf.

    ```ruby
    variable "location" {
      type        = string
      default     = "uksouth"
      description = "Location for the resources"
    }

    variable "email_security_contact" {
      type        = string
      default     = ""
      description = "Email address for security alerts"
    }
    ```

1. Add terraform.tfvars (optional)

    Create a terraform.tfvars file to override the defaults, e.g.:

    ```shell
    location               = "westeurope"
    email_security_contact = "first.last@contoso.com"
    ```

1. Add main.tf

    The main.tf file calls the AVM modules.

    ```ruby
    data "azapi_client_config" "current" {}

    module "management_resources" {
      # <https://registry.terraform.io/modules/Azure/avm-ptn-alz-management/azurerm/latest>
      source  = "Azure/avm-ptn-alz-management/azurerm"
      version = "0.8.0"

      location                     = var.location
      resource_group_name          = local.management_resource_group_name
      automation_account_name      = local.automation_account_name
      log_analytics_workspace_name = local.log_analytics_workspace_name

      data_collection_rules = {
        "change_tracking" = {
          "name" = local.dcr_change_tracking_name
        }
        "defender_sql" = {
          "name" = local.dcr_defender_sql_name
        }
        "vm_insights" = {
          "name" = local.dcr_vm_insights_name
        }
      }

      user_assigned_managed_identities = {
        ama = {
          name = local.ama_user_assigned_managed_identity_name
        }
      }
    }

    module "management_groups" {
      # <https://registry.terraform.io/modules/Azure/avm-ptn-alz/azurerm/latest>
      source  = "Azure/avm-ptn-alz/azurerm"
      version = "0.12.3"

      architecture_name  = "alz"
      location           = var.location
      parent_resource_id = data.azapi_client_config.current.tenant_id # Tenant root group
      retries            = local.default_retries
      timeouts           = local.default_timeouts

      dependencies = {
        policy_assignments = [
          module.management_resources.data_collection_rule_ids,
          module.management_resources.resource_id,
          module.management_resources.user_assigned_identity_ids,
        ]
      }

      policy_assignments_to_modify = {
        "alz" = {
          "policy_assignments" = {
            "Deploy-MDFC-Config-H224" = {
              "parameters" = {
                "ascExportResourceGroupLocation"              = jsonencode({ value = var.location })
                "ascExportResourceGroupName"                  = jsonencode({ value = "rg-asc-export-${var.location}" })
                "emailSecurityContact"                        = jsonencode({ value = var.email_security_contact })
                "enableAscForAppServices"                     = jsonencode({ value = "Disabled" })
                "enableAscForArm"                             = jsonencode({ value = "Disabled" })
                "enableAscForContainers"                      = jsonencode({ value = "Disabled" })
                "enableAscForCosmosDbs"                       = jsonencode({ value = "Disabled" })
                "enableAscForCspm"                            = jsonencode({ value = "Disabled" })
                "enableAscForKeyVault"                        = jsonencode({ value = "Disabled" })
                "enableAscForOssDb"                           = jsonencode({ value = "Disabled" })
                "enableAscForServers"                         = jsonencode({ value = "Disabled" })
                "enableAscForServersVulnerabilityAssessments" = jsonencode({ value = "Disabled" })
                "enableAscForSql"                             = jsonencode({ value = "Disabled" })
                "enableAscForSqlOnVm"                         = jsonencode({ value = "Disabled" })
                "enableAscForStorage"                         = jsonencode({ value = "Disabled" })
              }
            }
          }
        }
        "connectivity" = {
          "policy_assignments" = {
            "Enable-DDoS-VNET" = {
              "enforcement_mode" = "DoNotEnforce"
            }
          }
        }
        "corp" = {
          "policy_assignments" = {
            "Deploy-Private-DNS-Zones" = {
              "enforcement_mode" = "DoNotEnforce"
            }
          }
        }
        "landingzones" = {
          "policy_assignments" = {
            "Enable-DDoS-VNET" = {
              "enforcement_mode" = "DoNotEnforce"
            }
          }
        }
      }

      policy_default_values = {
        "ama_user_assigned_managed_identity_name"     = jsonencode({ value = local.ama_user_assigned_managed_identity_name })
        "ama_user_assigned_managed_identity_id"       = jsonencode({ value = local.ama_user_assigned_managed_identity_id })
        "ama_change_tracking_data_collection_rule_id" = jsonencode({ value = local.ama_change_tracking_data_collection_rule_id })
        "ama_mdfc_sql_data_collection_rule_id"        = jsonencode({ value = local.ama_mdfc_sql_data_collection_rule_id })
        "ama_vm_insights_data_collection_rule_id"     = jsonencode({ value = local.ama_vm_insights_data_collection_rule_id })
        "log_analytics_workspace_id"                  = jsonencode({ value = local.log_analytics_workspace_id })
      }

      subscription_placement = {
        "connectivity" = {
          "management_group_name" = "connectivity"
          "subscription_id"       = var.subscription_id_connectivity
        }
        "identity" = {
          "management_group_name" = "identity"
          "subscription_id"       = var.subscription_id_identity
        }
        "management" = {
          "management_group_name" = "management"
          "subscription_id"       = var.subscription_id_management
        }
      }
    }
    ```

1. Add locals.tf

    Create a locals.tf file. The locals are used in the main module calls to increase timeouts and retries for the pipeline.

    ```ruby
    locals {
      management_resource_group_name          = "rg-management-${var.location}"
      management_resource_group_id            = "/subscriptions/${var.subscription_id_management}/resourcegroups/${local.management_resource_group_name}"
      automation_account_name                 = "aa-management-${var.location}"
      log_analytics_workspace_name            = "law-management-${var.location}"
      ama_user_assigned_managed_identity_name = "uami-management-ama-${var.location}"
      dcr_change_tracking_name                = "dcr-change-tracking"
      dcr_defender_sql_name                   = "dcr-defender-sql"
      dcr_vm_insights_name                    = "dcr-vm-insights"

      ama_user_assigned_managed_identity_id       = "${local.management_resource_group_id}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${local.ama_user_assigned_managed_identity_name}"
      ama_change_tracking_data_collection_rule_id = "${local.management_resource_group_id}/providers/Microsoft.Insights/dataCollectionRules/${local.dcr_change_tracking_name}"
      ama_mdfc_sql_data_collection_rule_id        = "${local.management_resource_group_id}/providers/Microsoft.Insights/dataCollectionRules/${local.dcr_defender_sql_name}"
      ama_vm_insights_data_collection_rule_id     = "${local.management_resource_group_id}/providers/Microsoft.Insights/dataCollectionRules/${local.dcr_vm_insights_name}"
      log_analytics_workspace_id                  = "${local.management_resource_group_id}/providers/Microsoft.OperationalInsights/workspaces/${local.log_analytics_workspace_name}"

      default_retries = {
        management_groups = {
          error_message_regex = ["AuthorizationFailed", "Permission to Microsoft.Management/managementGroups on resources of type 'Write' is required on the management group or its ancestors."]
        }
        role_definitions = {
          error_message_regex = ["AuthorizationFailed"]
        }
        policy_definitions = {
          error_message_regex = ["AuthorizationFailed"]
        }
        policy_set_definitions = {
          error_message_regex = ["AuthorizationFailed"]
        }
        policy_assignments = {
          error_message_regex = ["AuthorizationFailed", "The policy definition specified in policy assignment '.+' is out of scope"]
        }
        policy_role_assignments = {
          error_message_regex = ["AuthorizationFailed", "ResourceNotFound", "RoleAssignmentNotFound"]
        }
        hierarchy_settings = {
          error_message_regex = ["AuthorizationFailed"]
        }
        subscription_placement = {
          error_message_regex = ["AuthorizationFailed"]
        }
      }

      default_timeouts = {
        management_group = {
          create = "60m"
          read   = "60m"
        }
        role_definition = {
          create = "60m"
          read   = "60m"
        }
        policy_assignment = {
          create = "60m"
          read   = "60m"
        }
        policy_definition = {
          create = "60m"
          read   = "60m"
        }
        policy_set_definition = {
          create = "60m"
          read   = "60m"
        }
        policy_role_assignment = {
          create = "60m"
          read   = "60m"
        }
      }
    }
    ```

## GitHub

1. Use Source Control (`CTRL`+`SHIFT`+`G`) to stage, commit, and then push up the changes to GitHub.
1. Open the repo on GitHub to create a pull request. This will trigger the Continuous Integration workflow.
1. Review the changes shown in the Terraform Plan step.
1. Approve the PR to merge it into the main branch.
1. The merge into the main branch will trigger the Continuous Deployment workflow.This will pause after the Plan stage.
1. Members of the alz-mgmt-approvers organization team can review and approve the plan.
1. The Apply stage will then run and create the resources.

## Custom library (optional)

Adding a custom library involves three steps.

- Add the custom library itself into the repo
- Update the alz provider block to point to the local library
- Update the architecture name in the alz module block

1. Add a local custom library

    Run  commands in vscode's Integrated Terminal to create a lib folder in your repo.

    ⚠️ Both PowerShell and Bash examples are shown. You only need to run one set.

    #### PowerShell

    ```powershell
    $repoFolder = Get-Location
    $tempFolderName = Join-Path $repoFolder 'temp'
    New-Item -ItemType "directory" $tempFolder
    $tempFolder = Resolve-Path -Path $tempFolder
    git clone -n --depth=1 --filter=tree:0 "https://github.com/Azure/alz-terraform-accelerator" "$tempFolder"
    cd $tempFolder
    $libFolderPath = "templates/platform_landing_zone/lib"
    git sparse-checkout set --no-cone $libFolderPath
    git checkout
    cd $repoFolder
    Copy-Item -Path "$tempFolder/$libFolderPath" -Destination $repoFolder -Recurse -Force
    Remove-Item -Path $tempFolder -Recurse -Force
    ```

    #### Bash

    ```shell
    repoFolder="$(pwd)"
    tempFolder="$repoFolder/temp"
    mkdir -p "$tempFolder"
    git clone -n --depth=1 --filter=tree:0 "https://github.com/Azure/alz-terraform-accelerator" "$tempFolder"
    cd "$tempFolder"
    libFolderPath="templates/platform_landing_zone/lib"
    git sparse-checkout set --no-cone "$libFolderPath"
    git checkout
    cd "$repoFolder"
    cp -r "$tempFolder/$libFolderPath" "$repoFolder"
    rm -rf "$tempFolder"
    ```

1. Update the alz provider block

    Update the library_references array in the alz provider block to point to the local library.

    ```ruby
    provider "alz" {
      library_overwrite_enabled = true
      library_references = [
        {
          custom_url = "${path.root}/lib"
        }
      ]
    }
    ```

    Note that the lib/alz_library_metadata.json file contains a dependency to the [platform/alz/2025.02.0](https://github.com/Azure/Azure-Landing-Zones-Library/releases/tag/platform%2Falz%2F2025.02.0) release in the main [Azure Landing Zone Library](https://aka.ms/alz/library) repo.

1. Update the module block

    The architecture name specified the management_groups module is "alz", as per the Microsoft library's architecture definition.

    The alz_custom.alz_architecture_definition.yaml file in lib/architecture_definitions provides a new architecture name: `name: alz_custom`.

    Update the architecture_name in the module to match.

    ```ruby
    module "management_groups" {
      # <https://registry.terraform.io/modules/Azure/avm-ptn-alz/azurerm/latest>
      source  = "Azure/avm-ptn-alz/azurerm"
      version = "0.12.3"

      architecture_name  = "alz_custom"
      location           = var.location
      parent_resource_id = data.azapi_client_config.current.tenant_id # Tenant root group
      retries            = local.default_retries
      timeouts           = local.default_timeouts

      # <snipped>
    }
    ```
### Next steps

Now that you have the custom library, you can refer to the docs to see how to customise.

- [Azure Landing Zones Library documentation](https://azure.github.io/Azure-Landing-Zones-Library)
- [Using a custom library](https://azure.github.io/Azure-Landing-Zones/terraform/howtos/customLibrary)
- [Azure Landing Zones Library](https://aka.ms/alz/library) for the examples in the platform folder
