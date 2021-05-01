#!/bin/bash

dclean() {
    docker rm -f $(docker ps -a -q); docker volume rm $(docker volume ls -q);
}

dclean
cd /home/pi/docker/certbot/
sudo rm -rf base_site
./generate.sh ashhadghazi.com ashhad.ghazi@gmail.com
cp -f base_site/apache2/ssl/fullchain.pem /home/pi/docker/masterPi/apache2/ssl/ashhadghazi.com/fullchain.pem
sudo cp -f base_site/apache2/ssl/privkey.pem /home/pi/docker/masterPi/apache2/ssl/ashhadghazi.com/privkey.pem
sudo chown pi /home/pi/docker/masterPi/apache2/ssl/ashhadghazi.com/privkey.pem 
sudo chgrp pi /home/pi/docker/masterPi/apache2/ssl/ashhadghazi.com/privkey.pem 
sudo chgrp pi /home/pi/docker/masterPi/apache2/ssl/ashhadghazi.com/fullchain.pem
sudo chown pi /home/pi/docker/masterPi/apache2/ssl/ashhadghazi.com/fullchain.pem

dclean
cd /home/pi/docker/certbot/
sudo rm -rf base_site
./generate.sh ashhadspi.com ashhad.ghazi@gmail.com
cp -f base_site/apache2/ssl/fullchain.pem /home/pi/docker/masterPi/apache2/ssl/ashhadspi.com/fullchain.pem
sudo cp -f base_site/apache2/ssl/privkey.pem /home/pi/docker/masterPi/apache2/ssl/ashhadspi.com/privkey.pem
sudo chown pi /home/pi/docker/masterPi/apache2/ssl/ashhadspi.com/privkey.pem 
sudo chgrp pi /home/pi/docker/masterPi/apache2/ssl/ashhadspi.com/privkey.pem 
sudo chgrp pi /home/pi/docker/masterPi/apache2/ssl/ashhadspi.com/fullchain.pem 
sudo chown pi /home/pi/docker/masterPi/apache2/ssl/ashhadspi.com/fullchain.pem

sudo rm -rf base_site

dclean
cd /home/pi/docker
docker build -t ashghaz/masterpi masterPi/
docker run -d -p 80:80 -p 443:443 -p 8080:8080 ashghaz/masterpi

echo -e "\nSSL certs generated successfully! Sites are now up!\n"
