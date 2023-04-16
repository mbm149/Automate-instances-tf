#create network
resource "google_compute_network" "tf-network-private" {
  name                    = "tf-network-private"
  auto_create_subnetworks = "false"
}

#create subnetwork with flow logs enable interval of # , sampling #, metadata, no filter
resource "google_compute_subnetwork" "tf-subnetwork-private" {
  name             = "tf-subnetwok-private"
  region           = "us-central1"
  network          = google_compute_network.tf-network-private.self_link
  ip_cidr_range    = "172.16.0.0/24"
  #enable_flow_logs = true
  log_config {
    #flow logs
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling = 0.9
    metadata = "INCLUDE_ALL_METADATA"
    filter_expr = "false"
  }
}



#firewall rule allow ssh, icmp traffic on the network
resource "google_compute_firewall" "tf-network-private-ssh-icmp-p" {
  name = "tf-network-ssh-icmp"
  #properties
  network = google_compute_network.tf-network-private.self_link
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  allow {
    protocol = "icmp"
  }
  source_ranges = ["0.0.0.0/0"]
}

module "tf-instance1-private" {
  source           = "./instances"
  instance_name    = "tf-instance1-private"
  instance_subnetwork = google_compute_subnetwork.tf-subnetwork-private.self_link
}

module "vm-snapshot-locations-us123" {
  source            = "./storage"
  storage-uniquename = "vm-snapshot-locations-us123"
}


