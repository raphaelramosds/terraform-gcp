locals {

  substitutions = {
    _CI_REPO                  = var.registry_repo_name
    _CI_REGION                = var.region
    _CI_SERVICE_ACCOUNT_EMAIL = var.service_account_email
  }

  triggers = {
    phpapi-dev = {
      service_name  = "phpapi"
      branch        = "dev"
      included_path = ["projects/php_api/**"]
      filename      = "projects/php_api/cloudbuild.yaml"
      substitutions = {}
    }
    phpapi-staging = {
      service_name  = "phpapi"
      branch        = "staging"
      included_path = ["projects/php_api/**"]
      filename      = "projects/php_api/cloudbuild.yaml"
      substitutions = {}
    }
    pythonapi-dev = {
      service_name  = "pythonapi"
      branch        = "dev"
      included_path = ["projects/python_api/**"]
      filename      = "projects/python_api/cloudbuild.yaml"
      substitutions = {}
    }
    pythonapi-staging = {
      service_name  = "pythonapi"
      branch        = "staging"
      included_path = ["projects/python_api/**"]
      filename      = "projects/python_api/cloudbuild.yaml"
      substitutions = {}
    }
  }
}
