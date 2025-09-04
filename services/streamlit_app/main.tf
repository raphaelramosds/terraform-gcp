provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_cloudbuild_trigger" "cloudbuild_trigger" {
  
  # Cloud Build Trigger
  #
  # Automatically builds and deploys the Docker image to Cloud Run 
  # whenever there is a new push to the `main` branch of the specified GitHub repository.
  #
  # The build configuration is defined in the `streamlit/cloudbuild.yaml` file.
  # Substitutions provide contextual variables to be used within the build process.
  #
  # Important:
  # - The GitHub repository must be connected manually via the GCP Console:
  #   Cloud Build → Triggers → Connect Repository
  # - Manual approval is not required before each build is executed.

  name            = "${var.service_name}-ci-trigger"
  project         = var.project_id
  location        = var.region
  service_account = var.service_account_id
  filename        = var.cloudbuild_path
  substitutions = {
    _CI_SERVICE_NAME           = var.service_name
    _CI_IMAGE                  = "${var.region}-docker.pkg.dev/${var.project_id}/${var.registry_repo_name}/${var.service_name}"
    _CI_PROJECT_ID             = var.project_id
    _CI_REGION                 = var.region
    _CI_SERVICE_ACCOUNT_EMAIL = var.service_account_email
  }
  github {
    owner = "raphaelramosds"
    name  = "dca3501-project"
    push {
      branch = "main"
    }
  }
  approval_config {
    approval_required = false
  }
}
