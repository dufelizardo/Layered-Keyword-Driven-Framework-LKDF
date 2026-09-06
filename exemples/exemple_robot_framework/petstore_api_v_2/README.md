# Petstore API v2 — LKDF Robot Framework Example

A full-surface example of the Layered Keyword-Driven Framework (POM → FLOW → SCENARIO → TEST), targeting the classic **Swagger Petstore v2** public demo:

- Docs: https://petstore.swagger.io/#/
- Spec: https://petstore.swagger.io/v2/swagger.json
- Host: `https://petstore.swagger.io/v2`

## Coverage

All 20 documented operations across the three tags, one Robot Framework test suite (`US-0NN`) each:

| Tag | Operation | Suite | Path |
|---|---|---|---|
| pet | updatePet | US-003 | `test/pet/update_pet` |
| pet | addPet | US-004 | `test/pet/add_pet` |
| pet | uploadFile | US-005 | `test/pet/upload_file` |
| pet | findPetsByStatus | US-006 | `test/pet/find_by_status` |
| pet | findPetsByTags | US-007 | `test/pet/find_by_tags` |
| pet | getPetById | US-008 | `test/pet/get_pet_by_id` |
| pet | updatePetWithForm | US-009 | `test/pet/update_pet_with_form` |
| pet | deletePet | US-010 | `test/pet/delete_pet` |
| store | placeOrder | US-011 | `test/store/place_order` |
| store | getInventory | US-012 | `test/store/get_inventory` |
| store | getOrderById | US-013 | `test/store/get_order_by_id` |
| store | deleteOrder | US-014 | `test/store/delete_order` |
| user | createUser | US-015 | `test/user/create_user` |
| user | createUsersWithArrayInput | US-016 | `test/user/create_users_with_array_input` |
| user | createUsersWithListInput | US-017 | `test/user/create_users_with_list_input` |
| user | loginUser | US-018 | `test/user/login_user` |
| user | logoutUser | US-019 | `test/user/logout_user` |
| user | getUserByName | US-020 | `test/user/get_user_by_name` |
| user | updateUser | US-021 | `test/user/update_user` |
| user | deleteUser | US-022 | `test/user/delete_user` |

Each suite has one `CT-00N` test case per HTTP status code the operation actually documents (a `200` happy path is always included even where the spec omits it, matching observed live-server behavior).

## Structure

```
src/
├── pom/                      # raw HTTP calls only, zero assertions
│   ├── common/                   shared session bootstrap (Get Petstore V2 Session)
│   └── {pet,store,user}/<op>/    one *_pom.resource per operation
├── flow/                      # payload builders, dispatch-by-status-code, assertions, schema checks
│   ├── common/                   shared schema_validation_flow.resource (4 generic Validate* keywords)
│   └── {pet,store,user}/<op>/
├── scenario/                  # pure pass-through, zero logic
│   └── {pet,store,user}/<op>/
└── resource/
    ├── config/{driven,schema}/   single aggregators every test imports
    ├── data_driven/{pet,store,user}/   negative-case dictionaries, grounded in the OpenAPI spec
    └── schema/{pet,store,user}/        response schemas (Pet/Order/User/ApiResponse) for Validate Object/Array Schema
test/
└── {pet,store,user}/<op>/US-0NN.robot
```

Endpoints requiring a specific id/username (`get_pet_by_id`, `delete_pet`, `get_order_by_id`, `delete_order`, `get_user_by_name`, `update_user`, `delete_user`) seed a fresh resource via the corresponding create-operation's FLOW when no id is supplied, so the `200` case always has something real to act on rather than a hardcoded id that may no longer exist on the shared public server.

## Running

```bash
./run_tests.sh            # or run_tests.ps1 on Windows — writes to ./results/, forwards extra robot args
./run_tests.sh --dryrun   # syntax/import check only, no real HTTP calls
```

VSCode's "Run Test" CodeLens uses a different, repo-wide output path — see `.vscode/launch.json` at the repo root.

## Known limitations

`petstore.swagger.io` is a real, shared, public demo instance with no reset between runs and only loose validation. `KNOWN_ISSUES.md` documents two confirmed discrepancies the schema-validation layer caught between the live server and its own documented spec (not defects in this suite). Negative test cases (400/404/405) are built from real spec rules but frequently still return `200` in practice, since the server doesn't enforce most of them — this is expected and called out where relevant, not a bug to fix.

Two findings from `KNOWN_ISSUES.md` have ready-to-submit upstream issue drafts in `github_issues/swagger-api_swagger-petstore/` (not yet filed — see that folder's `README.md`).
