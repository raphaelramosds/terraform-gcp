provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_cloudbuildv2_connection" "connection" {
  name     = "geowellex-gitlab"
  location = var.region
  project  = var.project_id
  gitlab_config {
    host_uri = "gitlab.com"
    # SecretManager resource containing the webhook secret of a GitLab Enterprise project, formatted as 'projects//secrets//versions/*'
    # (created on Gitlab > Settings > Access Tokens)
    webhook_secret_secret_version = ""
    read_authorizer_credential {
      # A SecretManager resource containing the user token that authorizes the Cloud Build connection. Format: 'projects/*/secrets/*/versions/*'.
      # (created on Gitlab > Settings > Access Tokens)
      user_token_secret_version = ""
    }
    authorizer_credential {
      # A GitLab personal access token with the 'api' scope access
      # (created on Gitlab > Settings > Webhooks)
      user_token_secret_version = ""
    }
  }
}

resource "google_cloudbuild_trigger" "api_triggers" {
  for_each = local.triggers

  name            = each.key
  project         = var.project_id
  location        = var.region
  service_account = "projects/${var.project_id}/serviceAccounts/${var.service_account_email}"
  included_files  = each.value.included_path

  repository_event_config {
    repository = "projects/${var.project_id}/locations/${var.region}/connections/geowellex/repositories/raphaelgeowellex-apis-monorepo"
    push {
      branch = each.value.branch
    }
  }

  substitutions = merge(local.substitutions, each.value.substitutions)
  filename      = each.value.filename
}
