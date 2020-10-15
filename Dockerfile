FROM debian:buster-slim

RUN apt-get update && apt-get -y install apache2 certbot git curl && apt-get clean

EXPOSE 80

COPY html /var/www/html
COPY apache2 /etc/apache2

ARG GIT
ENV GIT=$GIT

CMD if [ "$GIT" = "none" ] ; then \
service apache2 start && cd new_container && mkdir base_site && cp Dockerfile_temp base_site/Dockerfile && cp -r apache2 base_site && mkdir base_site/apache2/ssl && certbot certonly --noninteractive --webroot --agree-tos -m $EMAIL -d $DOMAIN -w /var/www/html/ && cp /etc/letsencrypt/archive/$DOMAIN/fullchain1.pem base_site/apache2/ssl/fullchain.pem && cp /etc/letsencrypt/archive/$DOMAIN/privkey1.pem base_site/apache2/ssl/privkey.pem && cp -r /var/www/html base_site; \
elif [ "$GIT" = "standard" ] ; then \
service apache2 start && curl -u $GITUSER:$GITTOKEN https://api.github.com/user/repos -d '{"name":"base_site", "private":true}' && cd new_container && mkdir base_site && cp Dockerfile_temp base_site/Dockerfile && cp -r apache2 base_site && mkdir base_site/apache2/ssl && certbot certonly --noninteractive --webroot --agree-tos -m $EMAIL -d $DOMAIN -w /var/www/html/ && cp /etc/letsencrypt/archive/$DOMAIN/fullchain1.pem base_site/apache2/ssl/fullchain.pem && cp /etc/letsencrypt/archive/$DOMAIN/privkey1.pem base_site/apache2/ssl/privkey.pem && cp -r /var/www/html base_site && cd base_site && git init && git remote add origin https://$GITUSER:$GITTOKEN@github.com/$GITUSER/base_site.git && git add . && git commit -m testing && git push -u origin master && rm -rf .git; \
elif [ "$GIT" = "custom" ] ; then \
service apache2 start && curl -u $GITUSER:$GITTOKEN https://api.github.com/user/repos -d '{"name":"'"$GITREPO"'", "private":true}' && cd new_container && mkdir $GITREPO && cp Dockerfile_temp $GITREPO/Dockerfile && cp -r apache2 $GITREPO && mkdir $GITREPO/apache2/ssl && certbot certonly --noninteractive --webroot --agree-tos -m $EMAIL -d $DOMAIN -w /var/www/html/ && cp /etc/letsencrypt/archive/$DOMAIN/fullchain1.pem base_site/apache2/ssl/fullchain.pem && cp /etc/letsencrypt/archive/$DOMAIN/privkey1.pem base_site/apache2/ssl/privkey.pem && cp -r /var/www/html $GITREPO && cd $GITREPO && git init && git remote add origin https://$GITUSER:$GITTOKEN@github.com/$GITUSER/$GITREPO.git && git add . && git commit -m testing && git push -u origin master && rm -rf .git; fi