#!/bin/bash

set -a
source ".env"
set +a

conjur policy update -f azure-hosts.yml -b data | tee -a azure-hosts.log