provider "google" {}

variable "project_id" { default = "project-foresics-381" }


module "forensic-network" {
  source       = "./module/vpc"
  network_name = "forensic-network"

  subnetwork_name = "forensic-subnetwork"
  region          = "us-central1"

  firewall_rule_name = "foresic-firewallrule-ssh-icmp"
  ip_cidr_range      = "10.128.0.0/20"
  
  source_ranges = ["0.0.0.0/0"]
  direction = "INGRESS"
  protocol = "tcp"
  ports = ["22"]
  #protocol-icmp = "icmp"

}

module "private-network"{
  source       = "./module/vpc"
  network_name = "private-network"

  subnetwork_name = "private-subnetwork"
  region          = "us-central1"

  firewall_rule_name = "private-firewallrule-ssh"
  ip_cidr_range      = "172.16.0.0/24"

  source_ranges = ["0.0.0.0/0"]
  direction = "INGRESS"
  protocol = "tcp"
  ports = ["22"]
  #protocol-icmp = "icmp"
}

##need to create 3 firewall rules 
#icmp ingress network private-network source range spefici ip foresct ip instance 
## deny ingress and egress network private  range spefici ip for vm infect 

module "firewall-rule" {
    
  source = "./module/firewallrules"
  firewall_rule_name = "forensic-icmp"
  network_name = "private-network"
  source_ranges = ["10.128.0.2"]
  direction = "INGRESS"


}

#backend service
module "backend-service" {
    source = "./module/loadbalancer"
    backend_service_name = "backend-lb"

    #forensic_group = module.forensic_group
    #forwarding rules
    forwarding-rule = "fowarding-rule" 
    forensic_network_name =  "forensic-network"
    subnetwork_name = "forensic-subnetwork"
    
    
    #packet mirroring
    packet-mirroring = "packet-mirroring"
    #Tshe source instance to capture packets mirroring 
    mirrored_instance = "private-instance-a"
    network_name = "private-network"
}

#module "forensic_group" {
#    source = "./module/groupinstances"
#    name = "forensic-instance-group"
#    zone = "us-central1-a"
#    #network_name = "forensic-network"
#    network_name = "projects/project-foresics-381/global/networks/forensic-network"
#  
#}
##################################


module "forensic-bucket" {
  source     = "./module/storage"
  name       = "forensic-bucket-us-region-abc"
  project_id = var.project_id
  locations  = "us-central1"
}

# intances 

module "forensic-instace" {
  source              = "./module/instances"
  instance_name       = "forensic-instance"
  instance_subnetwork = "forensic-subnetwork"
  zone                = "us-central1-a"
  metadata  =  {
    startup-script = <<-EOF
               #!/bin.bash 
               apt-get update
               mkdir hello
               apt-get -y install git
               git clone https://github.com/mbm149/Automate-network-tf.git 
               cd Automate-network-tf
               chmod u+x script-tools.sh
               ./script-tools.sh
               EOF
    }
 }




module "private-instace-a" {
  source              = "./module/instances"
  instance_name       = "private-instance-a"
  instance_subnetwork = "private-subnetwork"
  zone                = "us-central1-a"
  metadata = {}
}


module "private-instace-f" {
  source              = "./module/instances"
  instance_name       = "private-instance-f"
  instance_subnetwork = "private-subnetwork"
  zone                = "us-central1-f"
  metadata = {}
}



##peering network 

resource "google_compute_network_peering" "peering1-private" {
  name         = "peering1-private"
  network      = "projects/project-foresics-381/global/networks/private-network"
  peer_network = "projects/project-foresics-381/global/networks/forensic-network"
}

resource "google_compute_network_peering" "peering2-forensic" {
  name          = "peering2-forensic"
  network       = "projects/project-foresics-381/global/networks/forensic-network"
 peer_network   = "projects/project-foresics-381/global/networks/private-network"
}
# "projects/PROJECT_ID/global/networks/NETWORK_NAME"
