resource "google_compute_instance_group" "forensic_group" {
  name        = var.name
  description = ""
  zone        = var.zone
  network    =  var.network_name
}

