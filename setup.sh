#!/bin/bash
sudo apt-get update
sudo apt-get upgrade

sudo apt-get install vim apache2-utils git htop apt-transport-https docker docker-compose

sudo echo "deb https://deb.torproject.org/torproject.org bionic main" >> /etc/apt/sources.list

gpg --recv A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89
gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -

apt-get update
apt install tor deb.torproject.org-keyring

echo ENABLING TOR HIDDEN SERVICES
#sudo rm /etc/tor/torrc
#sudo touch /etc/tor/torrc
sudo echo "HiddenServiceDir /var/lib/tor/hidden_service/" >> /etc/tor/torrc
sudo echo "HiddenServicePort 80 127.0.0.1:80" >> /etc/tor/torrc

service tor restart
cd ~
git clone https://github.com/nikosch86/stf-poc.git

ONIONHOST=$(cat /var/lib/tor/hidden_service/hostname)
SECRET=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w32 | head -n 1)

echo CREATING THE ENV FILE
sudo rm ~/stf-poc/.env
touch ~/stf-poc/.env
echo PUBLIC_IP=$ONIONHOST >> ~/stf-poc/.env
echo SECRET=$SECRET >> ~/stf-poc/.env
echo RETHINKDB_PORT_28015_TCP=tcp://rethinkdb:28015 >> ~/stf-poc/.env
echo STATION_NAME=nuc >> ~/stf-poc/.env

echo THE .ENV FILE LOOKS LIKE THIS
cat ~/stf-poc/.env

echo CREATING USERNAME AND PASSWORD FOR HTPASSWD FILE
sudo htpasswd -c ~/stf-poc/nginx/.htpasswd sammy
cd ~/stf-poc

echo RUNNING STF
docker-compose up --build
