variable "project_id" {
  description = "Project name"
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