# oauth2-shell

a little helper functions for bash and fish shell interpreters, which makes testing secured api little bit easier (for personal use only)

## httpie (require: jq)

### fish

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
```

### bash

```bash
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
```

### usage

- call `api` with no arguments to fetch token and export proper header "Authorization: Bearer $TOKEN"
- call `api <method> <url> [<params and other httpie options>]


```fish
api
api get :8080/api/get-transactions\?client=test
```

## curl (require: jq)

### fish

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
```

### bash

```bash
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
```

### usage

- call `api-curl` with no arguments to fetch token and export proper header "Authorization: Bearer $TOKEN"
- call `api-curl <curl params and options>


```fish
api-curl
api-curl -XGET localhost:8080/api/get-transactions\?client=test
```

links:

- [jq](https://stedolan.github.io/jq/)
- [curl](https://curl.haxx.se/)
- [httpie](https://httpie.org/)
