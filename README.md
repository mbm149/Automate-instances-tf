
# Conducting Live Network Forensics  

Perform Live Forensics on an Infected VM
Protecting Your Assets: Isolating Infected VMs in GCP
Maximizing Your Forensic Analysis with Live Network Traffic
Investigating Network Intrusions: The Power of Live Forensics
Securely Capturing Live Traffic in GCP for Forensic Analysis


If one of your VMs in your infrastructure has been compromised, it is important to have an incident response plan in place. This plan should consist of 3 important phases:
Preparation, Detection, and Response.
The idea of this project is to configure your GCP environment to perform live network analysis instead of doing dead analysis. By doing live analyses, we can have the VM running and start capturing the evidence from the infected VM directly. Helping us to enable the imaging or RAM, bypass hard drives, and determine the abnormal traffic.  

The first step is to isolate and contain a compromised VM and connect it to the Forensic VPC for investigation.  
1. First, we must create a firewall rule that will deny any ingress and egress traffic from any CIDR besides the forensic subnet. We can tag the VM with a unique network tag and then apply the firewall rules created earlier. Performing this step will ensure that the infected VM is isolated from the project and the internet while enabling access to the VM via VPC peering.
2. Then, we need to peer the forensic project with the VPC in the project where the infected VM is located. Once the VPC peering is established, routes are exchanged between the forensic and the VM VPCs. Now, the VM from the forensic project can communicate with the infected VM and start the live forensics analysis.


