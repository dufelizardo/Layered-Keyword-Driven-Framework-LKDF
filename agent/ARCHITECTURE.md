# LKDF Architecture — Operational Contract for AI Agents

> **Portability note:** this file is written to be copied into any project, alongside `IMPLEMENTATION.md`, and still be usable on its own. It does not assume any specific repository's file layout exists. Where it needs a concrete example, it shows one inline rather than pointing at a path that might not exist wherever this file has been copied to.

This file does not define new architecture. It restates the LKDF rules — as defined in this framework's `README.md` — in terms concrete enough for an AI agent to apply without inventing an implementation. If anything here ever conflicts with `README.md`, `README.md` wins.

## 1. The four layers

LKDF organizes any automated check into four layers, with a **strict downward dependency**: `TEST → SCENARIO → FLOW → POM`. No layer may import, call, or know about a layer above it. Bypassing an intermediate layer (e.g. TEST calling FLOW directly, or SCENARIO calling POM directly) is not a style violation — it is an architectural failure.

| Layer | Single responsibility | You add code here when... | Never put this here |
| --- | --- | --- | --- |
| **TEST** | Parameterize test execution variants. | ...appending a data variation, a new profile, or an environment key. | `if/else`, loops, business assertions, technical selectors. |
| **SCENARIO** | Orchestrate the macro-level user journey. | ...the macro user/business workflow itself changes. | Hardcoded data, functional validation assertions, exception handling. |
| **FLOW** | Process domain logic and assertions. | ...business logic, calculations, or functional criteria evolve. | UI selectors, raw URLs, direct driver/HTTP-client access. |
| **POM** | Abstract and isolate technical infrastructure. | ...a UI layout, element id, DB schema, or API contract changes. | Cross-cutting business rules, domain validation, logical routing/branching on business meaning. |

Mental model: **TEST = Variance. SCENARIO = Structure. FLOW = Logic. POM = Technical Execution.**

### 1.1 What each layer looks like, concretely (API testing, Robot Framework)

Robot Framework is the reference realization used throughout this document because it is this methodology's primary implementation today. The mapping to any other tool is mechanical — see §6.

**Physical layout.** Each operation gets its own directory, replicated in parallel across all four layers, named after the operation (snake_case), nested under a resource-group directory named after the API tag/resource it belongs to:

```
src/pom/<resource-group>/<operation>/<operation>_pom.resource
src/flow/<resource-group>/<operation>/<operation>_flow.resource
src/scenario/<resource-group>/<operation>/<operation>_scenario.resource
test/<resource-group>/<operation>/<suite-id>.robot
```

e.g. `src/pom/pet/get_pet_by_id/get_pet_by_id_pom.resource`, mirrored as `src/flow/pet/get_pet_by_id/get_pet_by_id_flow.resource`, `src/scenario/pet/get_pet_by_id/get_pet_by_id_scenario.resource`, `test/pet/get_pet_by_id/<suite-id>.robot`. Each example also has one `src/pom/common/` and one `src/flow/common/` (§5) that every operation under it imports.

A module-based tool (TypeScript, Python, ...) doesn't need the directory nesting — one flatly-named file per operation per layer is enough, since the module system already prevents naming collisions across operations (e.g. `src/pom/cep/getCepByCode.pom.ts`, `src/flow/cep/getCepByCode.flow.ts`). Use whichever your tool actually needs to stay collision-free; the point is one-operation-in-one-place, replicated identically across all four layers, not the directory depth itself.

**Formatting.** Every Robot Framework file in this methodology uses a long horizontal rule of the box-drawing character `═` (U+2550) — a `#`, a space, then 118 repetitions of `═` — as a visual separator: once after each `*** Settings ***`/`*** Variables ***`/`*** Comments ***`/`*** Keywords ***` section header, and once after every individual keyword's body, before the next keyword starts. This is a style convention, not an architectural rule — a file that skips it is still architecturally correct — but every example in this methodology applies it consistently, so replicate it, as shown in the four layer examples below.

**POM** — one `.resource` file per operation. Every keyword is a raw technical call and returns the raw response. No assertion keyword (`Should Be Equal`, `Should Contain`, ...) ever appears here.

```robotframework
*** Keywords ***
GET Get Widget By Id
    [Arguments]    ${widget_id}
    Get My Api Session
    ${response}=    GET On Session    my_api_session    ${BASE_URL}/widgets/${widget_id}    expected_status=ANY
    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
```

