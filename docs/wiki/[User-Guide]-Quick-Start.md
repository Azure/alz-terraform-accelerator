<!-- markdownlint-disable first-line-h1 -->
## Introduction

The quick start guide takes you through the steps to prepare your pre-requisites and then run the PowerShell module.

## Tools

You'll need to install the following tools before getting started.

- PowerShell Core: [Follow the instructions for your operating system](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell)
- Terraform CLI: [Follow the instructions for your operating system](https://developer.hashicorp.com/terraform/downloads)
- Azure CLI: [Follow the instructions for your operating system](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- Git: [Follow the instructions for your operating system](https://git-scm.com/downloads)

[!NOTE]
In all cases, ensure that the tools are available from a PowerShell core (pwsh) terminal. You may need to add them to your environment path if they are not.

## Azure Subscriptions

We recommend setting up 3 subscriptions for Azure landing zones. These are management, identity and networking. You can read more about this in the [Landing Zone docs](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/deploy-landing-zones-with-terraform).

To create the subscriptions you will need access to a billing agreement. The following links detail the permissions required for each type of agreement:

- [Enterprise Agreement (EA)](https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/create-enterprise-subscription)
- [Microsoft Customer Agreement (MCA)](https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/create-subscription)

Once you have the access required, create three subscriptions following your desired naming convention with the following purposes:

- management
- identity
- networking

Take note of the subscription id of each subscription as we'll need them later.

## Azure Credentials

You need an Azure User or Service Principal with the following permissions to run the bootstrap:

- `Management Group Contributor` on you root management groups (usually called `Tenant Root Group`)
- `Owner` on your Azure landing zone subscriptions

For simplicity we recommend using a User account since this is a one off proceess that you are unlikely to repeat.

### Azure Permissions

It is likely that if you were able to create the subscriptions you already have the level of access required for a user account, however you should follow these steps to validate them.

If your preference is to run the bootstrap in the context of a Service Principal, follow these steps to create one:

#### Create Service Principal (Skip this if using a User account)

1. Navigate to the [Azure Portal](https://portal.azure.com) and sign in to your tenant.
1. Search for `Azure Active Directory` and open it.
1. Copy the `Tenant ID` field and save it somewhere safe, making a note it is the `ARM_TENANT_ID`.
1. Click `App registrations` in the left navigation.
1. Click `+ New registration`.
1. Choose a name (SPN) that you will remember and make a note of it, we recommend using `sp-alz-boostrap`.
1. Type the chosen name into the `Name` field.
1. Leave the other settings as default and click `Register`.
1. Wait for it to be created.
1. Copy the `Application (client) ID` field and save it somewhere safe, making a note it is the `ARM_CLIENT_ID`.
1. Click `Certificates & secrets` in the left navigation.
1. Ensure the `Client secrets` tab is selected and click `+ New client secret`.
1. Enter `ALZ Bootstrap` in the `Description` field.
1. Change the `Expires` field, choose `Custom`.
1. Set the `Start` field to todays date.
1. Set the `End` field to tomorrows date.
1. Click `Add`.
1. Copy the `Value` field save it somewhere safe, making a note that it is the `ARM_CLIENT_SECRET`.

#### Create Permissions

1. The service principal name (SPN) is the username of the User account or the name of the app registration you c reated.
1. Search for `Subscriptions` and click to navigate to the subscription view.
1. For each of the subscriptions you created in the previous step:
    1. Navigate to the subscription.
    1. Click `Access control (IAM)` in the left navigation.
    1. Click `+ Add` and choose `Add role assignment`.
    1. Choose the `Priviledged administrator roles` tab.
    1. Click `Owner` to highlight the row and then click `Next`.
    1. Leave the `User, group or service principal` option checked.
    1. Click `+ Select Members` and search for your SPN in the search box on the right.
    1. Click on your User to highlight it and then click `Select`.
    1. Click `Review + assign`, then click `Review + assign` again when the warning appears.
    1. Wait for the role to be assinged and move onto the next subscription.
1. Search for `Management Groups` and click to navigate to the management groups view.
1. Click the `Tenant Root Group` management group (Note, it is possible someone changed the name of your root management group, select the one at the very top of the hierarchy if that is the case)
1. Click `Access control (IAM)` in the left navigation.
1. Click `+ Add` and choose `Add role assignment`.
1. Remain on the `Job function roles` tab.
1. Search for `Management Group Contributor` and click the row to highlight that role.
1. Click `Next`.
1. Leave the `User, group or service principal` option checked.
1. Click `+ Select Members` and search for your SPN in the search box on the right.
1. Click on your User to highlight it and then click `Select`.
1. Click `Review + assign`, then click `Review + assign` again when the warning appears.
1. Wait for the role to be assinged and you are done with this part.

## Login / Set Credentials

Follow these steps to login as a User or user Service Princiapl credentials:

### User Login

1. Open a new PowerShell Core (pwsh) terminal.
1. Run `az login`.
1. You'll be redirected to a browser to login, perform MFA, etc.
1. Find the subscription id of the management subscription you made a note of earlier.
1. Type `az account set --subscription "<subscription id of your management subscription>"` and hit enter.
1. Type `az account show` and verify that you are connected to the management subscription.

### Service Principal Credentials

1. Open a new PowerShell Core (pwsh) terminal.
1. Find the `ARM_TENANT_ID` you made a note of earlier.
1. Type `$env:ARM_TENANT_ID="<tenant id>"` and hit enter.
1. Find the `ARM_CLIENT_ID` you made a note of earlier.
1. Type `$env:ARM_CLIENT_ID="<client id>"` and hit enter.
1. Find the `ARM_CLIENT_SECRET` you made a note of earlier.
1. Type `$env:ARM_CLIENT_SECRET="<client id>"` and hit enter.
1. Find the subscription id of the manangement subscription you made a note of earlier.
1. Type `$env:ARM_SUBSCRIPTION_ID="<subscription id>"` and hit enter.

[!NOTE]
If you close your PowerShell prompt prior to running the bootstrap, you need to re-enter these environment variables.

## Version Control System Personal Access Token (PAT)

You'll need to decide whether you are using GitHub or Azure DevOps and follow the instructions below to generate a PAT:

### Azure DevOps

1. Navigate to [dev.azure.com](https://dev.azure.com) and sign in to your organization.
1. Ensure you navigate to the organization you want to deploy to.
1. Click the `User settings` icon in the top right and select `Personal access tokens`.
1. Click `+ New Token`.
1. Enter `Azure Landing Zone Terraform Accelerator` in the `Name` field.
1. Alter the `Expiration` drop down and select `Custom defined`.
1. Choose tommorrows date in the date picker.
1. Click the `Show all scopes` link at the bottom.
1. Check the following scopes:
    1. `Agent Pools`: `Read & manage`
    1. `Build`: `Read & execute`
    1. `Code`: `Full`
    1. `Environment`: `Read & manage`
    1. `Graph`: `Read & manage`
    1. `Pipeline Resources`: `Use & manage`
    1. `Project and Team`: `Read, write & manage`
    1. `Service Connections`: `Read, write & manage`
    1. `Variable Groups`: `Read, create & manage`
1. Click `Create`.
1. Copy the token and save it somewhere safe.
1. Click `Close`.

### GitHub

1. Navigate to [github.com](https://github.com).
1. Click on your user icon in the top right and select `Settings`.
1. Scroll down and click on `Developer Settings` in the left navigation.
1. Click `Personal access tokens` in the left navigation and select `Tokens (classic)`.
1. Click `Generate new token` at the top and select `Generate new token (classic)`.
1. Enter `Azure Landing Zone Terraform Accelerator` in the `Note` field.
1. Alter the `Expiration` drop down and select `Custom`.
1. Choose tommorrows date in the date picker.
1. Check the following scopes:
    1. `repo`
    1. `workflow`
    1. `admin:org`: `write:org`
    1. `user`: `read:user`
    1. `user`: `user:email`
    1. `delete_repo`
1. Click `Generate token`.
1. Copy the token and save it somewhere safe.
1. If your organization uses single sign on, then click the `Configure SSO` link next to your new PAT.
1. Select your organization and click `Authorize`, then follow the prompts to allow SSO.

## Install the ALZ PowerShell module

1. In your PowerShell Core (pwsh) terminal type `Install-Module -Name ALZ`.
1. The module should download and install the latest version.

## Run the Bootstrap

You are now ready to run the boostrap and setup your environment. The inputs differ depending on the VCS you have chosen:

### Azure DevOps

1. In your PowerShell Core (pwsh) terminal type `New-ALZEnvironment -IaC "terraform" -Cicd "azuredevops"`.
1. The module will download the latest accelerator and then prompt you for inputs.
1. Fill out the following inputs:
    1. `starter_module`: This is the choice of [Starter Module](), which is the baseline configuration you want for your Azure landing zone. This also determine the second set of input you'll be prompted for here.
    1. `version_control_system_access_token`: Enter the Azure DevOps PAT you generated in a previous step.
    1. `version_control_system_organization`: Enter the name of your Azure DevOps organization.
    1. `azure_location`: Enter the Azure region where you would like to deploy the storage account and identity for your continuous delivery pipeline. This field expects the `name` of the region, such as `uksouth`. You can find a full list of names by running `az account list-locations -o table`.
    1. `service_name`: This is used to build up the names of your Azure and Azure DevOps resources, for example `rg-<service_name>-mgmt-uksouth-001`. We recommend using `alz` for this.
    1. `environment_name`: This is used to build up the names of your Azure and Azure DevOps resources, for example `rg-alz-<environment_name>-uksouth-001`. We recommend using `mgmt` for this.
    1. `postfix_number`: This is used to build up the names of your Azure and Azure DevOps resources, for example `rg-alz-mgmt-uksouth-<postfix_number>`. We recommend using `1` for this.
    1. `azure_devops_use_organisation_legacy_url`: If you have not migrated to the modern url (still using `https://<organization_name>.visualstudio.com`) for your Azure DevOps organisation, then set this to `true`.
    1. `azure_devops_create_project`: If you have an existing project you want to use rather than creating a new one, select `true`. We recommend creating a new project to ensure it is isolated by a strong security boundary.
    1. `azure_devops_project_name`: Enter the name of the Azure DevOps project to create or the name of an existing poroject if you set `azure_devops_create_project` to `false`.
    1. `azure_devops_authentication_scheme`: Enter the authentication scheme that your pipeline will use to authenticate to Azure. [WorkloadIdentityFederation](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/connect-to-azure?view=azure-devops#create-an-azure-resource-manager-service-connection-using-workload-identity-federation) uses OpenId Connect and is the recommended approach. [ManagedServiceIdentity](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/connect-to-azure?view=azure-devops#create-an-azure-resource-manager-service-connection-to-a-vm-with-a-managed-service-identity) requires the deployment of self-shoted agents are part of the bootstrap setup.
    1. `apply_approvers`: This is a list of service principal names (SPN) of people you wish to be in the group that approves apply of the Azure landing zone module. This is a comma-separated list like `abc@xyz.com,def@xyz.com,ghi@xyz.com`. You may need to check what the SPN is prior to filling this out as it can vary based on identity provider.
    1. `root_management_group_display_name`: The is the name of the root management group that you applied permissions to in a previous step. This defaults to `Tenant Root Group`, but if you organization has changed it you'll need to enter the new display name.
1. You will now see a green message telling you that the next section is specigic to the starter module you choose. Navigate to the documentation for the relevant starter module to get details of the specific inputs.
1. Once you have entered the starter module input, you see that a Terraform `init` and `apply` happen.
1. There will be a pause after the `plan` phase you allow you to validate what is going to be deployed.
1. If you are happy with the plan, then type `yes` and hit enter.
1. The Terraform will `apply` and your environment will be bootstrapped.

### GitHub

1. In your PowerShell Core (pwsh) terminal type `New-ALZEnvironment -IaC "terraform" -Cicd "azuredevops"`.
1. The module will download the latest accelerator and then prompt you for inputs.
1. Fill out the following inputs:
    1. `starter_module`: This is the choice of [Starter Module](), which is the baseline configuration you want for your Azure landing zone. This also determine the second set of input you'll be prompted for here.
    1. `version_control_system_access_token`: Enter the GitHub PAT you generated in a previous step.
    1. `version_control_system_organization`: Enter the name of your GitHub organization.
    1. `azure_location`: Enter the Azure region where you would like to deploy the storage account and identity for your continuous delivery pipeline. This field expects the `name` of the region, such as `uksouth`. You can find a full list of names by running `az account list-locations -o table`.
    1. `service_name`: This is used to build up the names of your Azure and GitHub resources, for example `rg-<service_name>-mgmt-uksouth-001`. We recommend using `alz` for this.
    1. `environment_name`: This is used to build up the names of your Azure and GitHub resources, for example `rg-alz-<environment_name>-uksouth-001`. We recommend using `mgmt` for this.
    1. `postfix_number`: This is used to build up the names of your Azure and GitHub resources, for example `rg-alz-mgmt-uksouth-<postfix_number>`. We recommend using `1` for this.
    1. `apply_approvers`: This is a list of service principal names (SPN) of people you wish to be in the group that approves apply of the Azure landing zone module. This is a comma-separated list like `abc@xyz.com,def@xyz.com,ghi@xyz.com`. You may need to check what the SPN is prior to filling this out as it can vary based on identity provider.
    1. `repository_visibility`: This determines whether the repository is `public` or `private`. We recommend you choose `private`, but if you are testing and don't have a licensed GitHub organization, you will need to choose `public` or the boostrapping will fail due to missing functionality.
    1. `root_management_group_display_name`: The is the name of the root management group that you applied permissions to in a previous step. This defaults to `Tenant Root Group`, but if you organization has changed it you'll need to enter the new display name.
1. You will now see a green message telling you that the next section is specigic to the starter module you choose. Navigate to the documentation for the relevant starter module to get details of the specific inputs.
1. Once you have entered the starter module input, you see that a Terraform `init` and `apply` happen.
1. There will be a pause after the `plan` phase you allow you to validate what is going to be deployed.
1. If you are happy with the plan, then type `yes` and hit enter.
1. The Terraform will `apply` and your environment will be bootstrapped.

## Deploy the Landing Zone

Now you have created your boostrapped environment you can deploy you Azure landing zone by triggering the continuous delivery pipeline in your version control system.

### Azure DevOps

1. Navigate to [dev.azure.com](https://dev.azure.com) and sign in to your organization.
1. Navigate to your project.
1. Click `Pipelines` in the left navigation.
1. Click the `Azure Landing Zone Continuous Delivery` pipeline.
1. Click `Run pipeline` in the top right.
1. Take the defaults and click `Run`.
1. Your pipeline will run a `plan`.
1. If you provided `apply_approvers` to the bootstrap, it will prompt you to approve the `apply` stage.
1. Your pipeline will run an `apply` and deploy an Azure landing zone based on the starter module you choose.

### GitHub

1. Navigate to [github.com](https://github.com).
1. Navigate to your repository.
1. Click `Actions` in the top navigation.
1. Click the `Azure Landing Zone Continuous Delivery` pipeline in the left navigation.
1. Click `Run workflow` in the top right, then keep the default branch and click `Run workflow`.
1. Your pipeline will run a `plan`.
1. If you provided `apply_approvers` to the bootstrap, it will prompt you to approve the `apply` job.
1. Your pipeline will run an `apply` and deploy an Azure landing zone based on the starter module you choose.