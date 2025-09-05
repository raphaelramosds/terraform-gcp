# Grant Cloud Build service account access to GitLab PAT and webhook secrets
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