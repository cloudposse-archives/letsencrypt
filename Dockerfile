FROM ployst/letsencrypt:0.2.0

ADD generate_selfsigned.sh /letsencrypt/
RUN chmod +x /letsencrypt/generate_selfsigned.sh
