terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.13.0"
    }
  }
}
provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

data "google_project" "project" {
  project_id = var.project_id
}

data "google_sql_database_instance" "main_instance" {
  name    = google_sql_database_instance.main.name
  project = var.project_id
}

data "google_secret_manager_secret_version_access" "basic" {
  secret = google_secret_manager_secret.service_db_secret.secret_id
  project = var.project_id
}

resource "google_secret_manager_secret" "service_db_secret" {
  secret_id = "services-db"
  project   = var.project_id
  labels = {
    creator   = "raphael"
    mantainer = "raphael"
  }
  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

# Create first version for the secret above
resource "google_secret_manager_secret_version" "secret_version_basic" {
  secret      = google_secret_manager_secret.service_db_secret.id
  secret_data = var.services_db_secret_data
}

resource "google_sql_database_instance" "main" {
  name             = var.instance
  database_version = "POSTGRES_15"
  region           = var.region
  root_password    = data.google_secret_manager_secret_version_access.basic.secret_data
  project          = var.project_id

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_database" "database" {
  project         = var.project_id
  name            = "flowdpp"
  instance        = data.google_sql_database_instance.main_instance.name
  deletion_policy = "ABANDON"
}