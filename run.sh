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
if [[ -n $SAN ]]; then
        sed -i "s/-ext san=dns:/-ext san=${SAN},dns:/g" /pki-scripts/gen_node_cert.sh
fi
./example.sh
rm -rf *.sh etc
