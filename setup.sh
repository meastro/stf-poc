#!/bin/bash
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install git

cd ~
git clone https://github.com/meastro/stf-poc.git
echo
echo "Do you wish to install OPENSTF with the DarkWeb Capability?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) echo "THIS IS NOT WORKING YET"; break;;
        No ) read -p 'Enter the IP or hostname where STF will look for connections:' hostname; break;;
    esac
done
echo
echo CREATING THE ENV FILE FOR DOCKER
echo
sudo rm ~/stf-poc/.env
touch ~/stf-poc/.env
SECRET=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w32 | head -n 1)
echo PUBLIC_IP=$hostname >> ~/stf-poc/.env
echo SECRET=$SECRET >> ~/stf-poc/.env
echo RETHINKDB_PORT_28015_TCP=tcp://rethinkdb:28015 >> ~/stf-poc/.env
echo STATION_NAME=$hostname >> ~/stf-poc/.env

sudo apt-get install docker docker-compose

cd /home/stfuser/stf-poc
sudo docker-compose up --build -d

echo Add the following line to crontab
echo
echo "@reboot (sleep 30s ; cd /home/stfuser/stf-poc ; docker-compose up --build -d)" 
echo
echo once done reboot the machine
echo
sudo crontab -e
