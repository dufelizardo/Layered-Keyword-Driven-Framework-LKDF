The Pet schema declares `name` and `photoUrls` as required:

    "required": ["name", "photoUrls"]

But GET /pet/findByStatus?status=available on the live demo server
(https://petstore.swagger.io/v2) currently returns at least one Pet object
without a `name` field at all.

Repro:
GET https://petstore.swagger.io/v2/pet/findByStatus?status=available
-> inspect the array for an entry missing "name"

This is likely caused by some other client having POSTed a Pet without `name`
(the server doesn't seem to enforce the required-field constraint on write),
and it's now surfaced by this read endpoint in violation of the documented schema.
