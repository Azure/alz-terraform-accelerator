<!-- markdownlint-disable first-line-h1 -->
Having trouble using the module and unable to find a solution in the Wiki?

If it isn't listed below, let us know about it in our [Issues][Issues] log. We'll do our best to help and you may find your issue documented here.

## GitHub Actions Issues

### Action fails with `Invalid workflow file` error

If you see the following error when running a GitHub Action:

```text
Invalid workflow file: .github/workflows/ci.yaml#L10
The workflow is not valid. .github/workflows/ci.yaml (Line: 10, Col: 3): Error calling workflow 'my-org/alz-mgmt-templates/.github/workflows/ci_template.yaml@main'. The nested job 'plan' is requesting 'pull-requests: write, id-token: write', but is only allowed 'pull-requests: none, id-token: none'.
```

It means that your `Workflow permissions` settings are too restrictive. To fix this, go to your organization's `Settings` => `Actions` => `General` page. Then, under `Workflow permissions`, select `Read and write permissions` and click `Save`.

-> NOTE: This setting is only available to organization owners and admins. If your org is part of an enterprise, you may need to contact your enterprise admin to change this setting if it is greyed out for your org.

<!-- markdownlint-enable no-inline-html -->

[Issues]:     https://github.com/Azure/alz-terraform-accelerator/issues "Our issues log"
