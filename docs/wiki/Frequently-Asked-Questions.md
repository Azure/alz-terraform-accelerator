<!-- markdownlint-disable first-line-h1 -->
## Azure landing zones Terraform accelerator FAQ

This article answers frequently asked questions relating to the Azure landing zones Terraform accelerator.

> If you have a question not listed here, please raise an [issue](https://github.com/Azure/alz-terraform-accelerator/issues) and we'll do our best to help.

## Questions about customisation

### How do I use my own naming convention for the resources that are deployed?

Follow these steps to customise the resource names:

1. At step 2.2 of the quickstart, you will run the `New-ALZEnvironment` command to start the user input process.
1. Once the prompt appears for the first question open the relevant bootstrap `terraform.tfvars` file:
    1. Azure DevOps: `./v#.#.#/bootstrap/azuredevops/terraform.tfvars`
    1. GitHub: `./v#.#.#/bootstrap/github/terraform.tfvars`
1. Look for the variable called `resource_names`.
1. Update this map to have the names you desire and save it.
1. Continue with the user input as normal.

You'll now get the names you specified instead of the default ones.

## Questions about boostrap clean up

### I was just testing or I made a mistake, how do I remove the boostrap environment and start again?

After the Terraform apply has been completed there is an opportunity to remove the environment it just created. Follow these steps to run a `terraform destroy`.

1. Open a terminal and navigate to the relevant bootstrap folder:
    1. Azure DevOps: `cd ./v#.#.#/bootstrap/azuredevops`
    1. GitHub: `cd ./v#.#.#/bootstrap/github`
1. Run a this command `terraform destroy -var-file override.tfvars`.
1. Terraform will show a plan and prompt you to continue by typing `yes` and hitting enter.
1. Terraform will destroy all the resources it created in the boostrap.

You'll now be able to delete the `./v#.#.#` folder and run the `New-ALZEnvironment` command again.

## Questions about Multiple landing zone deployments

### I want to deploy multiple landing zones, but the PowerShell command keeps trying to overrwrite my existing environment

After bootstrapping, the PowerShell leaves the folder structure intact, including the Terraform state file. This is by design, so you have an opportunity to amend or destroy the environment.

If you want to deploy to a separate environment, the simplest approach is to specify a separate folder for each deployment using the `-Output` parameter. For example:

- Deployment 1: `New-ALZEnvironment -IaC "terraform" -Cicd "azuredevops" -Output "./deployment1"`
- Deployment 2: `New-ALZEnvironment -IaC "terraform" -Cicd "azuredevops" -Output "./deployment2"`

You can then deploy as many times as you like without interferring with a previous deployment.

## Questions about Automating the PowerShell Module

### I want to automate the PowerShell module, but it keeps prompting me for input, can I supply the answers?

Yes, you can supply the variables to the PowerShell module by using the `-inputs` parameter. You just need to supply a single file that includes the variables for the bootstrap and the starter module. The ordering of the variables in the file is not important.

The module will accept inputs as in json or yaml format. `.json,`, `.yaml` or `.yml` file extensions are supported. Examples of both are shown below.

To call the module, you then specify the `-inputs` parameter with the path to the file containing the inputs. For example:

```powershell
New-ALZEnvironment -IaC "terraform" -Cicd "azuredevops" -Inputs "~/config/inputs.json"
```

yaml example:
```yaml
starter_module: "basic"
azure_location: "uksouth"
```

json example:
```json
{
  "starter_module": "basic",
  "azure_location": "uksouth"
}
```

> NOTE: These examples show a partial set of variables. In this scenario, the module will prompt for the remaining variables. You can find the full list of variables in the quick start phase 2 and starter module documentation.

Full yaml example for Azure DevOps with the hub networking starter module:

```yaml
# Bootstrap Variables
starter_module: "basic"
azure_location: "uksouth"
version_control_system_access_token: "**************************************"
version_control_system_organization: "alz-demo"
azure_location": "uksouth"
azure_subscription_id: "12345678-1234-1234-1234-123456789012"
service_name: "alz"
environment_name: "mgmt"
postfix_number: "1"
# repository_visibility: "public" # GitHub Only
azure_devops_use_organisation_legacy_url: "false" # Azure DevOps Only
azure_devops_create_project: "true" # Azure DevOps Only
azure_devops_project_name: "alz-demo" # Azure DevOps Only
azure_devops_authentication_scheme: "WorkloadIdentityFederation" # Azure DevOps Only
apply_approvers: "a.person@example.com,b.person@example.com"
root_management_group_display_name: "Tenant Root Group"
additional_files: ""

# Starter Module Specific Variables
default_location: "uksouth"
subscription_id_connectivity: "22345678-1234-1234-1234-123456789012"
subscription_id_identity: "32345678-1234-1234-1234-123456789012"
subscription_id_management: "42345678-1234-1234-1234-123456789012"
root_id: "es"
root_name: "Enterprise-Scale"
hub_virtual_network_address_prefix: "10.0.0.0/16"
firewall_subnet_address_prefix: "10.0.0.0/24"
gateway_subnet_address_prefix: "10.0.1.0/24"
virtual_network_gateway_creation_enabled: "true"
```

### I get prompted to approve the Terraform plan, can I skip that?

Yes, you can skip the approval of the Terraform plan by using the `-autoApprove` parameter.

For example:

```powershell
New-ALZEnvironment -IaC "terraform" -Cicd "azuredevops" -Inputs "~/config/inputs.json" -autoApprove
```

## Questions about adding more subscriptions post initial deployment

### I used a single subscription for the initial deployment, how do I split my landing zone to the recommended 3 subscriptions?

There are some steps you need to take:

1. Create a new subscription and take a note of the subscriptions ID.
1. Find the names of the user assigned managed identities that were created in the initial boostrap. There should be one for `plan` and one for `apply`.
1. Go to the `Access control (IAM)` section pf the subscription. Add the following permissions for each user assigned managed identity:
    1. `Reader` to the `plan` identity
    1. `Owner` to the `apply` identity
1. Go to your Terraform code in source control and update the `terraform.tfvars` file, specifying the new subscription id in the relevant variable. You will need to create a branch and raise a PR to do this.
1. You can now plan and apply from pipelines to update the subscriptions.

## Questions about using custom starter modules

### I want to use my own custom starter modules, how do I do that?

First you'll need to create a folder structure to hold your custom starter modules. The folder structure should follow this pattern:

```text
📦my-custom-starter-modules #1
 ┣ 📂my-ci-cd #2
 ┃ ┣ 📂azuredevops #3
 ┃ ┃ ┣ 📜cd.yaml
 ┃ ┃ ┣ 📜ci.yaml
 ┃ ┃ ┗ 📂templates #4
 ┃ ┃   ┣ 📜apply.yaml
 ┃ ┃   ┣ 📜cd.yaml
 ┃ ┃   ┣ 📜ci.yaml
 ┃ ┃   ┗ 📜plan.yaml
 ┃ ┗ 📂github
 ┃   ┣ 📜cd.yaml
 ┃   ┣ 📜ci.yaml
 ┃   ┗ 📂templates
 ┃     ┣ 📜cd.yaml
 ┃     ┗ 📜ci.yaml
 ┣ 📂my-starter-module-1 #5
 ┃ ┣ 📜main.tf
 ┃ ┣ 📜outputs.tf
 ┃ ┣ 📜providers.tf
 ┃ ┣ 📜README.md
 ┃ ┣ 📜terraform.tfvars
 ┃ ┗ 📜variables.tf #6
 ┗ 📂my-starter-module-2
   ┣ 📜data.tf
   ┣ 📜main.tf
   ┣ 📜variables.tf
   ┗ 📜versions.tf
```

Notes on the folder structure:

1. This is the enclosing folder path as specified in the `module_folder_path` variable (see below).
2. This is the CI / CD actions / pipelines folder path as specified in `pipeline_folder_path` variable (see below). This folder can be outside the module folder if desired.
3. You only need to supply one of either `azuredevops` or `github` folder if you are only using one VCS system. The folder and file names can't be altered at present.
4. This is the templates folder used for the cd, cd, plan and apply templates.
5. This is an example starter module folder. This will also the name of the starter module as supplied to the `starter_module` input.
6. Variables must be stored in a file called `variables.tf`. If you need validation, etc, please follow our examples. These variables are translated into inputs to the PowerShell module.

Next, you'll need to override the starter template folder location in the PowerShell module. To do that, create yaml or json file that provides values for the `module_folder_path` and the `pipeline_folder_path` variables. For example:

```yaml
module_folder_path: "C:/my-config/my-custom-starter-modules" # This is the folder you created in the last step
module_folder_path_relative: false # You must specifiy this as false if you are using a custom starter module folder
pipeline_folder_path: "C:/my-config/my-custom-starter-modules/my_ci_cd" # This is the pipeline folder you created in the last step (NOTE: This does not need to be nested under the module folder, it could be in a separate location)
pipeline_folder_path_relative: false # You must specifiy this as false if you are using a custom pipeline module folder
```

```json
{
  "module_folder_path": "~/my-config/my-custom-starter-modules",
  "module_folder_path_relative": false,
  "pipeline_folder_path": "~/my-config/my-custom-starter-modules/my_ci_cd",
  "pipeline_folder_path_relative": false
}
```

Then, when you call the PowerShell module, specify the `-inputs` parameter with the path to the file containing the inputs. For example:

```powershell
New-ALZEnvironment -IaC "terraform" -Cicd "azuredevops" -Inputs "~/config/inputs.yaml"
```

Now when the PowerShell runs it will accept the name of your customer starter module in the `starter_module` variable. e.g. `my-starter-module-1`.
