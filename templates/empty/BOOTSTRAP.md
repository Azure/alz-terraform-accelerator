# Bootstrap

Here are example bootstrap steps for Terraform and GitHub using the recommended defaults. Reference the [ALZ Accelerator documentation](https://aka.ms/alz/accelerator/docs) for more detail or for alternative approaches.


## Prereqs

1. Binaries

    You will need at least the specified version of

    - [PowerShell](https://learn.microsoft.com/powershell/scripting/install/installing-powershell) (7.4)
    - [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) (2.55.0)
    - [Git](https://git-scm.com/downloads)

    It is also assumed that you are using [Visual Studio Code](https://aka.ms/vscode) with the [Hashicorp Terraform](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform) extension.

1. ALZ PowerShell modules

   ```powershell
   Install-Module -Name ALZ
   ```

   Use `Update-Module ALZ` to update.

1. Authorisation

    Elevate in Entra ID's tenant properties, then assign yourself as Owner at tenant root group.

    ```shell

    az role assignment create --assignee "$(az ad signed-in-user show --query id -otsv)" --role "Owner" --scope "/providers/Microsoft.Management/managementGroups/$(az account show --query tenantId -otsv)"
    ```

    You may remove the RBAC role assignment once the accelerator has run.

1. Subscriptions

    The setup assumes that you have three subscriptions that will be assigned to the platform landing zone area.

    - management
    - connectivity
    - identity

1. GitHub ID and Organization

    You will need both a GitHub ID and an organization. The ALZ accelerator does not work in a user context.

1. Create personal access tokens for the accelerator and private runners

    Create the two [personal access tokens](https://github.com/settings/tokens). Save the generated token for each.

    1. __Azure Landing Zone Terraform Accelerator__

        - repo
        - workflow
        - admin:org
        - user : read:user
        - user : read:email
        - delete_repo

        Short expiry, e.g. tomorrow.

    1. Azure Landing Zone Private Runners

        - repo
        - admin:org (for Enterprise organization only)

        Permanent.

## Bootstrap step

1. Create a working area

    ```powershell
    New-Item -ItemType "file" "$env:HOME/accelerator/config/inputs.yaml" -Force
    New-Item -ItemType "directory" "$env:HOME/accelerator/output"
    ```

1. Edit inputs.yaml

    Example file:

    ```yaml
    ---
    # For detailed instructions on using this file, visit:
    # https://aka.ms/alz/accelerator/docs

    # Basic Inputs
    iac_type: "terraform"
    bootstrap_module_name: "alz_github"
    starter_module_name: "none"

    # Shared Interface Inputs
    bootstrap_location: "change_me"                     # E.g. "uksouth"
    subscription_ids:
      management: "change_me"
      identity: "change_me"
      connectivity: "change_me"
      security: "change_me"

    # Bootstrap Inputs
    github_personal_access_token: "change_me"           # PAT for Terraform accelerator
    github_runners_personal_access_token: "change_me"   # PAT for private runners
    github_organization_name: "change_me"
    use_separate_repository_for_templates: true
    bootstrap_subscription_id: "change_me"              # Management subscription ID
    service_name: "alz"
    environment_name: "mgmt"
    postfix_number: 1
    use_self_hosted_runners: true
    use_private_networking: true
    allow_storage_access_from_my_ip: false
    apply_approvers: ["change_me"]                      # GitHub ID
    create_branch_policies: true

    # Advanced Inputs
    bootstrap_module_version: "latest"
    starter_module_version: "latest"
    output_folder_path: "~/accelerator/output"
    ```

1. Deploy the bootstrap

    ```powershell
    Set-Location -Path $env:HOME/accelerator/output
    Deploy-Accelerator -inputs "$env:HOME/accelerator/config/inputs.yaml"
    ```

    This will create two repos in your GitHub org:

    - alz-mgmt
    - alz-mgmt-templates

    In Azure there will be new role definitions and assignments for the managed identities, plus these resource groups in the bootstrap subscription ID:

    - rg-alz-mgmt-agents-uksouth-001
    - rg-alz-mgmt-identity-uksouth-001
    - rg-alz-mgmt-network-uksouth-001
    - rg-alz-mgmt-state-uksouth-001

If you navigate to the main repo then you will see there are environments, branch protection rules, environment and repository variables, a team for approvals, and the config files. GitHub Actions will show the plan and apply workflows.

It is ready for cloning and configuring.


## Links

- <https://aka.ms/alz/accelerator/docs>