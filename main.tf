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

resource "google_service_account" "cloud_run_sa" {
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

variable "project" {
  description = "Project name"
  default     = "sample-project-460722"
}

variable "region" {
  description = "Region name"
  default = "us-central1"
}

variable "zone" {
  description = "Zone name"
  default = "us-central1-a"
}