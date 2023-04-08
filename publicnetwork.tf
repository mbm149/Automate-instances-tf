#create network
resource "google_compute_network" "tf-network" {
  name                    = "tf-network"
  auto_create_subnetworks = "false"
}

#create subnetwork with flow logs enable interval of # , sampling #, metadata, no filter
resource "google_compute_subnetwork" "tf-subnetwork-us" {
  name             = "tf-subnetwok-us"
  region           = "us-central1"
  network          = google_compute_network.tf-network.self_link
  ip_cidr_range    = "10.120.0.0/20"
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
resource "google_compute_firewall" "tf-network-ssh-icmp" {
  name = "tf-network-ssh-icmp"
  #properties
  network = google_compute_network.tf-network.self_link
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  allow {
    protocol = "icmp"
  }
  source_ranges = ["0.0.0.0/0"]
}

module "tf-instance1-public" {
  source           = "./instances"
  instance_name    = "tf-instance1-public"
  instance_subnetwork = google_compute_subnetwork.tf-subnetwork-us.self_link
}
