terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.39.0"
    }
  }
}

provider "google-beta" {
  project = var.project
  region  = var.region
  zone    = var.zone
}


# Create Service account with roles: Cloud Run Admin and Service Account User

resource "google_service_account" "cloud_run_sa" {
  project      = var.project
  account_id   = "cloud-run-service-account"
  display_name = "A service account allowed to deploy images on Cloud Run"
}

resource "google_project_iam_member" "run_admin" {
  project = var.project
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}

resource "google_project_iam_member" "service_account_user" {
  project = var.project
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}


resource "google_service_account_key" "cloud_run_sa_key" {
  service_account_id = google_service_account.cloud_run_sa.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

# Create service account with role: Log Writer, Artifact Registry Writer and Service Account User

resource "google_service_account" "cloud_build_sa" {
  project = var.project
  account_id = "cloud-build-service-account"
  display_name = "A service account allowed to create triggers on Cloud Build"
}

resource "google_project_iam_member" "act_as" {
  project = var.project
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.cloud_build_sa.email}"
}

resource "google_project_iam_member" "logs_writer" {
  project = var.project
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloud_build_sa.email}"
}

resource "google_project_iam_member" "artifact_registry_writer" {
  project = var.project
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.cloud_build_sa.email}"
}

# Create Artifact Registry for this project

resource "google_artifact_registry_repository" "sample_project_repository" {
    project = var.project
  location      = var.region
  repository_id = "sample-project-repository"
  description   = "Docker repository for Sample Project"
  format        = "DOCKER"
}