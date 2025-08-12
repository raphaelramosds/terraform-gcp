provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_storage_bucket" "my_personal_bucket" {
  name          = "storage-my-personal-bucket"
  location      = "US"
  force_destroy = false
  project       = var.project_id

  public_access_prevention = "enforced"
}