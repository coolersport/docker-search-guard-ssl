# docker-search-guard-ssl
Docker image for generating TLS certificates using search-guard-ssl scripts

    docker run -it --rm -v /path/to/empty/cert/:/certificates:rw -e CA_PASS=storepass coolersport/search-guard-ssl
