#!/bin/bash

set -a
source ".env"
set +a

conjur policy update -b data/$APP_GROUP -f <(envsubst < azure-hosts.yml)

conjur policy update -b data/vault/bnl-azure-safe -f <(envsubst < azure-hosts-grants.yml)
