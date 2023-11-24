resource "github_actions_repository_oidc_subject_claim_customization_template" "alz" {
  repository         = github_repository.alz.name
  use_default        = false
  include_claim_keys = ["repository", "environment", "job_workflow_ref"]
}
