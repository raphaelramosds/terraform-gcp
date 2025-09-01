provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Enable Google Cloud services
resource "google_project_service" "enable_services" {
  project = var.project_id
  for_each = toset([
    "run.googleapis.com",
    "cloudbuild.googleapis.com",
    "artifactregistry.googleapis.com",
    "secretmanager.googleapis.com",
    "developerconnect.googleapis.com"
  ])
  service = each.key
}

# Create a common Service account for all applications on this project and attach permissions on it
resource "google_service_account" "service_account" {
  project      = var.project_id
  account_id   = "projects-service-account"
  display_name = "A common service account to projects on this monorepo"
  depends_on = [
    google_project_service.enable_services
  ]
}

resource "google_project_iam_member" "permissions" {
  project = var.project_id
  member  = "serviceAccount:${google_service_account.service_account.email}"
  role    = each.value
  for_each = toset([
    "roles/run.admin",
    "roles/iam.serviceAccountUser",
    "roles/artifactregistry.writer",
    "roles/logging.logWriter",
    "roles/cloudsql.client",
    "roles/secretmanager.admin",
    "roles/secretmanager.secretAccessor",

  ])
  depends_on = [
    google_project_service.enable_services,
    google_service_account.service_account
  ]
}

# Create Artifact Registry for this project
resource "google_artifact_registry_repository" "project_repo" {
  project       = var.project_id
  location      = var.region
  repository_id = "${var.project_id}-repository"
  description   = "Docker repository for ${var.project_id}"
  format        = "DOCKER"
  depends_on = [
    google_project_service.enable_services
  ]
}

# Publish this service account key as JSON
resource "google_service_account_key" "publisher_key" {
  service_account_id = google_service_account.service_account.id
  private_key_type   = "TYPE_GOOGLE_CREDENTIALS_FILE"

}

output "service_account_key" {
  value     = google_service_account_key.publisher_key.private_key
  sensitive = true
}

output "service_account_email" {
  value = google_service_account.service_account.email
}

output "service_account_id" {
  value = google_service_account.service_account.id
}

output "registry_repo_name" {
  value = google_artifact_registry_repository.project_repo.name
}
