resource "google_storage_bucket" "static-site" {
  name     = "vm-snapshot-locations"
  location = "US"
  #deleting a bucket, this boolean option will delete all contained objects.
  force_destroy = true
  #Enable uniform bucket-level access to the bucket
  uniform_bucket_level_access = true
  #Prevent public access to a bucket
  public_access_prevention = "enforced"

}
