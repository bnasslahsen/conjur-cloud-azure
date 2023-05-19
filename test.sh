# Global Variables
CONJUR_AUTHENTICATOR_ID=bnl-azure
CONJUR_ACCOUNT=conjur
CONJUR_URL=https://emeadevops.secretsmgr.cyberark.cloud/api
CONUR_HOST_ID=host%2Fdata%2Fbnl%2Fazure-team%2Fazure-apps%2Fbnl-test-vm
SECRET_ID=data%2Fvault%2Fbnl-azure-safe%2FDatabase-MySQL-test%2Fpassword

# Authenticate against conjur, get a temporary token
AZURE_TOKEN=$(curl 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fmanagement.azure.com%2F' -H Metadata:true -s | jq -r '.access_token')
echo $AZURE_TOKEN

CONJUR_ACCESS_TOKEN=$(curl -s --request POST "$CONJUR_URL/authn-azure/$CONJUR_AUTHENTICATOR_ID/conjur/$CONUR_HOST_ID/authenticate" --header 'Content-Type: application/x-www-form-urlencoded' --header "Accept-Encoding: base64" --data-urlencode "jwt=$AZURE_TOKEN")

# Connect to the Conjur/Conjur REST API to retrieve secret value"
SECRET_VALUE=$(curl -s --header "Authorization: Token token=\"$CONJUR_ACCESS_TOKEN\"" "$CONJUR_URL/secrets/$CONJUR_ACCOUNT/variable/$SECRET_ID")

echo " "
echo "---- Retrieving Secret Value -----------"
echo "ID: $SECRET_ID"
echo "Value: $SECRET_VALUE"
echo "----------------------------------------"
echo " "
