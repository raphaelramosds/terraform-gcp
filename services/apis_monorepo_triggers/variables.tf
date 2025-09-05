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

variable "zone" {
  description = "Google Cloud zone (e.g., us-central1-a)"
  type        = string
  default     = ""
}

variable "service_account_email" {
  description = "Email of the service account used by Cloud Build and Cloud Run"
  type        = string
  default     = ""
}

variable "registry_repo_name" {
  description = "Repository name on Artifact Registry"
  type        = string
}

variable "webhook_token" {
  description = <<EOT
  Webhook secret of a Gitlab Enterprise with SSL Verification enabled and the following event triggers:
  
  "Merge request events", "Comments", "Push events", "Tag push events"

  NOTE: Each project MUST have its own webhook! So you MUST create a connection resource to each Gitlab project
  EOT
  type        = string
}

variable "gitlab_pat" {
  description = "A GitLab personal access token with the 'api' scope access"
  type        = string
}
