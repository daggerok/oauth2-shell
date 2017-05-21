#!/bin/bash

# using httpie:
# $ api
# $ api get :8080/api/get-transactions\?client=test

function api {
  oauth2_url='http://example.com/authorization/token/v1/authorize'
  client_id='username:admin'
  secret='password:admin'
  
  if [ $# -eq 0 ]; then
    response=$(http post $oauth2_url $client_id $secret -pb)
    raw_token=$(echo $response | jq '.access_token')
    pattern='"'
    replacement=''
    token="${raw_token//$pattern/$replacement}"
    export header="'Authorization: Bearer $token'"
  else
    bash -c "http $@ $header"
  fi
}

# using curl
# $ api-curl
# $ api-curl -XGET localhost:8080/api/get-transactions\?client=test

function api-curl {
  oauth2_url='http://example.com/authorization/token/v1/authorize'
  client_id='username:admin'
  secret='password:admin'

  if [ $# -eq 0 ]; then
    response=$(curl -sSXPOST $oauth2_url -H$client_id -H$secret)
    raw_token=$(echo $response | jq '.access_token')
    pattern='"'
    replacement=''
    token="${raw_token//$pattern/$replacement}"
    export header="'Authorization: Bearer $token'"
  else
    bash -c "curl -sS $@ -H$header | jq"
  fi
}
