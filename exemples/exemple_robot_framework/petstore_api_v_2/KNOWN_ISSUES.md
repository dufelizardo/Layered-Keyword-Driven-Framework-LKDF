# Known issues found against the live Petstore v2 demo server

This file documents real discrepancies between the official OpenAPI spec
(`https://petstore.swagger.io/v2/swagger.json`) and the actual behavior of the
public demo server (`https://petstore.swagger.io`), discovered while building
and running the `petstore_api_v_2` example. These are not defects in this
test suite — every finding below was produced by a passing, correctly-written
test whose assertion caught a real mismatch. They're recorded here so the
suite's "expected" failures are distinguishable from regressions.

---

## 1. `GET /user/login` returns an object, not the documented string

- **Suite**: `test/user/login_user/US-018.robot` (CT-001)
- **Spec** (`paths./user/login.get.responses.200`):
  ```json
  {"description":"successful operation","schema":{"type":"string"}}
  ```
- **Expected**: response body is a plain JSON string, e.g. `"logged in user session:..."`.
- **Actual**: response body is a JSON object shaped like `ApiResponse`:
  ```json
  {"code": 200, "type": "unknown", "message": "logged in user session:1788698084010"}
  ```
- **Repro**: `GET https://petstore.swagger.io/v2/user/login?username=lkdf_user&password=Password123`
- **Impact**: any client coded strictly against the documented `string` schema
  (e.g. `response.text` as a token) would receive an object instead and likely
  mishandle it.
- **Where it's enforced in this repo**: `src/flow/user/login_user/login_user_flow.resource`,
  keyword `GET Login User - Status Code 200`, via `Validate Non Empty String`
  (`src/flow/common/schema_validation_flow.resource`). Left failing on
  purpose — the schema was not "corrected" to match the server, since doing
  so would defeat the point of contract validation.

## 2. `GET /pet/findByStatus` can return Pet objects missing the required `name` field

- **Suite**: `test/pet/find_by_status/US-006.robot` (CT-001)
- **Spec** (`definitions.Pet.required`): `["name", "photoUrls"]`
- **Expected**: every Pet object in the array has a non-null `name`.
- **Actual**: at least one Pet returned for `status=available` on the shared
  public server is missing `name` entirely.
  ```
  Schema validation failed: ['missing required field: name']
  ```
- **Repro**: `GET https://petstore.swagger.io/v2/pet/findByStatus?status=available`,
  inspect the returned array for an entry without a `name` key.
- **Likely cause**: this is a shared, publicly-writable demo server — some
  other consumer almost certainly created a Pet via `POST /pet` without
  supplying the (documented-as-required-but-not-server-enforced) `name`
  field, and it was persisted and is now surfaced by this read endpoint.
- **Where it's enforced in this repo**: `src/flow/pet/find_by_status/find_by_status_flow.resource`,
  keyword `GET Find Pets By Status - Status Code 200`, via `Validate Array Schema`
  → `Validate Object Schema` against `${PET_SCHEMA}`.

---

## Reporting upstream

Both findings are reproducible against the public demo and are reasonable
candidates to report to the maintainers of the hosted Swagger Petstore
instance (`swagger-api/swagger-petstore` on GitHub). Ready-to-submit issue
drafts (title + body, and the exact `gh issue create` command) live in
`github_issues/swagger-api_swagger-petstore/` — they haven't been filed yet
because `gh` wasn't available in the environment that authored them. See
`github_issues/README.md` for the submission steps.