**FLOW** — one keyword *per scenario* (not per operation), each building whatever the request needs and asserting the result. Plus exactly one dispatcher keyword per operation that routes to the right scenario keyword.

```robotframework
*** Keywords ***
GET Get Widget By Id - Success
    [Arguments]    ${widget_id}
    ${response}=    GET Get Widget By Id    ${widget_id}
    Should Be Equal As Integers    ${response.status_code}    200
    Validate Object Schema    ${response.json()}    ${WIDGET_SCHEMA}
    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

GET Get Widget By Id - Not Found
    ${response}=    GET Get Widget By Id    999999999
    Should Be Equal As Integers    ${response.status_code}    404
    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

GET Get Widget By Id By Scenario
    [Arguments]    ${scenario}    ${widget_id}=${EMPTY}
    IF    '${scenario}' == 'success'
        ${response}=    GET Get Widget By Id - Success    ${widget_id}
    ELSE IF    '${scenario}' == 'not_found'
        ${response}=    GET Get Widget By Id - Not Found
    ELSE
        Fail    Unknown scenario: ${scenario}
    END
    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
```

**SCENARIO** — one keyword per operation, a pure one-line pass-through to the FLOW dispatcher. No logic, no HTTP call, no assertion.

```robotframework
*** Keywords ***
WIDGETS - GET BY ID
    [Arguments]    ${scenario}    ${widget_id}=${EMPTY}
    ${response}=    GET Get Widget By Id By Scenario    scenario=${scenario}    widget_id=${widget_id}
    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
```

**TEST** — one suite per operation, one test case per scenario, data only. The suite carries a `Metadata` block identifying it, and each test case is named `CT-00N - <suite-id>: Validate <Operation> - <scenario>` with a `[Tags]` line (operation, resource, scenario). **This naming is functional, not cosmetic: it is what makes a test case traceable back to the specific user story/requirement it verifies.** `US-0NN` is the requirement id, `CT-00N` is which case within it — anyone reading a failing test name, a report, or a requirements tracker should be able to walk from one to the other without opening the file. Never invent an ad hoc test name that drops this pairing:

```robotframework
*** Settings ***
Resource    ../../../src/scenario/widgets/get_widget_by_id/get_widget_by_id_scenario.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
Metadata    Test Suite - US-0NN
Metadata    Test Suite Description        This test suite validates the GET widget by id endpoint.
Metadata    Test Suite Owner              <owner name>
Metadata    Test Suite Version            1.0
Metadata    Test Suite Tags               GET    GetWidgetById    US-0NN
Metadata    Test Suite Created On         <YYYY-MM-DD>
Metadata    Test Suite Last Modified      XXXX-XX-XX
Metadata    Project                       <project name>
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Test Cases ***
CT-001 - US-0NN: Validate GET Get Widget By Id - Success
    [Documentation]    Test case to validate the GET widget by id endpoint with a valid id.
    [Tags]    GET    GetWidgetById    Success
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    WIDGETS - GET BY ID    scenario=success    widget_id=42
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

CT-002 - US-0NN: Validate GET Get Widget By Id - Not Found
    [Documentation]    Test case to validate the GET widget by id endpoint with a nonexistent id.
    [Tags]    GET    GetWidgetById    NotFound
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    WIDGETS - GET BY ID    scenario=not_found
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
```

`Test Suite Last Modified` is conventionally left as the literal placeholder `XXXX-XX-XX` — every example in this methodology does this; it is not a mistake to fix.

### 1.2 The same pattern for a UI story (not just API)

**A story dictates content, never structure.** A "Login" story gets exactly the same physical layout, formatting, `Metadata`/`CT`/`US` naming, and four-layer split as an API operation does — the only thing that changes is what POM actually touches (browser elements instead of an HTTP session) and what FLOW actually asserts (page state instead of a response body). Do not let the target type (UI, API, DB, CLI, ...) change the shape of the solution — only its content. Every example built under this methodology so far happens to be API-only, so here is the UI shape made explicit rather than left to inference from the README's abstract table:

```robotframework
# src/pom/login/perform_login/perform_login_pom.resource — raw element interaction only, zero assertions
*** Keywords ***
Fill Username Field
    [Arguments]    ${username}
    Input Text    css:input[name="username"]    ${username}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Fill Password Field
    [Arguments]    ${password}
    Input Text    css:input[name="password"]    ${password}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Click Login Button
    Click Element    id:btn-login
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
```

