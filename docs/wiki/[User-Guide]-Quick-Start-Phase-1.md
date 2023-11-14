<!-- markdownlint-disable first-line-h1 -->
Phase 1 of the accelerator is to setup your pre-requisites. Follow the steps below to do that.

## 1.1 Tools

You'll need to install the following tools before getting started.

- PowerShell Core: [Follow the instructions for your operating system](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell)
- Terraform CLI: [Follow the instructions for your operating system](https://developer.hashicorp.com/terraform/downloads)
- Azure CLI: [Follow the instructions for your operating system](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- Git: [Follow the instructions for your operating system](https://git-scm.com/downloads)

[!NOTE]
In all cases, ensure that the tools are available from a PowerShell core (pwsh) terminal. You may need to add them to your environment path if they are not.

## 1.2 Azure Subscriptions

We recommend setting up 3 subscriptions for Azure landing zones. These are management, identity and networking. You can read more about this in the [Landing Zone docs](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/deploy-landing-zones-with-terraform).

To create the subscriptions you will need access to a billing agreement. The following links detail the permissions required for each type of agreement:

- [Enterprise Agreement (EA)](https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/create-enterprise-subscription)
- [Microsoft Customer Agreement (MCA)](https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/create-subscription)

Once you have the access required, create three subscriptions following your desired naming convention with the following purposes:

- management
- identity
- networking

Take note of the subscription id of each subscription as we'll need them later.

## 1.3 Azure Authentication and Permissions

You need either an Azure User Account or Service Principal with the following permissions to run the bootstrap:

- `Management Group Contributor` on you root management groups (usually called `Tenant Root Group`)
- `Owner` on your Azure landing zone subscriptions

For simplicity we recommend using a User account since this is a one off process that you are unlikely to repeat.

### 1.3.1 Authenticate via User Account

1. Open a new PowerShell Core (pwsh) terminal.
1. Run `az login`.
1. You'll be redirected to a browser to login, perform MFA, etc.
1. Find the subscription id of the management subscription you made a note of earlier.
1. Type `az account set --subscription "<subscription id of your management subscription>"` and hit enter.
1. Type `az account show` and verify that you are connected to the management subscription.

### 1.3.2 Authenticate via Service Principal (Skip this if using a User account)

#### 1.3.2.1 Create Service Principal

1. Navigate to the [Azure Portal](https://portal.azure.com) and sign in to your tenant.
1. Search for `Azure Active Directory` and open it.
1. Copy the `Tenant ID` field and save it somewhere safe, making a note it is the `ARM_TENANT_ID`.
1. Click `App registrations` in the left navigation.
1. Click `+ New registration`.
1. Choose a name (SPN) that you will remember and make a note of it, we recommend using `sp-alz-bootstrap`.
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

#### 1.3.2.2 Create Permissions

1. The service principal name (SPN) is the username of the User account or the name of the app registration you created.
1. Search for `Subscriptions` and click to navigate to the subscription view.
1. For each of the subscriptions you created in the previous step:
    1. Navigate to the subscription.
    1. Click `Access control (IAM)` in the left navigation.
    1. Click `+ Add` and choose `Add role assignment`.
    1. Choose the `Privileged administrator roles` tab.
    1. Click `Owner` to highlight the row and then click `Next`.
    1. Leave the `User, group or service principal` option checked.
    1. Click `+ Select Members` and search for your SPN in the search box on the right.
    1. Click on your User to highlight it and then click `Select`.
    1. Click `Review + assign`, then click `Review + assign` again when the warning appears.
    1. Wait for the role to be assigned and move onto the next subscription.
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
1. Wait for the role to be assigned and you are done with this part.

#### 1.3.2.3 Set Service Principal Credentials in Terminal

1. Open a new PowerShell Core (pwsh) terminal.
1. Find the `ARM_TENANT_ID` you made a note of earlier.
1. Type `$env:ARM_TENANT_ID="<tenant id>"` and hit enter.
1. Find the `ARM_CLIENT_ID` you made a note of earlier.
1. Type `$env:ARM_CLIENT_ID="<client id>"` and hit enter.
1. Find the `ARM_CLIENT_SECRET` you made a note of earlier.
1. Type `$env:ARM_CLIENT_SECRET="<client id>"` and hit enter.
1. Find the subscription id of the management subscription you made a note of earlier.
1. Type `$env:ARM_SUBSCRIPTION_ID="<subscription id>"` and hit enter.

[!NOTE]
If you close your PowerShell prompt prior to running the bootstrap, you need to re-enter these environment variables.

## 1.4 Version Control System Personal Access Token (PAT)

You'll need to decide whether you are using GitHub or Azure DevOps and follow the instructions below to generate a PAT:

### 1.4.1 Azure DevOps

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
    1. `admin:org`: `write:org`
    1. `user`: `read:user`
    1. `user`: `user:email`
    1. `delete_repo`
1. Click `Generate token`.
1. Copy the token and save it somewhere safe.
1. If your organization uses single sign on, then click the `Configure SSO` link next to your new PAT.
1. Select your organization and click `Authorize`, then follow the prompts to allow SSO.

## Next Steps

Now head to [Phase 2.](%5BUser-Guide%5D-Quick-Start-Phase-2.md)
