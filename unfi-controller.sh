#!/bin/bash
#Always
sudo apt-get update -y
sudo apt-get upgrade -y

#Setup Repo
cd /tmp
sudo wget -O /etc/apt/trusted.gpg.d/unifi-repo.gpg https://dl.ui.com/unifi/unifi-repo.gpg 
echo 'deb https://www.ui.com/downloads/unifi/debian stable ubiquiti' | sudo tee /etc/apt/sources.list.d/100-ubnt-unifi.list
#Mongo's repo for UniFi is pointless since UniFi is based on a depricated version but best practice/Prepare for the future/ what not
wget -qO - https://www.mongodb.org/static/pgp/server-3.4.asc | sudo apt-key add -
echo "deb https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
sudo apt-get update -y

#Basics dependencies
apt-get install -y wget curl libc6 libcommons-daemon-java openssl
apt-get install -y ca-certificates-java java-common libc6 libcups2 libfontconfig1 
apt-get install -y libfreetype6 libjpeg62-turbo liblcms2-2 libnss3 libpcsclite1 libstdc++6 libx11-6
apt-get install -y libxext6 libxi6 libxrender1 libxtst6 util-linux zlib1g

#JavaJRE8
#Try the apt-get but we need 1.8 so downloaded .deb
sudo apt-get -y install openjdk-11-jre-headless
#Picked a random mirror
wget http://ftp.br.debian.org/debian/pool/main/o/openjdk-8/openjdk-8-jre-headless_8u232-b09-1~deb9u1_amd64.deb
sudo dpkg -i openjdk-8-jre-headless_8u232-b09-1~deb9u1_amd64.deb
#May require “apt --fix-broken install” to fix dependencies

#Configure Java version default to 1.8 (manual) 
update-alternatives --config java
#need to figure this in script:
#sudo update-java-alternatives --jre-headless --jre --set java-1.8.0-openjdk-amd64

#MongoDB3.6.x
#This fails due to repo’s aging but worth a shot
sudo apt-get install -y mongodb-org=3.6.17 mongodb-org-server=3.6.17 mongodb-org-shell=3.6.17 mongodb-org-mongos=3.6.17 mongodb-org-tools=3.6.17
#Downloaded deb
wget https://repo.mongodb.org/apt/ubuntu/dists/xenial/mongodb-org/3.6/multiverse/binary-amd64/mongodb-org-server_3.6.17_amd64.deb
sudo dpkg -i mongodb-org-server_3.6.17_amd64.deb
#and HOLD
sudo apt-mark hold mongodb-org-server

#Now we can install the controller
#UniFi Controller install and HOLD
sudo apt-get update && sudo apt-get install unifi -y && sudo apt-mark hold unifi

systemctl enable unifi && systemctl start unifi

#Alternatively if it fails download the .deb
sudo dpkg -i unifi_sysvinit_all.deb
#If fails on dependencies try
mkdir /tmp/unifi; sudo dpkg-deb -R unifi_sysvinit_all.deb /tmp/unifi/
#edit the control file in the Debian folder to remove the dependencies IF appropriate
sudo dpkg-deb -b /tmp/unifi unifi-fixed.deb
sudo dpkg -i unifi-fixed.deb
systemctl enable unifi && systemctl start unifi

