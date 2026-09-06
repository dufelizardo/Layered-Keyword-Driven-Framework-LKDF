# ViaCEP — LKDF Robot Framework Example

Same Layered Keyword-Driven Framework pattern as the Petstore examples (POM → FLOW → SCENARIO → TEST), targeting **ViaCEP**, the public Brazilian postal code (CEP) lookup API:

- Docs: https://viacep.com.br/
- Host: `https://viacep.com.br` (no OpenAPI/Swagger spec is published — schemas here were derived from the docs and confirmed directly against the live API with curl)

## Why this example is different from the Petstore ones

- **Read-only**: both operations are `GET`, so there's no seed/collision concerns like the Petstore examples have — this one is expected to be fully deterministic.
- **"Not found" is not a distinct HTTP status.** Both endpoints always return `200` for a syntactically valid request — the *body* is what tells you whether something was found:
  - `GET /ws/{cep}/json/`: valid+existing CEP → full address object. Valid but unassigned CEP → **also 200**, body `{"erro": "true"}` (a string, not a boolean). Malformed CEP (wrong length/non-numeric) → `400`, and the body is **HTML**, not JSON.
  - `GET /ws/{uf}/{cidade}/{logradouro}/json/`: match found → `200` with an array of addresses. No match / invalid UF → **also 200**, empty array `[]`. City/street under 3 characters → `400`, HTML body.

Because of this, the dispatcher in each FLOW resource routes by a **scenario name** (`found` / `not_found` / `no_results` / `invalid_format`) instead of by raw HTTP status code like the Petstore examples do. The four LKDF layer responsibilities are unchanged — POM has zero logic, FLOW owns the status/schema assertions, SCENARIO is a pure pass-through, TEST only supplies data — only the *key* used to pick which FLOW keyword to call had to adapt to this API's actual shape.

## Coverage

| Operation | Suite | Scenarios |
|---|---|---|
| `GET /ws/{cep}/json/` | US-025 (`test/cep/get_cep_by_code`) | `found`, `not_found`, `invalid_format` |
| `GET /ws/{uf}/{cidade}/{logradouro}/json/` | US-026 (`test/cep/search_address_by_query`) | `found`, `no_results`, `invalid_format` |

## Structure

```
src/
├── pom/{common, cep/<op>/}          # raw HTTP calls only, zero assertions
├── flow/{common, cep/<op>/}         # per-scenario keywords: status assertion + schema check, and the dispatcher
├── scenario/cep/<op>/               # pure pass-through, zero logic
└── resource/
    ├── config/{driven,schema}/      # single aggregators every test imports
    ├── data_driven/cep/             # negative/edge-case dictionaries
    └── schema/cep/                  # ADDRESS_SCHEMA and CEP_NOT_FOUND_SCHEMA
test/cep/<op>/US-0NN.robot
```

## Running

```bash
./run_tests.sh            # or run_tests.ps1 on Windows — writes to ./results/, forwards extra robot args
./run_tests.sh --dryrun   # syntax/import check only, no real HTTP calls
```

## Status

All 6 test cases pass against the live API as of this writing — unlike the Petstore examples, no `KNOWN_ISSUES.md` was needed here; ViaCEP behaves consistently with its documentation and with the behavior confirmed via curl during development.
