variable "region-us" { default = "us-central1"}
variable "zone-us-a" { default = "us-central1-a"}
variable "project_id" { default = "project-381019"}
variable "instance_type" {
  default = "e2-micro"
}
variable "instance_name" {}
variable "instance_subnetwork" {}

resource "google_compute_instance" "vm_instance"{
    name =  var.instance_name
    zone =  var.zone-us-a
    machine_type = var.instance_type
    boot_disk {
        initialize_params {
            image = "debian-cloud/debian-11"
        }
    }
    network_interface { 
        subnetwork = var.instance_subnetwork
        access_config{  
        }
    }
}
