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

    # SecretManager resource containing the webhook secret of a GitLab Enterprise project with the following event triggers: 
    # "Merge request events", "Comments", "Push events", "Tag push events", "SSL Verification: enabled".
    # Create it on on Gitlab > Projects > Settings > Webhooks
    #
    # NOTE: Each project MUST have its own webhook! So you MUST create a connection resource to each Gitlab project
    #
    # Format: 'projects/*/secrets/*/versions/*'.
    webhook_secret_secret_version = ""

    read_authorizer_credential {
      # A SecretManager resource containing the user token that authorizes the Cloud Build connection.
      # Create it on on itlab > Settings > Access Tokens
      #
      # Format: 'projects/*/secrets/*/versions/*'.
      user_token_secret_version = ""
    }

    authorizer_credential {
      # A GitLab personal access token with the 'api' scope access
      # Create it on on itlab > Settings > Access Tokens
      #
      # Format: 'projects/*/secrets/*/versions/*'.
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
