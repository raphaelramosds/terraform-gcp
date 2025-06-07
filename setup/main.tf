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
    "artifactregistry.googleapis.com"
  ])
  service = each.key
}

# Create a common Service account for all applications on this project
resource "google_service_account" "sa" {
  project      = var.project_id
  account_id   = "projects-service-account"
  display_name = "A common service account to projects on this monorepo"
}

resource "google_project_iam_member" "permissions" {
  project = var.project_id
  member = "serviceAccount:${google_service_account.cloud_run_sa.email}"
  role = each.value
  for_each = toset([
    "roles/run.admin",
    "roles/iam.serviceAccountUser",
    "roles/logging.logWrite",
    "roles/artifactregistry.writer"
  ])
}

# Create Artifact Registry for this project
resource "google_artifact_registry_repository" "project_repository" {
  project       = var.project_id
  location      = var.region
  repository_id = "${var.project_id}-repository"
  description   = "Docker repository for ${var.project_id}"
  format        = "DOCKER"
}

output "service_account" {
  value = google_service_account.sa.account_id
}

output "artifact_registry" {
    value = google_artifact_registry_repository.project_repository.name
}