#!/bin/bash
set -e

cd /certificates
cp /pki-scripts/*.sh .
cp -r /pki-scripts/etc .
if [[ -n $DOMAIN && -n $EXT ]]; then
        sed -i "s/example.com/${DOMAIN}.${EXT}/g" /pki-scripts/example.sh
        sed -i "s/example.com/${DOMAIN}.${EXT}/g" /pki-scripts/gen_node_cert.sh
        sed -i "s/0.domainComponent       = \"com\"/0.domainComponent       = \"${EXT}\"/g" /pki-scripts/etc/root-ca.conf
        sed -i "s/1.domainComponent       = \"example\"/1.domainComponent       = \"${DOMAIN}\"/g" /pki-scripts/etc/root-ca.conf
        sed -i "s/0.domainComponent       = \"com\"/0.domainComponent       = \"${EXT}\"/g" /pki-scripts/etc/signing-ca.conf
        sed -i "s/1.domainComponent       = \"example\"/1.domainComponent       = \"${DOMAIN}\"/g" /pki-scripts/etc/signing-ca.conf
fi
if [[ -n $ORG ]]; then
        sed -i "s/Example Com Inc./${ORG}/g" /pki-scripts/etc/root-ca.conf
        sed -i "s/Example Com Inc./${ORG}/g" /pki-scripts/etc/signing-ca.conf
fi
#        sed -i "s/-ext san=dns:\$NODE_NAME.example.com,dns:localhost,ip:127.0.0.1,oid:1.2.3.4.5.5/-ext san=${SAN},dns:\$NODE_NAME.example.com,dns:localhost,ip:127.0.0.1,oid:1.2.3.4.5.5/g" /pki-scripts/gen_node_cert.sh

./clean.sh
./gen_root_ca.sh capass $CA_PASS
export DN=$DN_NODE0
export SAN=$SAN_NODE0
./gen_node_cert.sh 0 $CA_PASS capass
export DN=$DN_NODE1
export SAN=$SAN_NODE1
./gen_node_cert.sh 1 $CA_PASS capass
export DN=$DN_NODE2
export SAN=$SAN_NODE2
./gen_node_cert.sh 2 $CA_PASS capass
#./gen_revoked_cert_openssl.sh "/CN=revoked.example.com/OU=SSL/O=Test/L=Test/C=DE" "revoked.example.com" "revoked" $CA_PASS capass
#./gen_node_cert_openssl.sh "/CN=es-node.example.com/OU=SSL/O=Test/L=Test/C=DE" "es-node.example.com" "es-node" $CA_PASS capass
#./gen_node_cert_openssl.sh "/CN=node-4.example.com/OU=SSL/O=Test/L=Test/C=DE" "node-4.example.com" "node-4" $CA_PASS capass
#./gen_client_node_cert.sh spock $CA_PASS capass
#./gen_client_node_cert.sh kirk $CA_PASS capass
./gen_client_node_cert.sh logstash $CA_PASS capass
./gen_client_node_cert.sh filebeat $CA_PASS capass
./gen_client_node_cert.sh kibana $CA_PASS capass

# convert to pkcs8
openssl pkcs8 -passin pass:$CA_PASS -passout pass:$CA_PASS -in logstash.key.pem -topk8 -out logstash.key
openssl pkcs8 -passin pass:$CA_PASS -passout pass:$CA_PASS -in filebeat.key.pem -topk8 -out filebeat.key
openssl pkcs8 -passin pass:$CA_PASS -passout pass:$CA_PASS -in kibana.key.pem -topk8 -out kibana.key

rm -rf *.sh etc
