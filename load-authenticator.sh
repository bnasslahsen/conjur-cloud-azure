#!/bin/bash

set -a
source ".env"
set +a

#Load Azure root policy
envsubst < authn-jwt-azure.yml > authn-jwt-azure.yml.tmp
conjur policy update -f authn-jwt-azure.yml.tmp -b conjur/authn-jwt
rm authn-jwt-azure.yml.tmp

#Enable the JWT Authenticator in Conjur Cloud
conjur authenticator enable --id authn-jwt/$CONJUR_AUTHENTICATOR_ID

#We populate the jwks-uri variable with the JWT provider URL:
conjur variable set -i conjur/authn-jwt/$CONJUR_AUTHENTICATOR_ID/token-app-property -v "$AZURE_TOKEN_APP"
conjur variable set -i conjur/authn-jwt/$CONJUR_AUTHENTICATOR_ID/identity-path -v "$AZURE_IDENTITY"
conjur variable set -i conjur/authn-jwt/$CONJUR_AUTHENTICATOR_ID/issuer -v "$AZURE_ISSUER"
curl -k $AZURE_JWKS >  jwks.json
conjur variable set -i conjur/authn-jwt/$CONJUR_AUTHENTICATOR_ID/public-keys -v "{\"type\":\"jwks\", \"value\":$(cat jwks.json)}"
#conjur variable set -i conjur/authn-jwt/$CONJUR_AUTHENTICATOR_ID/audience -v "conjur"
rm jwks.json