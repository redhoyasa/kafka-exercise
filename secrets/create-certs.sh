#!/bin/bash

# Generate CA key
openssl req -new -x509 \
					-keyout snakeoil-ca-1.key \
					-out snakeoil-ca-1.crt \
					-days 365 \
					-subj '/CN=/OU=/O=Internet Widgits Pty Ltd/L=/S=Some-State/C=AU' \
					-passin pass:test1234 \
					-passout pass:test1234

for i in broker producer consumer
do
	echo $i
	# Create keystores
	keytool -genkey -noprompt \
						-alias $i \
						-dname "CN=UNKNOWN, OU=UNKNOWN, O=UNKNOWN, L=UNKNOWN, S=UNKNOWN, C=UNKNOWN" \
						-keystore kafka.$i.keystore.jks \
						-keyalg RSA \
						-storepass test1234 \
						-keypass test1234

	# Create CSR, sign the key and import back into keystore
	keytool -keystore kafka.$i.keystore.jks \
				-alias $i \
				-certreq \
				-file $i.csr \
				-storepass test1234 \
				-keypass test1234

	openssl x509 -req -CA snakeoil-ca-1.crt \
					-CAkey snakeoil-ca-1.key \
					-in $i.csr \
					-out $i-ca1-signed.crt \
					-days 9999 \
					-CAcreateserial \
					-passin pass:test1234

	keytool -keystore kafka.$i.keystore.jks \
				-alias CARoot \
				-import \
				-file snakeoil-ca-1.crt \
				-storepass test1234 \
				-keypass test1234

	keytool -keystore kafka.$i.keystore.jks \
				-alias $i \
				-import \
				-file $i-ca1-signed.crt \
				-storepass test1234 \
				-keypass test1234

	# Create truststore and import the CA cert.
	keytool -keystore kafka.$i.truststore.jks \
				-alias CARoot \
				-import \
				-file snakeoil-ca-1.crt \
				-storepass test1234 \
				-keypass test1234

	echo "test1234" > ${i}_sslkey_creds
	echo "test1234" > ${i}_keystore_creds
	echo "test1234" > ${i}_truststore_creds
done