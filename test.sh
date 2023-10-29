#!/bin/bash

set -a
source ".env"
set +a

# Authenticate against conjur, get a temporary token
AZURE_TOKEN=$(curl 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fmanagement.azure.com%2F' -H Metadata:true -s | jq -r '.access_token')
# Exchange Azure Token against a CyberArk Conjur Token
CONJUR_ACCESS_TOKEN=$(curl -s --request POST "$CONJUR_URL/authn-azure/$CONJUR_AUTHENTICATOR_ID/conjur/$CONUR_HOST_ID/authenticate" --header 'Content-Type: application/x-www-form-urlencoded' --header "Accept-Encoding: base64" --data-urlencode "jwt=$AZURE_TOKEN")
# Connect to the Conjur/Conjur REST API to retrieve secret value"
SECRET_VALUE=$(curl -s --header "Authorization: Token token=\"$CONJUR_ACCESS_TOKEN\"" "$CONJUR_URL/secrets/$CONJUR_ACCOUNT/variable/$SECRET_ID")

echo " "
echo "---- Retrieving Secret Value -----------"
echo "ID: $SECRET_ID"
echo "Value: $SECRET_VALUE"
echo "----------------------------------------"
echo " "