provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

data "google_project" "project" {
  project_id = var.project_id
}

resource "google_secret_manager_regional_secret_iam_member" "pat_secret_access" {
  project   = var.project_id
  location  = var.region
  secret_id = google_secret_manager_regional_secret.pat_secret.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"
}

resource "google_secret_manager_regional_secret_iam_member" "webhook_secret_access" {
  project   = var.project_id
  location  = var.region
  secret_id = google_secret_manager_regional_secret.webhook_secret.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"
}

resource "google_cloudbuildv2_connection" "connection" {
  name     = "geowellex-gitlab"
  location = var.region
  project  = var.project_id

  gitlab_config {
    webhook_secret_secret_version = google_secret_manager_regional_secret_version.webhook_secret_version.id

    read_authorizer_credential {
      user_token_secret_version = google_secret_manager_regional_secret_version.pat_secret_version.id
    }

    authorizer_credential {
      user_token_secret_version = google_secret_manager_regional_secret_version.pat_secret_version.id
    }
  }

  depends_on = [
    google_secret_manager_regional_secret_iam_member.pat_secret_access,
    google_secret_manager_regional_secret_iam_member.webhook_secret_access
  ]
}

resource "google_cloudbuildv2_repository" "repo" {
  project           = var.project_id
  name              = "apis-monorepo"
  remote_uri        = "https://gitlab.com/raphaelgeowellex/apis-monorepo.git"
  parent_connection = google_cloudbuildv2_connection.connection.id
}

resource "google_cloudbuild_trigger" "api_triggers" {
  for_each = local.triggers

  name            = each.key
  project         = var.project_id
  location        = var.region
  service_account = "projects/${var.project_id}/serviceAccounts/${var.service_account_email}"
  included_files  = each.value.included_path

  repository_event_config {
    repository = google_cloudbuildv2_repository.repo.id
    push {
      branch = each.value.branch
    }
  }

  substitutions = merge(local.substitutions, each.value.substitutions)
  filename      = each.value.filename
}
