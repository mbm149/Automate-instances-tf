#Create firewall rules 
resource "google_compute_firewall" "firewall_rule_name" {
  name = var.firewall_rule_name

  #properties
  network = var.network_name # google_compute_network.network_name.self_link

  direction = var.direction
  source_ranges = var.source_ranges
#  allow { 
#    protocol = var.protocol
#    ports = var.ports
#  }

    allow { 
    protocol = "icmp"
   }
  
  log_config {
    metadata =  "INCLUDE_ALL_METADATA"
  }

}
