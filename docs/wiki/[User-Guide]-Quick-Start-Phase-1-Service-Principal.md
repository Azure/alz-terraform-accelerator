<!-- markdownlint-disable first-line-h1 -->
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
1. Choose the `Privileged administrator roles` tab.
1. Click `Owner` to highlight the row and then click `Next`.
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
1. Find the subscription id of the bootstrap subscription you made a note of earlier.
1. Type `$env:ARM_SUBSCRIPTION_ID="<subscription id>"` and hit enter.

[!NOTE]
If you close your PowerShell prompt prior to running the bootstrap, you need to re-enter these environment variables.

## Next Steps

Return to [Phase 1][wiki_quick_start_phase_1] step 1.4.

 [//]: # (************************)
 [//]: # (INSERT LINK LABELS BELOW)
 [//]: # (************************)

[wiki_quick_start_phase_1]:           %5BUser-Guide%5D-Quick-Start-Phase-1 "Wiki - Quick Start - Phase 1"
