# Demo project for Azure

## Pre-requisites
- OS Linux / MacOS
- conjur-cloud-cli

## Azure Setup

- Create BNL ROOT Branch - AS Security Admin
```shell
conjur policy update -b data -f root-branch.yml
```

- Create AZURE Branch - AS Security Admin
```shell
conjur policy update -b data/bnl -f azure-branch.yml
```

- Delegation on the branch for the team - AS Security Admin
```shell
conjur policy update -b data/vault -f azure-user-grants.yml
```

- Declare Azure authenticator - AS Security Admin
```shell
./load-authenticator.sh
```

- Declare Your Apps - AS Projects Team
```shell
./load-hosts.sh
```
