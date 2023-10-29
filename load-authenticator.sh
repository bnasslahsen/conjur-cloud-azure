#!/bin/bash

set -a
source ".env"
set +a

# Create AZURE Branch
conjur policy update -b data -f azure-branch.yml

#Load Azure root policy
envsubst < authn-azure.yml > authn-azure.yml.tmp
conjur policy update -f authn-azure.yml.tmp -b conjur/authn-azure
rm authn-azure.yml.tmp

#Enable the Azure Authenticator in Conjur Cloud
conjur authenticator enable --id authn-azure/$CONJUR_AUTHENTICATOR_ID

#Azure Authenticator Configuration
conjur variable set -i conjur/authn-azure/$CONJUR_AUTHENTICATOR_ID/provider-uri -v "$AZURE_PROVIDER_URI"