#!/bin/sh

echo "DEFAULT_SERVER_NAME=${DEFAULT_SERVER_NAME}"
echo "SNI1_SERVER_NAME=${SNI1_SERVER_NAME}"
echo "SNI2_SERVER_NAME=${SNI2_SERVER_NAME}"

set -eux

openssl req -new -x509 -days 3650 -nodes -extensions v3_ca \
    -keyout /root/ca/private/cakey.pem \
    -out /root/ca/cacert.pem \
    -subj "/C=US/ST=Texas/L=San Antonio/O=sivel/CN=${DEFAULT_SERVER_NAME}"

openssl req -new -nodes -out /root/ca/${DEFAULT_SERVER_NAME}-req.pem \
    -keyout /root/ca/private/${DEFAULT_SERVER_NAME}-key.pem \
    -subj "/C=US/ST=Texas/L=San Antonio/O=sivel/CN=${DEFAULT_SERVER_NAME}"

yes | openssl ca -config /etc/ssl/openssl.cnf -days 3650 \
    -out /root/ca/${DEFAULT_SERVER_NAME}-cert.pem \
    -infiles /root/ca/${DEFAULT_SERVER_NAME}-req.pem

openssl req -new -nodes -out /root/ca/${SNI1_SERVER_NAME}-req.pem \
    -keyout /root/ca/private/${SNI1_SERVER_NAME}-key.pem -config /etc/ssl/openssl.cnf \
    -subj "/C=US/ST=Texas/L=San Antonio/O=sivel/CN=${SNI1_SERVER_NAME}"

yes | openssl ca -config /etc/ssl/openssl.cnf -days 3650 \
    -out /root/ca/${SNI1_SERVER_NAME}-cert.pem \
    -infiles /root/ca/${SNI1_SERVER_NAME}-req.pem

openssl req -new -nodes -out /root/ca/${SNI2_SERVER_NAME}-req.pem \
    -keyout /root/ca/private/${SNI2_SERVER_NAME}-key.pem -config /etc/ssl/openssl.cnf \
    -subj "/C=US/ST=Texas/L=San Antonio/O=sivel/CN=${SNI2_SERVER_NAME}"

yes | openssl ca -config /etc/ssl/openssl.cnf -days 3650 \
    -out /root/ca/${SNI2_SERVER_NAME}-cert.pem \
    -infiles /root/ca/${SNI2_SERVER_NAME}-req.pem

openssl req -new -nodes -out /root/ca/client.${DEFAULT_SERVER_NAME}-req.pem \
    -keyout /root/ca/private/client.${DEFAULT_SERVER_NAME}-key.pem \
    -config /etc/ssl/openssl.cnf \
    -subj "/C=US/ST=Texas/L=San Antonio/O=sivel/CN=client.${DEFAULT_SERVER_NAME}"

yes | openssl ca -config /etc/ssl/openssl.cnf -days 3650 \
    -out /root/ca/client.${DEFAULT_SERVER_NAME}-cert.pem \
    -infiles /root/ca/client.${DEFAULT_SERVER_NAME}-req.pem

cp /root/ca/cacert.pem /usr/share/nginx/html/cacert.pem
cp /root/ca/client.${DEFAULT_SERVER_NAME}-cert.pem /usr/share/nginx/html/client.pem
cp /root/ca/private/client.${DEFAULT_SERVER_NAME}-key.pem /usr/share/nginx/html/client.key
