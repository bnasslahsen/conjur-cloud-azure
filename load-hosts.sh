#!/bin/bash

set -a
source ".env"
set +a

envsubst < azure-hosts.yml > azure-hosts.yml.tmp
conjur policy update -f azure-hosts.yml.tmp -b data/bnl/azure-team | tee -a azure-hosts.log
rm azure-hosts.yml.tmp

envsubst < azure-hosts-grants.yml > azure-hosts-grants.yml.tmp
conjur policy update -f azure-hosts-grants.yml.tmp -b data/vault/bnl-azure-safe
rm azure-hosts-grants.yml.tmp