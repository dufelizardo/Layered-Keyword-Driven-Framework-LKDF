# 04 — Runtime Execution Model, Traced Through Real Code

[`README.md`](../README.md) §5.0 describes the LKDF runtime as a **5-Stage Automation Lifecycle**. Quoting it verbatim, from §5.1:

> 1. **Memory Allocation & Data Ingestion (`TEST` Phase):** The Test Runner allocates the raw data configuration (JSON, dictionaries, YAML) in memory. No automation mechanics are initialized; the dataset is isolated at the edge.
> 2. **Structural Handshake (`SCENARIO` Phase):** The test triggers the corresponding user story in the `SCENARIO` layer, forwarding the dataset reference. The scenario serves as a clean pass-through engine, unpacking variables into parameters bound for the lower subsystems.
> 3. **Algorithmic Evaluation & Assertion Prep (`FLOW` Phase):** The `FLOW` layer receives strongly typed parameters. The framework's core brain is engaged here—evaluating conditionals, setting up functional validation frameworks, and organizing the business assertions required for system verification.
> 4. **Imperative Translation (`POM` Phase):** The `FLOW` invokes atomic methods on the `POM` layer. The page object converts these values into raw, imperatively executable commands (e.g., clicks, keys, raw payloads) expected by the driver subsystem.
> 5. **Physical Subsystem Impact (SUT Impact):** The engine triggers downstream interactions with the real application environment (UI rendering, API gateway, databases). The system under test (SUT) updates its state, sending feedback back up through the pipeline for evaluation against the assertions prepared in Step 3.

Below is that same lifecycle, traced through one real, complete request/response trip: the `GET /pet/{petId}` operation (`US-008`) in `petstore_api_v_2`, against the live Swagger Petstore v2 server. Same four files as `doc/02_layers.md`.

## 1. Memory Allocation & Data Ingestion (TEST phase)

In `exemples/exemple_robot_framework/petstore_api_v_2/test/pet/get_pet_by_id/US-008.robot`, `CT-001` calls the SCENARIO keyword with literal data and nothing else:

```robotframework
PET - GET BY ID - GET    ${EMPTY}    200
```

This is the moment the README calls "the Test Runner allocates the raw data configuration in memory." `${EMPTY}` and `200` are plain values in Robot's variable table before any HTTP mechanics exist — no session open, no request built. `CT-002` and `CT-003` do the same with `${get_pet_by_id_invalid_id_400}` and `${get_pet_by_id_nonexistent_id_404}`, both resolved from the `data_driven.resource` aggregator — still just data ingestion.

## 2. Structural Handshake (SCENARIO phase)

`exemples/exemple_robot_framework/petstore_api_v_2/src/scenario/pet/get_pet_by_id/get_pet_by_id_scenario.resource` receives that call as `${meuPetId}` and `${meuHTTP}`, and does exactly one thing with them:

```robotframework
PET - GET BY ID - GET
    [Arguments]    ${meuPetId}    ${meuHTTP}
    Pet - Get By Id - GET - By HTTP Status Code    ${meuPetId}    ${meuHTTP}
```

This is the "clean pass-through engine" the README describes: the dataset reference from stage 1 is simply forwarded into the two parameters the FLOW dispatcher expects. No decision is made about what `200` or `404` *mean* — that comes next.

## 3. Algorithmic Evaluation & Assertion Prep (FLOW phase)

`exemples/exemple_robot_framework/petstore_api_v_2/src/flow/pet/get_pet_by_id/get_pet_by_id_flow.resource` is where the dataset stops being inert. The dispatcher keyword, `Pet - Get By Id - GET - By HTTP Status Code`, routes on `${meuHTTP}`:

```robotframework
Run Keyword If    '${meuHTTP}' == '200'    GET Get Pet By Id - Status Code 200    ${meuPetId}
...    ELSE IF    '${meuHTTP}' == '400'    GET Get Pet By Id - Status Code 400    ${meuPetId}
...    ELSE IF    '${meuHTTP}' == '404'    GET Get Pet By Id - Status Code 404    ${meuPetId}
```

and the per-scenario keyword it lands on, `GET Get Pet By Id - Status Code 200`, seeds a valid pet id if none was supplied, then, once the POM call returns, evaluates the result:

```robotframework
Should Be Equal As Integers    ${response.status_code}    200
Validate Object Schema    ${response.json()}    ${PET_SCHEMA}
```

This is the "core brain" step: conditional routing, schema setup, and the actual business assertions all live here — nowhere else in the pipeline runs a `Should Be Equal` for this operation.

## 4. Imperative Translation (POM phase)

The FLOW keyword's `Call GET Get Pet By Id` forwards into `exemples/exemple_robot_framework/petstore_api_v_2/src/pom/pet/get_pet_by_id/get_pet_by_id_pom.resource`, whose `GET Get Pet By Id` keyword issues the actual command:

```robotframework
${response}=    GET On Session
...    petstore_v2_session
...    ${BASE_URL}${ENDPOINT}/${pet_id}
...    expected_status=ANY
```

`GET On Session` is the raw, imperatively executable instruction the README's stage 4 describes — an HTTP GET built from a session, a base URL, and the id that flowed down from stage 1. `expected_status=ANY` matters because this layer is forbidden from judging the result; it just issues the command and hands back whatever comes back.

## 5. Physical Subsystem Impact (SUT Impact)

`GET On Session` actually leaves the process: it is a live HTTP call to `https://petstore.swagger.io/v2/pet/{petId}`, the real Swagger Petstore v2 demo server. That server's response — status code and JSON body — is the "physical subsystem impact." From there the response flows back *up* the same path: POM returns the raw `response` object with no interpretation (`RETURN ${response}`); FLOW runs the `Should Be Equal As Integers` / `Validate Object Schema` assertions prepared in stage 3 against it; and the pass/fail of those assertions is what Robot Framework's runner reports for `CT-001`–`CT-003` in `US-008.robot`.

## Why this matters operationally

This 5-stage model is exactly why the "no layer may skip a level" rule (README §4.1 rule 1, elaborated in `doc/03_constraints.md`) is not a style preference. If SCENARIO called POM directly — skipping FLOW — stage 3 (Algorithmic Evaluation & Assertion Prep) simply never happens: `GET On Session` would still fire and the live server would still respond, but no code in the pipeline would run `Should Be Equal As Integers` or `Validate Object Schema` against that response. The test case would execute, the SUT would genuinely be impacted, and Robot would still report a pass — not because the response was correct, but because nothing ever checked it. Skipping a layer isn't a style violation; it's a specific, predictable way to build a test that cannot fail.
