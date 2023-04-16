variable "storage-uniquename" {}
variable "location-us" { default = "US"}
variable "blocke-public-access" { default = "enforced"}
variable "level-access" { default = true}
variable "destroy" { default = true }

resource "google_storage_bucket" "storage-bucket-us" {
  name     = var.storage-uniquename
  location = var.location-us
  #deleting a bucket, this boolean option will delete all contained objects.
  force_destroy = true
  #Enable uniform bucket-level access to the bucket
  uniform_bucket_level_access = var.level-access
  #Prevent public access to a bucket
  public_access_prevention = var.blocke-public-access

}


