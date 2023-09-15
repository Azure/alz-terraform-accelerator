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

### GitHub


## Install the ALZ PowerShell module

1. In you PowerShell Core (pwsh) terminal type `Install-Module -Name ALZ`.
1. The module should download and install the latest version.

## Run the Bootstrap

Before running the 


