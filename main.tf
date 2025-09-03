terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.39.0"
    }
  }
  backend "gcs" {
    bucket = "storage-terraform-gcp"
    prefix = "terraform/state"
  }
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Setup common resources
module "setup" {
  source     = "./setup"
  project_id = var.project_id
  region     = var.region
  zone       = var.zone
}

# Services
# module "streamlit_app" {
#   source                = "./services/streamlit_app"
#   project_id            = var.project_id
#   region                = var.region
#   service_account_email = module.setup.service_account_email
#   service_account_id    = module.setup.service_account_id
#   registry_repo_name    = module.setup.registry_repo_name
# }

# module "gwlito_bucket" {
#   source     = "./services/gwlito_bucket"
#   project_id = var.project_id
#   region     = var.region
#   zone       = var.zone
# }

module "mysql_dumps_bucket" {
  source     = "./services/mysql_dumps_bucket"
  project_id = var.project_id
  region     = var.region
  zone       = var.zone
}


module "my_personal_bucket" {
  source     = "./services/my_personal_bucket"
  project_id = var.project_id
  region     = var.region
  zone       = var.zone
}

# module "services_db" {
#   source                  = "./services/services_db"
#   project_id              = var.project_id
#   region                  = var.region
#   zone                    = var.zone
#   services_db_secret_data = var.service_db_secret_data
# }

module "apis_monorepo_triggers" {
  source                = "./services/apis_monorepo_triggers"
  project_id            = var.project_id
  region                = var.region
  zone                  = var.zone
  service_account_email = module.setup.service_account_email
  registry_repo_name    = module.setup.registry_repo_name
}

# Variables
variable "project_id" {
  description = "Project name"
  type        = string
  default     = ""
}

variable "region" {
  description = "Region name"
  type        = string
  default     = ""
}

variable "zone" {
  description = "Zone name"
  type        = string
  default     = ""
}

variable "service_db_secret_data" {
  description = "Services DB secret data"
  type        = string
}

output "service_account_key" {
  value     = module.setup.service_account_key
  sensitive = true
}
