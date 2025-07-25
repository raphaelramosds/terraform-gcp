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

variable "instance" {
  description = "Database instance name"
  type        = string
  default     = "services-db"
}

variable "services_db_secret_data" {
  default = "Services DB secret data"
  type    = string
}