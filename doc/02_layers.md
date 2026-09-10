# 02 — The Four Layers, In Real Code

[`README.md`](../README.md) §1.0 and §2.0 define the four layers and their Responsibility Assignment Matrix in the abstract; [`agent/ARCHITECTURE.md`](../agent/ARCHITECTURE.md) §1 shows them worked out for a fictional "Widget" resource. This page does the same walk-through, but every excerpt below is pulled from a real, committed, currently-passing file in this repo's `petstore_api_v_2` example — the `GET /pet/{petId}` operation (`US-008`). Nothing here is invented; if a claim doesn't match the file it quotes, the file wins.

The four files, read in dependency order (TEST imports SCENARIO imports FLOW imports POM):

- POM: `exemples/exemple_robot_framework/petstore_api_v_2/src/pom/pet/get_pet_by_id/get_pet_by_id_pom.resource`
- FLOW: `exemples/exemple_robot_framework/petstore_api_v_2/src/flow/pet/get_pet_by_id/get_pet_by_id_flow.resource`
- SCENARIO: `exemples/exemple_robot_framework/petstore_api_v_2/src/scenario/pet/get_pet_by_id/get_pet_by_id_scenario.resource`
- TEST: `exemples/exemple_robot_framework/petstore_api_v_2/test/pet/get_pet_by_id/US-008.robot`

## POM

From README §2.0's matrix: **Single Responsibility** — "Abstract and isolate technical infrastructure." **Admissible Change Trigger** — "UI layout refactoring, altered IDs, schema shifts, or API contract changes." **Architectural Restrictions** — "Cross-cutting business rules, corporate domain validations, or logical routing."

```robotframework
GET Get Pet By Id
    [Documentation]    Sends a GET request to fetch a pet by its id and returns the response.
    [Arguments]    ${pet_id}
    Get Petstore V2 Session

    ${response}=    GET On Session
    ...    petstore_v2_session
    ...    ${BASE_URL}${ENDPOINT}/${pet_id}
    ...    expected_status=ANY

    Log    ${response.status_code}
    Log    ${response.text}

    RETURN    ${response}
```

Notice there is no `Should Be Equal` anywhere, only a raw call and `RETURN`. `expected_status=ANY` is doing real architectural work here, not just being permissive: it tells `RequestsLibrary` not to raise on a non-2xx code, because deciding whether a given status is "success" or "failure" is not this layer's job. The keyword's only opinions are technical — which session to use, which URL to hit, which HTTP verb — exactly the set of things that change when the API's infrastructure changes, and nothing else.

## FLOW

**Single Responsibility** — "Process domain logic and assertions." **Admissible Change Trigger** — "Evolving business logic, calculations, or functional criteria." **Architectural Restrictions** — "UI selectors (XPath/CSS), raw URLs, or direct interaction with driver engines."

```robotframework
GET Get Pet By Id - Status Code 200
    [Arguments]    ${pet_id}=${EMPTY}
    IF    '${pet_id}' == '${EMPTY}'
        ${pet_id}=    Seed A Pet For Lookup
    END
    ${response}=    Call GET Get Pet By Id    ${pet_id}
    Should Be Equal As Integers    ${response.status_code}    200
    Validate Object Schema    ${response.json()}    ${PET_SCHEMA}

    RETURN    ${response}
```

Notice this is where `Should Be Equal As Integers` and `Validate Object Schema` actually happen — the two lines this whole architecture exists to protect from being duplicated or skipped. This file also owns the *decision-making*: `GET Get Pet By Id - Status Code 200` seeds a fresh pet if none was supplied (via `Seed A Pet For Lookup`, itself a call into the `add_pet` FLOW — never into POM directly), `GET Get Pet By Id - Status Code 400` substitutes a malformed id, and `GET Get Pet By Id - Status Code 404` substitutes a numerically valid but nonexistent one. None of that conditional data-shaping belongs in POM (which only knows how to call the endpoint) or in TEST (which is forbidden from having `IF` at all). Finally, `Pet - Get By Id - GET - By HTTP Status Code` is the dispatcher: it routes on the literal `${meuHTTP}` value to the matching per-scenario keyword above, per the "dispatch by status code, unless one status code covers multiple business outcomes" pattern in `agent/ARCHITECTURE.md` §4 — this operation has no status-collision, so it dispatches directly on the code.

## SCENARIO

**Single Responsibility** — "Orchestrate the macro-level user journey." **Admissible Change Trigger** — "Modifications to the system's macro user experience workflows." **Architectural Restrictions** — "Hardcoded data, functional validation assertions, or exception handling."

