#!/bin/bash
# This script pulls a certificate from a website and adds it to
# the system ca bundle
# Usage: $0 https://someurl
hostname=$1
port=443
trust_cert_file_location=`curl-config --ca`

# Make a backup copy
sudo bash cp $trust_cert_file_location $trust_cert_file_location.$$

sudo bash -c "echo -n | openssl s_client -showcerts -connect $hostname:$port \
    2>/dev/null  | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p'  \
    >> $trust_cert_file_location"

