TITLE: GET /pet/findByStatus can return Pet objects missing the required `name` field

TARGET REPO: swagger-api/swagger-petstore

STATUS: Not yet submitted. To submit once `gh` is available and authenticated:

    gh issue create --repo swagger-api/swagger-petstore \
      --title "GET /pet/findByStatus can return Pet objects missing the required \`name\` field" \
      --body-file findbystatus_missing_required_name.body.md

---
BODY (also saved separately as findbystatus_missing_required_name.body.md):

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
