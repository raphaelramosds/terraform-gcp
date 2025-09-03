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

variable "registry_repo_name" {
  description = "Repository name on Artifact Registry"
  type = string
}
