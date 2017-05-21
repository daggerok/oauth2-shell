#!/usr/local/bin/fish

# using httpie
# ~> api
# ~> api get :8080/api/get-transactions\?client=test

```fish
function api
  set -l oauth2_url 'http://example.com/authorization/token/v1/authorize'
  set -l client_id 'username:admin'
  set -l secret 'password:admin'

  if test 0 -eq (count $argv)
    set -l response (http post $oauth2_url $client_id $secret -pb)
    set -l raw_token (echo $response | jq '.access_token')
    set -l token (string replace -a '"' '' $raw_token)
    set -g header "Authorization: Bearer $token"
  else
    http $argv $header
  end
end api

# using curl
# ~> api-curl
# ~> api-curl -XGET localhost:8080/api/get-transactions\?client=test

```fish
function api-curl
  set -l oauth2_url 'http://example.com/authorization/token/v1/authorize'
  set -l client_id 'username:admin'
  set -l secret 'password:admin'

  if test 0 -eq (count $argv)
    set -l response (curl -sSXPOST $oauth2_url -H$client_id -H$secret)
    set -l raw_token (echo $response | jq '.access_token')
    set -l token (string replace -a '"' '' $raw_token)
    set -g header "Authorization: Bearer $token"
  else
    curl -sS $argv -H$header | jq
  end
end api-curl
