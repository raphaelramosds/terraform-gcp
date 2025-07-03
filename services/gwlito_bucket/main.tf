provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Cloud Storage Bucket
#
# Bucket where Gwlito Web, a Laravel 7.x application, will replicate local uploaded files

resource "google_storage_bucket" "gwlito_bucket" {
  name          = "gwlito-bucket"
  location      = "US"
  force_destroy = true
  project       = var.project_id

  public_access_prevention = "enforced"
}