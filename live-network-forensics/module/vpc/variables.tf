#network
variable "network_name" {}
variable "auto_subnet" { default = "false" }
#variable "subnetwork_name" { }
variable "region" {}
#variable "network" {}

#Subnetwork
variable "subnetwork_name" {}
variable "ip_cidr_range" {}


#firewall rules 
variable "firewall_rule_name" {}

#peering
#variable "rules" {}\

variable "protocol" {}
#variable "protocol-icmp" {}
variable "ports" {}
variable "direction" {}
variable "source_ranges" {}
