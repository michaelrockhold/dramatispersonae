curl --header "Content-Type: application/json" \
  --request POST \
  --data '{
        "routeKey":"GET /search",
        "version":"2.0",
        "rawPath":"/search",
        "stageVariables":{},
        "requestContext":{
            "timeEpoch":1587750461466,
            "domainPrefix":"search",
            "accountId":"0123456789",
            "stage":"dev",
            "domainName":"search.example.com",
            "apiId":"pb5dg6g3rg",
            "requestId":"LgLpnibOFiAEPCA=",
            "http":{
                "path":"/search",
                "userAgent":"Paw/3.1.10 (Macintosh; OS X/10.15.4) GCDHTTPRequest",
                "method":"GET",
                "protocol":"HTTP/1.1",
                "sourceIp":"91.64.117.86"
            },
            "time":"24/Apr/2020:17:47:41 +0000"
        },
        "isBase64Encoded":false,
        "rawQueryString":"",
        "headers":{
            "host":"search.example.com",
            "user-agent":"Paw/3.1.10 (Macintosh; OS X/10.15.4) GCDHTTPRequest",
            "Content-Type":"application/json",
            "content-length":"0"
        },
        "body":"{\"query\":\"query HeroNameAndFriends { hero { name friends { name } }}\",\"variables\":{}}"
    }' \
  http://localhost:7000/invoke
