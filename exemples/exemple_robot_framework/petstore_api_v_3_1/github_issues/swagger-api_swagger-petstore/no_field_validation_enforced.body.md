`updatePet` documents a 405 "Validation exception" response and `addPet`
documents a 405 "Invalid input" response, but no content-based validation
appears to be enforced for either - an empty `name` (a required field) and a
`status` value outside the documented enum (`available`/`pending`/`sold`)
are both silently accepted with 200, echoed back verbatim.

Repro (accepted with 200, should arguably be a 405 per the spec):
```
curl -X PUT https://petstore31.swagger.io/api/v31/pet -H "Content-Type: application/json" \
  -d '{"name":"","photoUrls":["string"],"id":555000222,"status":"invalid_status_value"}'
```

The only thing that does produce a 4xx is a genuine JSON type mismatch (e.g.
sending `photoUrls` as a string instead of an array) - and that comes back as
400, not the documented 405:
```
curl -X POST https://petstore31.swagger.io/api/v31/pet -H "Content-Type: application/json" \
  -d '{"name":"","photoUrls":""}'
# -> 400: Cannot coerce empty String ("") to element of `java.util.ArrayList`
```

So the documented 405 response for either operation does not appear to be
reachable through any input we tried.
