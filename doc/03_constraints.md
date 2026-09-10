# 03 — Constraints (as enforced in this repository)

This page elaborates [`README.md`](../README.md) §4.1's "Four Absolute Structural Prohibitions" with how they actually show up while building the examples in this repo, plus two constraints discovered in practice that the README doesn't cover. Nothing here overrides the README — it's the same rules, with the receipts. The portable, tool-agnostic version of this content lives in [`agent/ARCHITECTURE.md`](../agent/ARCHITECTURE.md) §2–3; this page is the "here's where we actually hit it" companion.

## The Four Absolute Structural Prohibitions, as built

1. **No layer may import a higher layer.** Every `.resource` file's `*** Settings ***` section only ever adds `Resource` lines pointing *down* the stack — a SCENARIO resource imports its FLOW resource, a FLOW resource imports its POM resource and the schema/data-driven aggregators, and POM resources import only `pom/common/`. Grep any `test/` suite in this repo and you'll find it imports exactly one SCENARIO resource, never a FLOW or POM one directly.

2. **SCENARIO never invokes POM directly.** Every SCENARIO keyword in this repo is one line: a call to a single FLOW dispatcher keyword and a `RETURN` of its result. E.g. `exemples/exemple_robot_framework/viacep/src/scenario/cep/get_cep_by_code/get_cep_by_code_scenario.resource`'s `CEP - GET BY CODE - GET` keyword does nothing but call `Cep - Get By Code - By Scenario` from the FLOW layer.

3. **FLOW never touches the driver/HTTP client directly.** No `.resource` file under any example's `src/flow/` imports `RequestsLibrary` or issues a `GET/POST/PUT/DELETE On Session` call itself — that call only ever happens inside a POM resource, which FLOW then invokes by keyword name.

4. **TEST contains no control flow or assertions.** Every `US-0NN.robot` file in this repo is a flat list of `*** Test Cases ***`, each one calling its example's SCENARIO keyword with a `scenario=` value and whatever data the case needs — no `IF`, no `Should Be Equal`, nothing evaluated. If you ever see conditional logic in a test file here, it's a bug to fix, not a pattern to copy.

## Enforcement reality check

`README.md` §4.2 shows a Python `import-linter` (`.importlinter`) config as an illustration of one way to enforce this statically. **No example in this repository runs Python, and there is no `.importlinter` file anywhere in this repo.** Every Robot Framework and Playwright/TypeScript example here enforces the four prohibitions structurally (the folder layout and the `Resource`/`import` graph make the wrong dependency awkward to write) and by review against this page and `agent/ARCHITECTURE.md`, not by a CI static-analysis gate. If this repo ever adds one (an ESLint boundary rule for the Playwright examples, for instance), record it here — until then, don't assume it exists.

## Constraint 5 (not in the README): layer keyword names must never collide

Discovered the hard way while extending this methodology to a new, non-public example, and generalized here because it will recur in any Robot Framework example: **Robot Framework resolves keyword names ignoring case and whitespace.** A POM keyword `GET Proxy Votings` and a SCENARIO keyword `Get Proxy Votings` normalize to the same name — the moment both resources are in scope (which they always are, since SCENARIO transitively imports POM through FLOW), Robot fails every test that calls it with *"Multiple keywords with name '...' found."*

Every public example in this repo already follows the fix — SCENARIO keyword names use a deliberately different phrasing from the POM keyword they front, never a re-cased copy:

| Example | POM keyword | SCENARIO keyword |
| --- | --- | --- |
| `petstore_api_v_2` | `GET Get Pet By Id` | `PET - GET BY ID - GET` |
| `viacep` | `GET Get Cep By Code` | `CEP - GET BY CODE - GET` |

See `agent/ARCHITECTURE.md` §3 for the tool-agnostic version of this rule (it generalizes to "never let two layers' public names collide under your tool's own name-resolution rules," which matters even for tools that *are* case-sensitive, since whitespace/underscore normalization can still bite).

## Constraint 6 (not in the README): scope negative cases to what's actually verifiable

Not a structural prohibition in the same sense as the four above, but enforced the same way (review against this page): a status code or outcome only becomes a test case in this repo when there's a real, data-triggerable, meaningfully differentiable input for it. `petstore_api_v_3_1/KNOWN_ISSUES.md` and every example's coverage table document *why* a given code was or wasn't implemented — an agent adding a new operation should do the same rather than guessing a case just to round out a set of status codes.
