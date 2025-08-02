provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_storage_bucket" "mysql_dumps_bucket" {
  name          = "mysql-dumps-bucket"
  location      = "US"
  force_destroy = true
  project       = var.project_id

  public_access_prevention = "enforced"
}