```robotframework
# src/flow/login/perform_login/perform_login_flow.resource — the business rule + assertion, same responsibility as an API FLOW
*** Keywords ***
Perform Login - Success
    [Arguments]    ${username}=user.enterprise@company.com    ${password}=SecurePassword123!
    Fill Username Field    ${username}
    Fill Password Field    ${password}
    Click Login Button
    Wait Until Location Is    ${DASHBOARD_URL}
    RETURN    ${DASHBOARD_URL}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Perform Login - Invalid Credentials
    Fill Username Field    user.enterprise@company.com
    Fill Password Field    wrong-password
    Click Login Button
    Wait Until Element Is Visible    css:.error-message
    RETURN    ${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Perform Login By Scenario
    [Arguments]    ${scenario}
    IF    '${scenario}' == 'success'
        Perform Login - Success
    ELSE IF    '${scenario}' == 'invalid_credentials'
        Perform Login - Invalid Credentials
    ELSE
        Fail    Unknown scenario: ${scenario}
    END
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
```

```robotframework
# src/scenario/login/perform_login/perform_login_scenario.resource — pure pass-through, same as any API SCENARIO
*** Keywords ***
LOGIN - PERFORM LOGIN
    [Arguments]    ${scenario}
    Perform Login By Scenario    scenario=${scenario}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
```

The TEST layer is identical in shape to §1.1's: a `Metadata` block, `CT-00N - US-0NN: Validate ...` test case names, `[Tags]`, data only — `CT-001 - US-0NN: Validate Perform Login - Success` calling `LOGIN - PERFORM LOGIN    scenario=success`, and so on. Nothing about the TEST or SCENARIO layer's *shape* changed from the API example — only POM's technical vocabulary (element locators instead of HTTP calls) and FLOW's assertion target (page state instead of a response object) did. That is the entire point: replicate the pattern for whatever the story asks for, not just for API stories.

## 2. The Four Absolute Structural Prohibitions

These are not guidelines — treat a violation of any of these as a build-breaking error, the same way `README.md` §4.1 does:

1. **No layer may import or reference a layer above it.** Dependency direction is `TEST → SCENARIO → FLOW → POM`, always downward.
2. **SCENARIO may never invoke POM directly.** Every technical call goes through FLOW.
3. **FLOW may never touch a driver, HTTP client, or raw network/DB connection directly.** That is POM's exclusive territory; FLOW only calls POM keywords/functions.
4. **TEST may never contain control flow or assertions.** A TEST file is a data provider, nothing else — if you find yourself writing `IF`/`if` or an assertion in a test file, that logic belongs in FLOW.

`README.md` illustrates enforcement with a Python `import-linter` config as one possible mechanism. Do not assume that tool exists in the project you're working in — check first. In most LKDF implementations today (including every Robot Framework and Playwright example this methodology has produced so far), enforcement is **structural and reviewed, not statically linted**: the folder layout itself makes the wrong import awkward to write, and violations get caught in review against this table. If the project you're in does have a static enforcement tool (an import linter, an ESLint boundary rule, etc.), respect it — but don't assume you need to install one to comply with LKDF.

## 3. Naming rule: layers must never collide by name

Every tool resolves function/keyword names by *some* normalization rule, and it's rarely exactly "case-sensitive, whitespace-sensitive exact match." If a POM keyword and the SCENARIO keyword that (indirectly) fronts it end up normalizing to the same name, the tool will refuse to resolve one of them — this is not hypothetical.

**Concrete case:** Robot Framework resolves keyword names ignoring case and whitespace. A POM keyword `GET Get Widget By Id` and a SCENARIO keyword `Get Get Widget By Id` collide — Robot reports *"Multiple keywords with name '...' found"* the moment both resources are in scope, and every test using it fails.

**Rule:** give the SCENARIO-layer keyword/function a *distinctly different phrasing* from the POM-layer keyword it eventually reaches — never just a re-cased or re-spaced copy. The worked example above (`WIDGETS - GET BY ID` for SCENARIO vs. `GET Get Widget By Id` for POM) follows this. Before naming a new SCENARIO keyword, check it against every POM keyword name it will share a resource-import graph with.

## 4. Robot Framework syntax gotchas (learned from real bugs, not theoretical)

These are language-level footguns, not architectural rules — but they've caused real, repo-wide bugs in this methodology's own examples, so treat them as required knowledge before writing Robot Framework code.

**`$var` vs. `${var}` inside `IF`/`Evaluate`.** `${var}` inside a quoted string forces Robot to stringify the value before comparing/evaluating — which breaks the moment the value is a dict, list, or other non-string object, because Python then sees malformed syntax. `$var` (no braces, no quotes) passes the actual object through instead.

