<!-- markdownlint-disable first-line-h1 -->
Having trouble using the module and unable to find a solution in the Wiki?

If it isn't listed below, let us know about it in our [Issues][Issues] log. We'll do our best to help and you may find your issue documented here.

## PowerShell ALZ Module Failing for non-obvious reasons

For example, when running `Deploy-Accelerator` you may see an error like:

- `Parameter cannot be processed because the parameter name 'i' is ambiguous. Possible matches include: -InformationAction -InformationVariable -alzIacProvider -userInputOverridePath.`

This is most likely because you are not using the most recent release of the PowerShell module. Update the module and try again. If that doesn't work, follow on below.

We have noted that some users have issues when they install the module in PowerShell 5.X instead of PowerShell 7.X. When you install a module in PowerShell 5.X (PS) it appears to override any modules installed with PowerShell 7.X (pwsh). In this scenario you need to uninstall the module from PS in order to be able to install it in pwsh.

Follow these steps to ensure you have a working environment:

1. Update the latest PowerShell Core / 7.X (pwsh) version.
2. Open a PS (PowerShell 5.1) terminal. You may need to be an administrator to do this.
3. Run `Uninstall-Module -Name ALZ`, then run `Get-InstalledModule -Name ALZ`
4. If the previous command shows a version of the module is still installed, then repeat the previous step until you no longer see an installed version.
5. Open a pwsh (PowerShell 7.X) terminal.
6. Run `Uninstall-Module -Name ALZ`, then run `Get-InstalledModule -Name ALZ`
7. If the previous command shows a version of the module is still installed, then repeat the previous step until you no longer see an installed version.
8. Run `Install-Module -Name ALZ`

You should now be able to successfully run the `Deploy-Accelerator` command and continue.

## 422 Error when deleting Runner Group

When trying to destroy a GitHub environment with a runner group you may see an error like:

`Error: DELETE https://api.github.com/orgs/<org>/actions/runner-groups/3: 422 This group cannot be deleted because it contains runners. Please remove or move them to another group before proceeding. []`

Unfortunately, this requires manual intervantion at the moment. The runners do not delete themselves when the container instance is delete, so they will show in the offline state for 14 days prior to being deleted.

To resolve this, you can manually delete the runners from Runner Group in the GitHub UI. You can then re-run the destroy to complete the clean up.

This only affects you if you have Enterprise licensing and have chosen to use a Runner Group. More details can be found here: https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/removing-self-hosted-runners

<!-- markdownlint-enable no-inline-html -->

[Issues]:     https://github.com/Azure/alz-terraform-accelerator/issues "Our issues log"
