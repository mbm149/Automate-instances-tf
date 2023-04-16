#!/bin/bash 

#Update packahe index
sudo apt-get update

#Instal git
#apt-get -y install git
#git clone https://github.com/mbm149/Automate-network-tf.git
#cd Automate-network-tf
# allow to run .sh file 
#chmod u+x script-tools.sh
#run the script 
#./script-tools.sh

#Install nmap, autopsy, sleuthkit
sudo apt-get install nmap autopsy sleuthkit -y 

#Isntall Joplin
sudo snap install joplin-james-carroll

#Intasll volatility-phocean
sudo snap install volatility-phocean -y 
