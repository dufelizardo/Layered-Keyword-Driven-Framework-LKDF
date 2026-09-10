# 06 — Example Catalog

This is an index, not a duplicate: each example carries its own `README.md` with full detail (coverage table, structure, how to run it, and — where applicable — a `KNOWN_ISSUES.md` of real discrepancies found against the live server). This page exists so an agent or a reader can find the right one quickly, per [`AGENTS.md`](../AGENTS.md) §1.4.

Every example listed here is public and self-contained (no cross-example imports). Suite IDs (`US-0NN`) are numbered globally across the whole repository, not reset per example — see the numbering note under each entry.

## Robot Framework

### `petstore_api_v_2` — [README](../exemples/exemple_robot_framework/petstore_api_v_2/README.md)

The largest and first-built example, targeting the classic public **Swagger Petstore v2** demo server (`https://petstore.swagger.io/v2`). All 20 documented operations across `pet`, `store`, and `user`, one suite each (`US-003`–`US-022`). Established every convention later examples reuse: the `common/` session resource, the `resource/config/{driven,schema}` aggregator pair, the seed-data pattern for id-based lookups. Has a `KNOWN_ISSUES.md` and drafted (unfiled) GitHub issue writeups for real discrepancies found by testing live.

### `petstore_api_v_3_1` — [README](../exemples/exemple_robot_framework/petstore_api_v_3_1/README.md)

Same pattern, migrated to target the real **OpenAPI 3.1** reference server (`https://petstore31.swagger.io/api/v31`) instead of the v2 demo. Only 3 operations are documented there, all under `pet`: `US-002` (pre-dates this repo's v2 example, migrated in place), `US-023`, `US-024` (continue the global sequence). Has its own `KNOWN_ISSUES.md` — three confirmed live-server bugs (a 500 on `PUT` with an existing id, unenforced field validation, an unenforced numeric range), each worked around in the suite's own request construction rather than "fixed" by loosening the assertion.

### `viacep` (Robot Framework) — [README](../exemples/exemple_robot_framework/viacep/README.md)

Targets the public Brazilian postal-code lookup API ViaCEP (`https://viacep.com.br`), which has no published OpenAPI/Swagger spec — every schema here was derived from ViaCEP's docs and confirmed with `curl` against the live API. Two operations, `US-025` (get by CEP code) and `US-026` (search by address), 3 scenarios each. No `KNOWN_ISSUES.md` — nothing wrong was found.

**Architecturally notable**: neither endpoint uses a distinct HTTP status for "not found" — both always return `200`, and only the response body differs (an `{"erro": "true"}` object, or an empty array). The FLOW dispatcher in this example therefore routes on a **scenario name** (`found` / `not_found` / `no_results` / `invalid_format`) instead of a raw status code — see `agent/ARCHITECTURE.md` §4 for this as a general pattern. The four layer responsibilities themselves are unchanged; only the dispatch key adapted to what this API actually does.

## Playwright (TypeScript)

### `viacep` (Playwright) — [README](../exemples/exemple_playwright/viacep/README.md)

A second implementation of the exact same two operations and six scenarios as the Robot Framework ViaCEP example, in Playwright Test/TypeScript, deliberately reusing the same suite IDs (`US-025`/`US-026`) rather than issuing new ones — same business requirement, second tool. Built specifically to prove, not just claim, that the LKDF architecture survives a tool change: only the POM layer's implementation is genuinely tool-specific (Robot's `RequestsLibrary` vs. Playwright's `APIRequestContext`); FLOW and SCENARIO carry the identical responsibilities and dispatch logic.

Two adaptations worth reading about in its README: it drops the Robot version's `resource/config/{driven,schema}` aggregator pair entirely (that pattern exists only to work around Robot's flat global variable namespace — TypeScript's module imports don't have that problem), and its FLOW dispatcher's scenario key is a TypeScript union type rather than a free-form string, catching an invalid scenario name at compile time instead of runtime.

## Suite ID sequence so far

| Range | Example |
| --- | --- |
| US-002 | `petstore_api_v_3_1` (pre-dates this catalog, migrated in place) |
| US-003–US-022 | `petstore_api_v_2` |
| US-023–US-024 | `petstore_api_v_3_1` |
| US-025–US-026 | `viacep` (Robot Framework and Playwright — same IDs, two tools) |

When adding a new example or operation, continue this sequence — see `agent/IMPLEMENTATION.md` §1.
