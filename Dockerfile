FROM coolersport/alpine-java:8u162b12_server-jre_unlimited

COPY run.sh /

RUN apk add --no-cache openssl git bash && \
    git clone https://github.com/floragunncom/search-guard-ssl.git /tmp/search-guard-ssl && \
    mv /tmp/search-guard-ssl/example-pki-scripts/ /pki-scripts && \
    chmod +x /pki-scripts/*.sh && \
    sed -i 's/changeit/$CA_PASS/g' /pki-scripts/example.sh && \
    rm -rf /tmp/search-guard-ssl && \
    chmod +x /run.sh && \
    mkdir /certificates

CMD ["/run.sh"]