```robotframework
PET - GET BY ID - GET
    [Documentation]    Test scenario for fetching a pet by id (GET /pet/{petId}) on the Swagger Petstore v2 API.
    [Arguments]    ${meuPetId}    ${meuHTTP}
    Pet - Get By Id - GET - By HTTP Status Code    ${meuPetId}    ${meuHTTP}
```

Notice this is a single line — it does not build the request or touch the response, it just forwards `${meuPetId}` and `${meuHTTP}` straight down to the FLOW dispatcher and returns whatever comes back. There is no `Should Be Equal`, no `IF`, no literal id or status code baked in — every value it handles arrived as an argument from the caller. This is also the keyword name `doc/03_constraints.md`'s Constraint 5 exists to protect: `PET - GET BY ID - GET` is deliberately phrased nothing like the POM keyword `GET Get Pet By Id` it eventually reaches, so Robot Framework's case/whitespace-insensitive name resolution never collides the two.

## TEST

**Single Responsibility** — "Parameterize test execution variants." **Admissible Change Trigger** — "Appending data variations, new profiles, or environment keys." **Architectural Restrictions** — "Control flow statements (`if/else`), loops, business assertions, or technical selectors."

```robotframework
CT-001 - US-008: Validate GET Get Pet By Id - HTTP 200 OK
    [Documentation]    Test case to validate the GET pet by id endpoint with HTTP 200 OK response.
    [Tags]    GET    GetPetById    HTTP200
    PET - GET BY ID - GET    ${EMPTY}    200

CT-002 - US-008: Validate GET Get Pet By Id - HTTP 400 BAD REQUEST
    [Documentation]    Test case to validate the GET pet by id endpoint with HTTP 400 BAD REQUEST response.
    [Tags]    GET    GetPetById    HTTP400
    PET - GET BY ID - GET    ${get_pet_by_id_invalid_id_400}    400
```

Notice this file supplies only ids and status codes as data, no conditional logic. `${EMPTY}` for CT-001 means "let FLOW seed a fresh pet"; `${get_pet_by_id_invalid_id_400}` is a plain variable reference resolved from the `data_driven.resource` aggregator, not a computed value. Each test case is one call to the SCENARIO keyword with a literal or variable argument and nothing else — no assertion runs in this file at all; every `CT-00N` here passes or fails purely on what the FLOW layer (three levels down) decided.

## Layer equivalence across tools

The same four responsibilities, same operation shape, realized in the Playwright/TypeScript ViaCEP port (`GET /ws/{cep}/json/`, `US-025`):

```typescript
// POM — src/pom/cep/getCepByCode.pom.ts
export async function getCepByCode(session: APIRequestContext, cep: string): Promise<APIResponse> {
    return session.get(`/ws/${cep}/json/`);
}
```

```typescript
// FLOW — src/flow/cep/getCepByCode.flow.ts
export async function getCepByCodeFound(
    session: APIRequestContext,
    cep: string = '01001000',
): Promise<APIResponse> {
    const response = await callGetCepByCode(session, cep);
    expect(response.status()).toBe(200);
    validateObjectSchema(await response.json(), ADDRESS_SCHEMA);
    return response;
}
```

```typescript
// SCENARIO — src/scenario/cep/getCepByCode.scenario.ts
export async function cepGetByCode(
    session: APIRequestContext,
    scenario: GetCepByCodeScenario,
    cep?: string,
): Promise<APIResponse> {
    return getCepByCodeByScenario(session, scenario, cep);
}
```

```typescript
// TEST — tests/cep/US-025-get-cep-by-code.spec.ts
test('CT-001: Found', async ({ viacepSession }) => {
    await cepGetByCode(viacepSession, 'found');
});
```

The responsibilities are identical to the Robot Framework version — POM issues the raw call with zero assertions, FLOW owns the status/schema assertions and the scenario dispatch, SCENARIO is a one-line pass-through, TEST supplies only a scenario name and optional data — only the syntax changed: `.resource` files become `.ts` modules, `Resource` imports become ES `import`s, and Robot's free-form `${meuHTTP}` string becomes a compile-checked `GetCepByCodeScenario` union type. The ViaCEP Playwright example's own README documents this mapping in a table (layer-by-layer, Robot path vs. TypeScript path) and explains the two deliberate adaptations — dropping the `resource/config/{driven,schema}` aggregator pair (a workaround for Robot's flat global namespace that TypeScript's module imports don't need) and using a union type for the dispatch key instead of a free string. For the general principle of adapting LKDF to a different tool, see `agent/ARCHITECTURE.md` §5 rather than re-deriving it here.
