resource "google_compute_backend_service" "backend_service" {
    name = var.backend_service_name
    
   #backend {
   #   #group = module.groupinstances.google_compute_instance_group.forensic_group.id
   #   group  =  var.forensic_group
   #}

    health_checks = [ google_compute_health_check.health_check.id ]

    #protocol = "TCP"
    #timeout_sec = 10
}

resource "google_compute_health_check" "health_check" {
  name = "health-check"
  check_interval_sec = 1
  timeout_sec        = 1
  tcp_health_check {
    port = "80"
  }
}


resource "google_compute_forwarding_rule" "forwarding_rule" {
  depends_on = [ var.subnetwork_name]
  region                = "us-central1"
  name   = var.forwarding-rule
  is_mirroring_collector = true
  ip_protocol = "TCP"
  load_balancing_scheme = "INTERNAL"
  backend_service        = google_compute_backend_service.backend_service.self_link
  all_ports              = true
  network                = var.network_name
  subnetwork             = var.subnetwork_name
  network_tier           = "PREMIUM"

}

resource "google_compute_packet_mirroring" "packet_mirroring" {
    
    name =  var.packet-mirroring

    network { 
        url = var.network_name 
    }
    
    collector_ilb { 
        url = google_compute_forwarding_rule.forwarding_rule.id
    } 
   # mirrored_instance = google_compute_instance.instance.self_link
    
    mirrored_resources { 
        instances {  
            url = var.mirrored_instance 
        }
    } 
    
    filter {
    ip_protocols = ["tcp"]
    cidr_ranges = ["0.0.0.0/0"]
    direction = "BOTH"
    }
  
}
