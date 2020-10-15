#!/bin/bash

##Must obtain an access token to authenticate via https://github.com/settings/tokens/new

if [ "$#" -eq 2 ]; then
	docker build -t cert_generator . --build-arg GIT=none

	docker run -e DOMAIN=$1 -e EMAIL=$2 -p 80:80 -v /home/pi/docker/certbot:/new_container cert_generator

	if [ $? -eq 0 ]; then
		echo "SSL certs created successfully! These can be found in ./base_site/apache2/ssl/ directory"
		exit 0
	else
		echo -e "An error occurred! Please ensure you are running:"
		echo "./generate.sh <domain_name> <email>"
		exit 1
	fi
elif [ "$#" -eq 4 ]; then
	docker build -t cert_generator . --build-arg GIT=standard

	docker run -e DOMAIN=$1 -e EMAIL=$2 -e GITUSER=$3 -e GITTOKEN=$4 -p 80:80 -v /home/pi/docker/certbot:/new_container cert_generator

	if [ $? -eq 0 ]; then
		echo "SSL certs created successfully! These can be found in ./base_site/apache2/ssl/ directory"
		echo "SSL certs have also been pushed to GitHub successfully at https://github.com/${3}/base_site"
		exit 0
	else
		echo -e "An error occurred! Please ensure you are running:"
		echo "./generate.sh <domain_name> <email> <gitusername_optional> <gitaccesstoken_optional>"
		exit 1
	fi

elif [ "$#" -eq 5 ]; then
	docker build -t cert_generator . --build-arg GIT=custom

	docker run -e DOMAIN=$1 -e EMAIL=$2 -e GITUSER=$3 -e GITTOKEN=$4 -e GITREPO=$5 -p 80:80 -v /home/pi/docker/certbot:/new_container cert_generator

	if [ $? -eq 0 ]; then
		echo "SSL certs created successfully! These can be found in ./${5}/apache2/ssl/ directory"
		echo "SSL certs have also been pushed to GitHub successfully at https://github.com/${3}/${5}"
		exit 0
	else
		echo -e "An error occurred! Please ensure you are running:"
		echo "./generate.sh <domain_name> <email> <gitusername_optional> <gitaccesstoken_optional> <gitreponame_optional>"
		exit 1
	fi
else
	echo; echo "USAGE: ./generate.sh <domain_name> <email> <gitusername_optional> <gitaccesstoken_optional> <gitreponame_optional>"; echo;

	exit 1
fi
