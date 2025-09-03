provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

locals {
  triggers = {
    phpapi-dev = {
      service_name  = "phpapi"
      branch        = "dev"
      included_path = ["projects/php_api/**"]
      filename      = "projects/php_api/cloudbuild.yaml"
    }
    phpapi-staging = {
      service_name  = "phpapi"
      branch        = "staging"
      included_path = ["projects/php_api/**"]
      filename      = "projects/php_api/cloudbuild.yaml"
    }
    pythonapi-dev = {
      service_name  = "pythonapi"
      branch        = "dev"
      included_path = ["projects/python_api/**"]
      filename      = "projects/python_api/cloudbuild.yaml"
    }
    pythonapi-staging = {
      service_name  = "pythonapi"
      branch        = "staging"
      included_path = ["projects/python_api/**"]
      filename      = "projects/python_api/cloudbuild.yaml"
    }
  }
}

resource "google_cloudbuild_trigger" "api_triggers" {
  for_each = local.triggers

  name            = each.key
  project         = var.project_id
  location        = var.region
  service_account = "projects/${var.project_id}/serviceAccounts/${var.service_account_email}"

  included_files = each.value.included_path

  repository_event_config {
    repository = "projects/${var.project_id}/locations/${var.region}/connections/geowellex/repositories/raphaelgeowellex-apis-monorepo"
    push {
      branch = each.value.branch
    }
  }

  substitutions = {
    _CI_REPO                  = var.registry_repo_name
    _CI_SERVICE_NAME          = each.value.service_name
    _CI_REGION                = var.region
    _CI_SERVICE_ACCOUNT_EMAIL = var.service_account_email
  }

  filename = each.value.filename
}
