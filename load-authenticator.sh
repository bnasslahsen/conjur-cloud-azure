#!/bin/bash

set -a
source ".env"
set +a


# Create AZURE Branch
conjur policy update -b data -f <(envsubst < azure-branch.yml)

#Load Azure authenticator policy
conjur policy update -b conjur/authn-azure -f <(envsubst < authn-azure.yml)

#Enable the Azure Authenticator in Conjur Cloud
conjur authenticator enable --id authn-azure/$CONJUR_AUTHENTICATOR_ID

#Azure Authenticator Configuration
conjur variable set -i conjur/authn-azure/$CONJUR_AUTHENTICATOR_ID/provider-uri -v $AZURE_PROVIDER_URI
