# ViaCEP — LKDF Playwright (TypeScript) Example

Same Layered Keyword-Driven Framework pattern as the [Robot Framework ViaCEP example](../../exemple_robot_framework/viacep), reimplemented in **Playwright Test (TypeScript)**, targeting the same public API:

- Docs: https://viacep.com.br/
- Host: `https://viacep.com.br`

This example exists to prove, not just claim, one of the LKDF's central points: the same 4-layer architecture survives a tool change. **POM is the only layer that changed meaningfully** (Robot's `RequestsLibrary` → Playwright's `APIRequestContext`) — FLOW and SCENARIO carry the exact same responsibilities and dispatch logic, just in TypeScript syntax. Same 2 operations, same 6 scenarios (`US-025`/`US-026`, same IDs as the Robot Framework version — same business requirement, second implementation), same result: 6/6 passing against the live API.

No browser is used or installed — ViaCEP has no UI, so these tests use Playwright's `request` (`APIRequestContext`) API-testing feature only.

## Layer equivalence with the Robot Framework version

| Layer | Robot Framework | Playwright (this example) | Responsibility (unchanged) |
|---|---|---|---|
| POM | `src/pom/**/*.resource` | `src/pom/**/*.pom.ts` | Raw HTTP call only, zero assertions |
| FLOW | `src/flow/**/*.resource` | `src/flow/**/*.flow.ts` | Payload/response handling, status + schema assertions, scenario dispatch |
| SCENARIO | `src/scenario/**/*.resource` | `src/scenario/**/*.scenario.ts` | Pure pass-through, zero logic |
| TEST | `test/**/*.robot` | `tests/**/*.spec.ts` | Data only — which scenario, which input |

**One deliberate structural difference**: there's no `resource/config/{driven,schema}` aggregator pair here. That pattern existed in the Robot version specifically to work around Robot Framework's flat, global variable namespace (every test imports one aggregator, so every dictionary needs a unique prefixed name). TypeScript's module system has no such problem — every file `import`s exactly what it needs by name — so the aggregator indirection is simply unnecessary here. Dropping it is an adaptation to the tool, not a departure from the architecture.

**One deliberate improvement enabled by the tool**: the scenario dispatch key (`'found' | 'not_found' | 'invalid_format'`) is a TypeScript union type, not a free string like in Robot. An invalid scenario name is a compile-time error here, not a runtime `Fail`.

## Why scenario-based dispatch (not pure HTTP status)

Neither ViaCEP endpoint uses a distinct HTTP status for "found" vs "not found" — both always return `200`, and only the response *body* differs:

- `GET /ws/{cep}/json/`: existing CEP → full address object (200). Valid-but-unassigned CEP → `{"erro": "true"}` (also 200). Malformed CEP → `400`, HTML body (not JSON).
- `GET /ws/{uf}/{cidade}/{logradouro}/json/`: match → array of addresses (200). No match → empty array (also 200). City/street under 3 characters → `400`, HTML body.

So each FLOW module's dispatcher routes by a scenario name instead of by status code alone — matching exactly what the Robot Framework version does for the same reason.

## Running

```bash
cd exemples/exemple_playwright/viacep   # important - see note below
npm install        # no `npx playwright install` needed - no browser is used
npx playwright test
```

Or, from anywhere in the repo: `./exemples/exemple_playwright/viacep/run_tests.sh` (or `run_tests.ps1` on Windows) - it `cd`s into this folder for you before running.

**Why the `cd` matters**: running `npx playwright test` from outside this folder (e.g. the repo root, which has no `@playwright/test` install of its own) makes `npx` silently download a separate, possibly newer, globally-cached copy of `playwright` to run the CLI with — while your test files still import the *locally installed* `@playwright/test`. Playwright detects the two different module instances and fails with "Playwright Test did not expect test.describe() to be called here." Always run from inside this directory (or use the wrapper script above).

HTML report and raw results are written to `results/playwright-report` and `results/test-results` respectively (gitignored, same convention as every other example in this repo).

## Status

All 6 test cases pass against the live API as of this writing.
