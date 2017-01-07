#!/bin/bash

# $DOMAINS should contain all domains that this container is responsible for
# renewing. The first one dictates where the cert will live.

# Inside /etc/letsencrypt/live/<domain> we have:
#
# cert.pem  chain.pem  fullchain.pem  privkey.pem
#
# We want to convert fullchain.pem into proxycert
# and privkey.pem into proxykey and then save as a secret!

if [ -z "$SECRET_NAME" ]; then
    echo "ERROR: Secret name is empty or unset"
    exit 1
fi

CERT_LOCATION='/etc/letsencrypt/live'

DOMAINS=($DOMAINS)

DOMAIN=${DOMAINS[0]}

CERT=$(cat $CERT_LOCATION/$DOMAIN/fullchain.pem | base64 | tr -d '\n' )
KEY=$(cat $CERT_LOCATION/$DOMAIN/privkey.pem | base64 | tr -d '\n')
PEM=$(cat $CERT_LOCATION/$DOMAIN/fullchain.pem $CERT_LOCATION/$DOMAIN/privkey.pem | base64 | tr -d '\n' )
DHPARAM=$(openssl dhparam 2048 | base64 | tr -d '\n' )

NAMESPACE=${NAMESPACE:-default}
TYPE=${TYPE:-Opaque}

cat << EOF | kubectl apply -f -
{
 "apiVersion": "v1",
 "kind": "Secret",
 "metadata": {
   "name": "$SECRET_NAME",
   "namespace": "$NAMESPACE"
 },
 "data": {
   "proxycert": "$CERT",
   "proxykey": "$KEY",
   "tls.crt": "$CERT",
   "tls.key": "$KEY",
   "tls.pem": "$PEM",
   "dhparam": "$DHPARAM"
 },
 "type": "$TYPE"
}
EOF
