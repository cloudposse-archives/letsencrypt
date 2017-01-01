#!/usr/bin/with-contenv bash


if [ -n "${LETSENCRYPT_ENDPOINT+1}" ]; then
    echo "server = $LETSENCRYPT_ENDPOINT" >> /etc/letsencrypt/cli.ini
fi