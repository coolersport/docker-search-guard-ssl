#!/bin/bash

cd /certificates
cp /pki-scripts/*.sh .
cp -r /pki-scripts/etc .
./example.sh
rm -rf *.sh etc
