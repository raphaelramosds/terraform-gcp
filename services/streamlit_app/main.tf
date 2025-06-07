provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Bind IAM policy to "public_invoker" for allowing anyone on internet access a Cloud Run service
data "google_iam_policy" "public_invoker" {
  binding {
    role    = "roles/run.invoker"
    members = ["allUsers"]
  }
}

# Sets an IAM policy on the Cloud Run service to allow external users (unauthenticated) to access it
resource "google_cloud_run_service_iam_policy" "public-access" {
  project     = var.project_id
  service     = google_cloud_run_service.streamlit-app.name
  location    = google_cloud_run_service.streamlit-app.location
  policy_data = data.google_iam_policy.public_invoker.policy_data
}

# Set a Cloud Build trigger to build the Dockerfile of a Github project when there is a new push on the branch main
resource "google_cloudbuild_trigger" "streamlit-app-build" {
  name            = "streamlit-app-build"
  project         = var.project_id
  location        = var.region
  service_account = "projects/${var.project_id}/serviceAccounts/cloud-build-service-account@sample-project-460722.iam.gserviceaccount.com"
  filename        = "streamlit/cloudbuild.yaml"

  github {
    owner = "raphaelramosds"
    name  = "dca3501-project" # NOTE: one MUST connect this repo on GCP console at Cloud Build / Triggers / Connect repository
    push {
      branch = "main"
    }
  }

  # Manually approve/reject this trigger on console
  approval_config {
    approval_required = true
  }

  depends_on = [google_project_service.enable_services]
}

# Deploys a containerized Streamlit app to Cloud Run using an image stored in Artifact Registry
resource "google_cloud_run_service" "streamlit-app" {
  project  = var.project_id
  name     = "streamlit-app"
  location = var.region

  template {
    spec {
      containers {
        image = "us-central1-docker.pkg.dev/sample-project-460722/sample-project-repository/streamlit-app"
        ports {
          container_port = 8501
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [google_project_service.enable_services]
}