terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.39.0"
    }
  }
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Setup common resources for all services
module "setup" {
  source     = "./setup"
  project_id = var.project_id
  region     = var.region
  zone       = var.zone
}

# Services
module "streamlit_app" {
  source             = "./services/streamlit_app"
  project_id         = var.project_id
  region             = var.region
  service_account_id = module.setup.service_account_id
  registry_repo_name = module.setup.registry_repo_name
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
