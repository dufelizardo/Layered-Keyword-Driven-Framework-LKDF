# Known issues found against the live Petstore OpenAPI 3.1 demo server

This file documents real discrepancies between the official OpenAPI 3.1 spec
(`https://petstore31.swagger.io/api/v31/openapi.json`) and the actual behavior
of the public demo server (`https://petstore31.swagger.io`), discovered while
building and running this example. As with `petstore_api_v_2`'s
`KNOWN_ISSUES.md`, every finding below came from a passing, correctly-written
test whose assertion caught a real mismatch - not a defect in this suite.

---

## 1. `PUT /pet` returns HTTP 500 when updating a Pet id that already exists

- **Suite**: `test/pet/update_pet/US-002.robot`
- **Spec**: `PUT /pet` (`updatePet`) documents 200/400/404/405 - no crash is documented for any input.
- **Expected**: updating an existing pet returns 200 with the updated Pet.
- **Actual**: the very first `PUT` for a given `id` succeeds (200, effectively a create).
  Every subsequent `PUT` for that *same* `id` returns:
  ```
  Internal Server Error: Unexpected error
  ```
  with HTTP 500. Confirmed directly with curl - ids that are "famous" test
  values almost certainly already claimed by other users of this shared
  public server (`0`, `1`, `10`, `999999999`) crash immediately; a
  freshly-chosen large random id succeeds once and then crashes on every
  later attempt to update it again.
- **Repro**:
  ```
  curl -X PUT https://petstore31.swagger.io/api/v31/pet -H "Content-Type: application/json" \
    -d '{"name":"doggie","photoUrls":["string"],"id":555000111}'   # -> 200, creates it
  curl -X PUT https://petstore31.swagger.io/api/v31/pet -H "Content-Type: application/json" \
    -d '{"name":"doggie","photoUrls":["string"],"id":555000111}'   # -> 500, same id again
  ```
- **Impact**: `updatePet` cannot actually update an existing pet without
  crashing - its only reliable use is as a one-shot create. This repo's
  `update_pet_flow.resource` works around it by generating a fresh random id
  on every call (`Generate Fresh Pet Id`), which is why the 200 test case
  passes reliably while a genuine "update an existing record" scenario is
  untestable against this server.
- **Side effect on this suite's 404 case**: the `update_pet_nonexistent_id_404`
  test data (`id=999999999`) also hits this bug (that id has clearly already
  been claimed by another user historically), so CT-003 fails with 500
  instead of the documented 404 - it is not possible to reliably test "Pet
  not found" via `updatePet` against this shared server for the same reason.

## 2. No field-level validation is enforced on `PUT /pet` / `POST /pet` beyond type-checking

- **Suites**: `test/pet/update_pet/US-002.robot` (CT-004), `test/pet/add_pet/US-023.robot` (CT-002)
- **Spec**: `updatePet` documents 405 "Validation exception"; `addPet` documents 405 "Invalid input".
- **Expected**: an empty `name` (required field) or a `status` value outside
  the documented enum (`available`/`pending`/`sold`) triggers a 405.
- **Actual**: both are silently accepted with HTTP 200 - the server echoes
  back `"name": ""` and `"status": "invalid_status_value"` verbatim, no
  validation error at all.
- **What does actually get rejected**: a genuine JSON *type* mismatch, e.g.
  sending `photoUrls` as a string instead of an array:
  ```
  curl -X POST https://petstore31.swagger.io/api/v31/pet -H "Content-Type: application/json" \
    -d '{"name":"","photoUrls":""}'
  ```
  returns **400** (not 405), with a Jackson deserialization error:
  `Cannot coerce empty String ("") to element of java.util.ArrayList`.
- **Impact**: the documented 405 "validation" responses are not reachable
  through any content-based negative input we tried; the only way to reach a
  4xx at all is a type mismatch, and it comes back as 400, not 405.

## 3. `GET /pet/{petId}` does not enforce its own documented `petId` range

- **Suite**: `test/pet/get_pet_by_id/US-024.robot`
- **Spec**: the `petId` path parameter is documented with
  `exclusiveMinimum: 1, exclusiveMaximum: 10` (only 2-9 are valid) and a 400
  "Invalid ID supplied" response for violations.
- **Expected**: `petId=1` (on the excluded boundary) returns 400.
- **Actual**: `petId=1` returns **200** with a valid Pet body - the boundary
  is not enforced.
- **Expected** (404 case): a very large, presumably nonexistent id
  (`999999999`) returns 404 "Pet not found".
- **Actual**: returns **400** "Invalid ID supplied" instead - the server
  appears to apply *some* upper-bound sanity check that isn't the documented
  `exclusiveMaximum: 10`, and never actually returns 404 for the values tried.
- **Repro**:
  ```
  curl https://petstore31.swagger.io/api/v31/pet/1            # -> 200, expected 400 per spec
  curl https://petstore31.swagger.io/api/v31/pet/999999999    # -> 400, expected 404 per spec
  ```

---

## Reporting upstream

All three findings are reproducible against the public demo. Ready-to-submit
issue drafts for `swagger-api/swagger-petstore` live in
`github_issues/swagger-api_swagger-petstore/` (same convention as
`petstore_api_v_2`) - not yet filed, since `gh` was not available when this
was authored. See `github_issues/README.md` for the exact submission steps.
