#!/usr/bin/with-contenv bash

CERT_LOCATION='/etc/letsencrypt/live'

DOMAINS=($DOMAINS)

DOMAIN=${DOMAINS[0]}

mkdir -p $CERT_LOCATION/$DOMAIN
cd $CERT_LOCATION/$DOMAIN
openssl req -nodes -x509 -newkey rsa:4096 -keyout privkey.pem -out fullchain.pem -days 365 -subj "/"
