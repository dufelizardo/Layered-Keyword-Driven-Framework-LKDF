`PUT /pet` (updatePet) returns HTTP 500 whenever the request's `id` matches
a pet that already exists. The very first PUT for a given id succeeds
(effectively a create); every subsequent PUT for that same id crashes.

Repro:
```
curl -X PUT https://petstore31.swagger.io/api/v31/pet -H "Content-Type: application/json" \
  -d '{"name":"doggie","photoUrls":["string"],"id":555000111}'   # -> 200, creates it

curl -X PUT https://petstore31.swagger.io/api/v31/pet -H "Content-Type: application/json" \
  -d '{"name":"doggie","photoUrls":["string"],"id":555000111}'   # -> 500, same id again
```

Response body on the failing call:
```
Internal Server Error: Unexpected error
```

Expected: a 200 with the updated Pet (or, if the id doesn't exist, a
documented 404). Actual: a 500 with no useful detail, for an operation whose
entire purpose is to update an existing record.

This also means well-known small ids (0, 1, 10) and other "obvious" test
values like 999999999 crash immediately, since they've almost certainly
already been created by other users of this shared public demo.
