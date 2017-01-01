#!/usr/bin/with-contenv bash

DOMAINS=(${DOMAINS})

if [ -z "$DOMAINS" ]; then
    echo "ERROR: Domain list is empty or unset" > /dev/stdout 2>&1
    exit 1
fi

domain_args=""
for i in "${DOMAINS[@]}"
do
  echo "Tring to resolve domain $i" > /dev/stdout 2>&1
  until $(curl --output /dev/null --silent --head --fail http://$i/.well-known/acme-challenge/health); do
    sleep 5
  done
  echo "Domain $i resolved" > /dev/stdout 2>&1
done
echo "Generating certs" > /dev/stdout 2>&1
/letsencrypt/refresh_certs.sh > /dev/stdout 2>&1