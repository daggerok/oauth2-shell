# oauth2-shell

a little helper functions for bash and fish shell interpreters, which makes testing secured api little bit easier (for personal use only)

**note: require jq**

## httpie

### fish

```fish
function api
  set -l oauth2_url 'http://example.com/authorization/token/v1/authorize'
  set -l client_id 'username:id'
  set -l secret 'password:secret'

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
  client_id='username:id'
  secret='password:secret'
  
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

### usage bash / fish

- call `api` with no arguments to fetch token and export proper header "Authorization: Bearer $TOKEN"
- call `api <method> <url> [<params and other httpie options>]

```fish
api
api get :8080/api/get-transactions\?key=value
```

### bat / cmd

```bat
@echo off

REM required http and jq installed:
REM REM pip install -U httpie
REM scoop install jq

if ".%1" == "." goto Usage

setlocal
set where_cmd=C:\Windows\System32\where.exe
for /f %%i in ('%where_cmd% http') do set http_cmd=%%i
for /f %%i in ('%where_cmd% jq') do set jq_cmd=%%i

set auth_endpoint=http://example.com/authorization/token/v1/authorize
set client_id=username:id
set secret=password:secret

for /f %%i in ('%http_cmd% post %auth_endpoint% %client_id% %secret% ^| jq .access_token') do set access_token=%%i
call :RemoveQuotes %access_token%
set header="Authorization: Bearer %access_token%"
%http_cmd% %* %header%
endlocal
goto :eof

:Usage echo "require at least one argument."
echo "example: api.cmd get :8080/api/v1/resource?key=value"
goto :eof

REM this method is removing quotes from argument
:RemoveQuotes
setlocal
set arg=%~1
endlocal&set access_token=%arg%
goto :eof
```

### usage bat / cmd

call `api.cmd <method> <url> [<params and other httpie options>]

```bat
api.cmd get :8080/api/get-transactions?key=value
```

## curl

### fish

```fish
function api-curl
  set -l oauth2_url 'http://example.com/authorization/token/v1/authorize'
  set -l client_id 'username:id'
  set -l secret 'password:secret'

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
  client_id='username:id'
  secret='password:secret'

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

### usage bash / fish

- call `api-curl` with no arguments to fetch token and export proper header "Authorization: Bearer $TOKEN"
- call `api-curl <curl params and options>

```fish
api-curl
api-curl -XGET localhost:8080/api/get-transactions\?key=value
```

### bat / cmd

```bat
@echo off

REM required curl and jq installed:
REM scoop install curl jq

if ".%1" == "." goto Usage

setlocal
set where_cmd=C:\Windows\System32\where.exe
for /f %%i in ('%where_cmd% curl') do set curl_cmd=%%i
for /f %%i in ('%where_cmd% jq') do set jq_cmd=%%i

set auth_endpoint=http://example.com/authorization/token/v1/authorize
set client_id=username:id
set secret=password:secret

for /f %%i in ('%curl_cmd% -sSXPOST %auth_endpoint% -H%client_id% -H%secret% ^| jq .access_token') do set access_token=%%i
call :RemoveQuotes %access_token%
set header="Authorization: Bearer %access_token%"
%curl_cmd% -sS %* -H%header% | jq
endlocal
goto :eof

:Usage echo "require at least one argument."
echo "example: api-curl.cmd -XGET localhost:8080/api/v1/resource?key=value"
goto :eof

REM this method is removing quotes from argument
:RemoveQuotes
setlocal
set arg=%~1
endlocal&set access_token=%arg%
goto :eof
```

### usage bat / cmd

call `api.cmd <method> <url> [<params and other httpie options>]

```bat
api.cmd -XGET localhost:8080/api/get-transactions?key=value
```

links:

- [jq](https://stedolan.github.io/jq/)
- [curl](https://curl.haxx.se/)
- [httpie](https://httpie.org/)
