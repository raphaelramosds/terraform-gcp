# Secrets definitions
resource "google_secret_manager_regional_secret" "webhook_secret" {
  project   = var.project_id
  secret_id = "${var.project_id}-cloudbuild-gitlab-apismonorepo-webhook-token"
  location  = var.region
}

resource "google_secret_manager_regional_secret" "pat_secret" {
  project   = var.project_id
  secret_id = "${var.project_id}-cloudbuild-gitlab-apismonorepo-pat"
  location  = var.region
}

# Secrets versions
resource "google_secret_manager_regional_secret_version" "webhook_secret_version" {
  secret          = google_secret_manager_regional_secret.webhook_secret.id
  secret_data     = var.webhook_token
  deletion_policy = "DISABLED"
}

resource "google_secret_manager_regional_secret_version" "pat_secret_version" {
  secret          = google_secret_manager_regional_secret.pat_secret.id
  secret_data     = var.gitlab_pat
  deletion_policy = "DISABLED"
}
