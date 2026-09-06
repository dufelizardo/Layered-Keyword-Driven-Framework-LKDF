# Petstore API v3.1 — LKDF Robot Framework Example

Same Layered Keyword-Driven Framework pattern as [`petstore_api_v_2`](../petstore_api_v_2), targeting the real **Swagger Petstore OpenAPI 3.1** reference server:

- Docs: https://petstore31.swagger.io/#/
- Spec: https://petstore31.swagger.io/api/v31/openapi.json
- Host: `https://petstore31.swagger.io/api/v31`

## Coverage

Unlike the v2 demo, this OpenAPI 3.1 reference server only documents **3 operations, all under the `pet` tag** — there is no `store` or `user` here:

| Operation | Suite | Path |
|---|---|---|
| updatePet (PUT /pet) | US-002 | `test/pet/update_pet` |
| addPet (POST /pet) | US-023 | `test/pet/add_pet` |
| getPetById (GET /pet/{petId}) | US-024 | `test/pet/get_pet_by_id` |

`US-002` predates this repo's v2 example and was migrated here (host + structure corrected, `addPet`/`getPetById` added new); `US-023`/`US-024` continue the global suite numbering used across every Robot Framework example in this repo.

The `Pet` schema in this version genuinely includes `availableInstances`, `petDetailsId` and `petDetails` (a nested `PetDetails{id, category, tag}` object) on top of the classic fields — these are real fields in the OpenAPI 3.1 spec, not present in the v2 example.

## Structure

Same layering as `petstore_api_v_2` (see that README for the general shape), scoped down to a single `pet/` resource group since that's all this server has:

```
src/
├── pom/{common, pet/<op>/}
├── flow/{common, pet/<op>/}
├── scenario/pet/<op>/
└── resource/{config, data_driven/pet, schema/pet}
test/pet/<op>/US-0NN.robot
```

## Running

```bash
./run_tests.sh            # or run_tests.ps1 on Windows — writes to ./results/, forwards extra robot args
./run_tests.sh --dryrun   # syntax/import check only, no real HTTP calls
```

## Known limitations — read this before trusting a red/green result

This live server has real, confirmed bugs that shape how the tests are written. Full detail in `KNOWN_ISSUES.md`, short version:

1. **`PUT /pet` crashes with HTTP 500 the second time you update the same `id`** — it only works once, as an implicit create. `update_pet_flow.resource` generates a fresh random id on every call specifically to dodge this; a genuine "update an existing record" scenario is not testable against this server.
2. **No field-level validation is enforced** — an empty required `name` or an out-of-enum `status` is silently accepted with `200`. Only a JSON *type* mismatch (e.g. `photoUrls` as a string) is rejected, and it comes back as `400`, not the documented `405`.
3. **`GET /pet/{petId}`'s documented `petId` range (`exclusiveMinimum: 1, exclusiveMaximum: 10`) isn't enforced**, and a nonexistent id returns `400` rather than the documented `404`.

None of the above are defects in this suite — each was produced by a correctly-written, passing assertion. Three ready-to-submit upstream issue drafts for these are in `github_issues/swagger-api_swagger-petstore/` (not yet filed — see that folder's `README.md`).
