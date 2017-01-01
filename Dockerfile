FROM nginx:alpine

ARG S6_OVERLAY_VER=1.17.2.0
ARG K8S_VER=v1.3.6

RUN apk add --no-cache git make curl wget bc bash openssl certbot

## Install certbot
RUN mkdir -p /letsencrypt/challenges/.well-known/acme-challenge
RUN mkdir -p /etc/letsencrypt

# You should see "OK" if you go to http://<domain>/.well-known/acme-challenge/health
RUN echo "OK" > /letsencrypt/challenges/.well-known/acme-challenge/health

# Install kubectl
RUN wget https://storage.googleapis.com/kubernetes-release/release/${K8S_VER}/bin/linux/amd64/kubectl
RUN chmod +x kubectl
RUN mv kubectl /usr/local/bin/

# Install s6-overlay
RUN curl https://s3.amazonaws.com/wodby-releases/s6-overlay/v${S6_OVERLAY_VER}/s6-overlay-amd64.tar.gz | tar xz -C /

# Add our nginx config for routing through to the challenge results
RUN rm /etc/nginx/conf.d/*.conf

# Copy configs
COPY rootfs /

WORKDIR /letsencrypt

ENTRYPOINT ["/init"]
