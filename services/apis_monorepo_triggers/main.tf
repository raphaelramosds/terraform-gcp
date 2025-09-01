provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_cloudbuild_trigger" "phpapi_trigger_dev" {
  name = "phpapi-dev"
  project  = var.project_id
  location = "us-central1"
  service_account = "projects/${var.project_id}/serviceAccounts/${var.service_account_email}"

  included_files = [
    "projects/php_api/**"
  ]

  repository_event_config {
    repository = "projects/general-project-464820/locations/us-central1/connections/geowellex/repositories/raphaelgeowellex-apis-monorepo"
    push {
      branch = "dev"
    }
  }

  substitutions = {
    _CI_IMAGE                 = "phpapi"
    _CI_SERVICE_NAME          = "phpapi"
    _CI_REGION                = var.region
    _CI_SERVICE_ACCOUNT_EMAIL = var.service_account_email
  }

  filename = "projects/php_api/cloudbuild.yaml"
}

resource "google_cloudbuild_trigger" "phpapi_trigger_staging" {
  name = "phpapi-staging"
  project  = var.project_id
  location = "us-central1"
  service_account = "projects/${var.project_id}/serviceAccounts/${var.service_account_email}"

  included_files = [
    "projects/php_api/**"
  ]

  repository_event_config {
    repository = "projects/general-project-464820/locations/us-central1/connections/geowellex/repositories/raphaelgeowellex-apis-monorepo"
    push {
      branch = "staging"
    }
  }

  substitutions = {
    _CI_IMAGE                 = "phpapi"
    _CI_SERVICE_NAME          = "phpapi"
    _CI_REGION                = var.region
    _CI_SERVICE_ACCOUNT_EMAIL = var.service_account_email
  }

  filename = "projects/php_api/cloudbuild.yaml"
}

resource "google_cloudbuild_trigger" "pythonapi_trigger_dev" {
  name = "pythonapi-dev"
  project  = var.project_id
  location = "us-central1"
  service_account = "projects/${var.project_id}/serviceAccounts/${var.service_account_email}"

  included_files = [
    "projects/python_api/**"
  ]

  repository_event_config {
    repository = "projects/general-project-464820/locations/us-central1/connections/geowellex/repositories/raphaelgeowellex-apis-monorepo"
    push {
      branch = "dev"
    }
  }

  substitutions = {
    _CI_IMAGE                 = "pythonapi"
    _CI_SERVICE_NAME          = "pythonapi"
    _CI_REGION                = var.region
    _CI_SERVICE_ACCOUNT_EMAIL = var.service_account_email
  }

  filename = "projects/python_api/cloudbuild.yaml"
}

resource "google_cloudbuild_trigger" "pythonapi_trigger_staging" {
  name = "pythonapi-staging"
  project  = var.project_id
  location = "us-central1"
  service_account = "projects/${var.project_id}/serviceAccounts/${var.service_account_email}"

  included_files = [
    "projects/python_api/**"
  ]

  repository_event_config {
    repository = "projects/general-project-464820/locations/us-central1/connections/geowellex/repositories/raphaelgeowellex-apis-monorepo"
    push {
      branch = "staging"
    }
  }

  substitutions = {
    _CI_IMAGE                 = "pythonapi"
    _CI_SERVICE_NAME          = "pythonapi"
    _CI_REGION                = var.region
    _CI_SERVICE_ACCOUNT_EMAIL = var.service_account_email
  }

  filename = "projects/python_api/cloudbuild.yaml"
}