```robotframework
# Wrong — crashes the moment ${custom_fields} is a dict or list, not a string:
IF    '${custom_fields}' == '${EMPTY}'
    ...

# Correct — compares the real object, works for any type:
IF    $custom_fields == ''
    ...
```

The same distinction applies inside `Evaluate` expressions and inside a schema dict passed to a validator keyword — use `$var`, not `${var}`, whenever the value being compared or evaluated might not be a plain string.

**`${{ <python expression> }}` for literal data structures in `*** Variables ***`.** To define a schema (or any dict/list constant) as a Variables-section value, wrap a real Python literal in double curly braces:

```robotframework
*** Variables ***
${WIDGET_SCHEMA}    ${{ {'required': ['id', 'name'], 'types': {'id': int, 'name': str}, 'enums': {}} }}
```

This evaluates the Python expression once at load time and binds it to the variable as a real object (a `dict`, here) — not as a string that needs parsing later.

## 5. Supporting patterns (apply when the shape of the problem calls for them — not everywhere)

- **Common session/auth resource.** One `pom/common/<api>_common.resource` (or equivalent module) per API/system under test, holding session bootstrap and an auth-header builder. Never hardcode a credential or token — read it from an environment variable with an empty default, so the suite is safe to share/commit and fails predictably (an auth error, not a leaked secret) when run without one configured.
- **Shallow schema validation.** A generic "validate object/array against schema" FLOW helper that checks top-level required fields, types, and enum membership — deliberately *not* a full recursive JSON-schema validator. Nested business objects are domain data; don't hand-unroll them into the generic validator, model them explicitly if you need to check them.
- **Dispatch by status code, unless one status code covers multiple business outcomes.** Default: the FLOW dispatcher routes on the literal HTTP status code (or UI/DB equivalent). Switch to dispatching on a business-meaningful scenario *name* string specifically when two distinct outcomes share one status/return code (e.g. a "not found" response that still returns HTTP 200 with an empty payload) — the real status is still asserted inside each per-scenario FLOW keyword either way; only the routing key changes.
- **Seed data instead of hardcoded ids.** When a read/delete-by-id scenario needs a guaranteed-valid id and there's no safe way to hardcode one (a shared server whose data can change), have the FLOW call the corresponding create-operation's FLOW first to obtain one.
- **Scope negative cases to what's actually verifiable.** Only implement a status/outcome as a test case when there's a genuine, data-triggerable, meaningfully differentiable input for it. Don't add a case just to hit a round number — if a spec documents two codes (say 400 and 422) with no way to tell them apart without observing real behavior, implement the one you can actually justify and say why the other was skipped.
- **A global, monotonically increasing suite-ID sequence**, not reset per example/module, with deliberate reuse of an ID only when porting the identical requirement to a second tool (see `agent/IMPLEMENTATION.md` §2).

## 6. Adapting to a tool other than Robot Framework

The four layers and every rule above are tool-agnostic by design — this methodology has already been ported once, from Robot Framework to Playwright/TypeScript, with zero change to the responsibilities in §1's table. What changes per tool:

- **POM syntax** — the only layer whose *content* is inherently tool-specific (HTTP client calls, Selenium/Playwright locators, SQL driver calls, ...).
- **"Import" mechanism** — Robot Framework's `Resource` statement, an ES `import`, a Python `import`, whatever the language uses; the downward-only rule (§2, rule 1) applies regardless of syntax.
- **Namespace workarounds are not portable rules.** Some tools need extra scaffolding purely because of a language limitation — for example, Robot Framework has a single flat global variable namespace, so a real Robot implementation may introduce one aggregator resource per concern (schemas, data-driven values) that every FLOW file imports, just to avoid naming collisions across unrelated resources. A module-based language (TypeScript, Python, ...) doesn't have that problem — each file imports exactly the symbols it needs by name — so don't carry that aggregator pattern into a tool that doesn't need it. When you inherit a pattern from an existing example, ask whether it's solving a *general* LKDF problem or a *specific tool's* limitation before reusing it.
- **Type systems, when available, are a genuine upgrade, not a deviation.** A statically-typed language can make a FLOW dispatcher's `scenario` parameter a union type instead of a free-form string, catching an invalid scenario name at compile time instead of at runtime. That's consistent with LKDF, not a violation of it — the responsibility (dispatch) hasn't moved layers.
