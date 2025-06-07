variable "project_id" {
  description = "ID of the Google Cloud project"
  type        = string
  default     = ""
}

variable "region" {
  description = "Google Cloud region to deploy the resources (e.g., us-central1)"
  type        = string
  default     = ""
}

variable "registry_repo_name" {
  description = "Name of the Artifact Registry repository used to store container images"
  type        = string
  default     = ""
}

variable "service_account_id" {
  description = "ID (not email) of the service account used by Cloud Build and Cloud Run"
  type        = string
  default     = ""
}

variable "service_account_email" {
  description = "Email of the service account used by Cloud Build and Cloud Run"
  type        = string
  default     = ""
}

variable "zone" {
  description = "Google Cloud zone (e.g., us-central1-a)"
  type        = string
  default     = ""
}

variable "service_name" {
  description = "Name of the Cloud Run service to be deployed"
  type        = string
  default     = "streamlit-app"
}

variable "cloudbuild_path" {
  description = "Relative path to the cloudbuild.yaml file in the GitHub repository"
  type        = string
  default     = "streamlit/cloudbuild.yaml"
}