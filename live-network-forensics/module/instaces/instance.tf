resource "google_compute_instance" "vm_instance" {
  name         = var.instance_name
  zone         = var.zone
  machine_type = var.instance_type

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }
  network_interface {
    subnetwork = var.instance_subnetwork
    access_config {
    }
  }

  metadata = var.metadata

}
