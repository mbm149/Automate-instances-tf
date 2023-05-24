resource "google_storage_bucket" "foresic_bucket" {
  name     = var.name
  location = var.locations
  #storage_class = var.storage_class
  project                     = var.project_id
  force_destroy               = var.force_destroy
  uniform_bucket_level_access = var.level_access
  public_access_prevention    = var.blocke_public_access
}

