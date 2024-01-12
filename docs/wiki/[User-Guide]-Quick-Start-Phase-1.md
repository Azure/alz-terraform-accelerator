<!-- markdownlint-disable first-line-h1 -->
Phase 1 of the accelerator is to setup your pre-requisites. Follow the steps below to do that.

## 1.1 Tools

You'll need to install the following tools before getting started.

- PowerShell 7.4 (or newer): [Follow the instructions for your operating system](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell)
- Azure CLI 2.55.0 (or newer): [Follow the instructions for your operating system](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)

> NOTE: In all cases, ensure that the tools are available from a PowerShell core (pwsh) terminal. You may need to add them to your environment path if they are not.

## 1.2 Azure Subscriptions

We recommend setting up 3 subscriptions for Azure landing zones. These are management, identity and networking. See our [advanced scenarios][wiki_advanced_scenarios] section for alternatives.

- Management: This is used to deploy the bootstrap and management resources, such as log analytics and automation accounts.
- Identity: This is used to deploy the identity resources, such as Azure AD and Azure AD Domain Services.
- Networking: This is used to deploy the networking resources, such as virtual networks and firewalls.

You can read more about the management, identity and networking subscriptions in the [Landing Zone docs](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/deploy-landing-zones-with-terraform).

To create the subscriptions you will need access to a billing agreement. The following links detail the permissions required for each type of agreement:

- [Enterprise Agreement (EA)](https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/create-enterprise-subscription)
- [Microsoft Customer Agreement (MCA)](https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/create-subscription)

Once you have the access required, create the three subscriptions following your desired naming convention.

Take note of the subscription id of each subscription as we will need them later.

## 1.3 Azure Authentication and Permissions

You need either an Azure User Account or Service Principal with the following permissions to run the bootstrap:

- `Owner` on you root management groups (usually called `Tenant Root Group`)
  - Owner is required as this account will be granting permissions for the identities that run the management group deployment. Those identities will be granted least privilege permissions.
- `Owner` on each of your 3 Azure landing zone subscriptions.

For simplicity we recommend using a User account since this is a one off process that you are unlikely to repeat.

### 1.3.1 Authenticate via User Account

1. Open a new PowerShell Core (pwsh) terminal.
1. Run `az login`.
1. You'll be redirected to a browser to login, perform MFA, etc.
1. Find the subscription id of the management subscription you made a note of earlier.
1. Type `az account set --subscription "<subscription id of your management subscription>"` and hit enter.
1. Type `az account show` and verify that you are connected to the management subscription.

### 1.3.2 Authenticate via Service Principal (Skip this if using a User account)

Follow the instructions in the [Service Principal][wiki_quick_start_phase_1_service_principal] section.

## 1.4 Version Control Systems

You'll need to decide if you are using GitHub, Azure DevOps or the Local File System and follow these steps:

### 1.4.1 Azure DevOps

#### 1.4.1.1 Azure DevOps Pre-Requisites

When you first create an Azure DevOps organization, it will not have any Microsoft hosted agents available. You must either license your org or request a free pipeline.

1. Setup billing with your MCAPS External Subscription: [Set up billing for your organization](https://learn.microsoft.com/en-us/azure/devops/organizations/billing/set-up-billing-for-your-organization-vs?view=azure-devops)
2. Check for and request a free pipeline via the form here: [Configure and pay for parallel jobs](https://learn.microsoft.com/en-us/azure/devops/pipelines/licensing/concurrent-jobs?view=azure-devops&tabs=ms-hosted#how-much-do-parallel-jobs-cost)

#### 1.4.1.2 Azure DevOps Personal Access Token (PAT)

1. Navigate to [dev.azure.com](https://dev.azure.com) and sign in to your organization.
1. Ensure you navigate to the organization you want to deploy to.
1. Click the `User settings` icon in the top right and select `Personal access tokens`.
1. Click `+ New Token`.
1. Enter `Azure Landing Zone Terraform Accelerator` in the `Name` field.
1. Alter the `Expiration` drop down and select `Custom defined`.
1. Choose tomorrows date in the date picker.
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

### 1.4.2 GitHub

#### 1.4.2.1 GitHub Pre-Requisites

The accelerator does not support GitHub personal accounts, since they don't support all the features required for security. You must have a GitHub organization account or the accelerator will fail on apply. You can create a free organization [here](https://github.com/organizations/plan). Learn more about account types [here](https://docs.github.com/en/get-started/learning-about-github/types-of-github-accounts).

> NOTE: If you choose to use a `free` organization account the accelerator bootstrap will make your repositories public. It must do this to support the functionality required by the accelerator. This is not recommended for production environments.

#### 1.4.2.2 GitHub Personal Access Token (PAT)

1. Navigate to [github.com](https://github.com).
1. Click on your user icon in the top right and select `Settings`.
1. Scroll down and click on `Developer Settings` in the left navigation.
1. Click `Personal access tokens` in the left navigation and select `Tokens (classic)`.
1. Click `Generate new token` at the top and select `Generate new token (classic)`.
1. Enter `Azure Landing Zone Terraform Accelerator` in the `Note` field.
1. Alter the `Expiration` drop down and select `Custom`.
1. Choose tomorrows date in the date picker.
1. Check the following scopes:
    1. `repo`
    1. `workflow`
    1. `admin:org`
    1. `user`: `read:user`
    1. `user`: `user:email`
    1. `delete_repo`
1. Click `Generate token`.
1. Copy the token and save it somewhere safe.
1. If your organization uses single sign on, then click the `Configure SSO` link next to your new PAT.
1. Select your organization and click `Authorize`, then follow the prompts to allow SSO.

### 1.4.3 Local File System

You just need to ensure that you have a folder on your local file system that you can use to store the files, which your current session has access to.

## Next Steps

Now head to [Phase 2][wiki_quick_start_phase_2].

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[wiki_quick_start_phase_2]:           %5BUser-Guide%5D-Quick-Start-Phase-2 "Wiki - Quick Start - Phase 2"
[wiki_quick_start_phase_1_service_principal]:           %5BUser-Guide%5D-Quick-Start-Phase-1-Service-Principal "Wiki - Quick Start - Phase 1 - Service Principal"
[wiki_advanced_scenarios]:             %5BUser-Guide%5D-Advanced-Scenarios "Wiki - Advanced Scenarios"
