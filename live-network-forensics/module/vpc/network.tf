#create network
resource "google_compute_network" "network_name" {
  name                    = var.network_name
  auto_create_subnetworks = var.auto_subnet
}

#create subnetwork, and flow logs
resource "google_compute_subnetwork" "subnetwork_name" {
  name          = var.subnetwork_name
  region        = var.region
  ip_cidr_range = var.ip_cidr_range
  network       = google_compute_network.network_name.self_link

  log_config {
    #flow lgos
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.9
    metadata             = "INCLUDE_ALL_METADATA"
    filter_expr          = "false"
  }

}

#Create firewall rules 
resource "google_compute_firewall" "firewall_rule_name" {
  name = var.firewall_rule_name

  #properties
  network = google_compute_network.network_name.self_link

  direction = var.direction
  source_ranges = var.source_ranges
  allow { 
    protocol = var.protocol
    ports = var.ports
  }
  #allow { 
  #protocol = var.protocol-icmp
#}
  log_config {
    metadata =  "INCLUDE_ALL_METADATA"
  }

}

#resource "google_compute_firewall" "firewall_rule_name" {
#  name = var.firewall_rule_name
#
#  #properties
#  network = google_compute_network.network_name.self_link
# 
#
#}
#
