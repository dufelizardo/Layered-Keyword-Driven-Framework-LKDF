# 05 — Implementation Patterns (as used in this repository's public examples)

[`agent/ARCHITECTURE.md`](../agent/ARCHITECTURE.md) §4 lists these patterns in portable, tool-agnostic form, for reuse in any project. This page is the repo-specific companion: it names the actual files in this repository's four public examples (`petstore_api_v_2`, `petstore_api_v_3_1`, `viacep` Robot Framework, `viacep` Playwright), quotes short excerpts, and notes which example demonstrates which pattern. It doesn't restate the architectural rules themselves — see [`README.md`](../README.md) and [`doc/03_constraints.md`](03_constraints.md) for those.

## Common session/auth resource

Every example keeps exactly one `pom/common/*.resource` file holding session bootstrap for that API. `petstore_api_v_2`'s is `exemples/exemple_robot_framework/petstore_api_v_2/src/pom/common/petstore_v2_common.resource`:

```robotframework
*** Keywords ***
Get Petstore V2 Session
    [Documentation]    Creates (or reuses) the shared RequestsLibrary session for the Petstore v2 API.
    Create Session    petstore_v2_session    ${HOST_URL}    verify=False
```

Every POM keyword calls this one keyword to obtain its session rather than hardcoding `Create Session` itself. Where an API requires an auth header, the same file is where a header-builder keyword belongs — none of the four public examples need one, since Petstore v2/v3.1 and ViaCEP are unauthenticated for the operations covered here. The rule (see "Auth via environment variable" below) still applies the moment one is needed: credentials are never hardcoded, only read from environment.

## Shallow schema validation

`exemples/exemple_robot_framework/petstore_api_v_2/src/flow/common/schema_validation_flow.resource` holds a generic `Validate Object Schema` keyword, reused by every FLOW resource in `petstore_api_v_2`, `petstore_api_v_3_1`, and `viacep`:

```robotframework
Validate Object Schema
    [Documentation]    Validates that ${data} is a JSON object satisfying ${schema}: every key listed in
    ...    schema['required'] is present, every key present in schema['types'] has the expected Python type,
    ...    and every key present in schema['enums'] has a value inside its allowed list.
    [Arguments]    ${data}    ${schema}
    Should Be True    isinstance($data, dict)    msg=Response body is not a JSON object: ${data}
    ${errors}=    Evaluate
    ...    [m for m in (['missing required field: ' + f for f in $schema['required'] if f not in $data] + ...)]
    Should Be Empty    ${errors}    msg=Schema validation failed: ${errors}
```

It checks `required`, `types`, and `enums` at the **top level only** — it deliberately does not recurse into nested objects. A nested object (e.g. Petstore's `category` or `tags` fields on a pet) is domain data, not generic shape; a scenario that needs to assert something about it writes that assertion explicitly rather than hand-unrolling it into this generic validator. The same file carries siblings for the other response shapes Petstore actually returns (`Validate Array Schema`, `Validate Map Of Integers`, `Validate Non Empty String`) — same shallow philosophy.

## Dispatch by status code vs. by scenario name

The default in this repo is to dispatch on the literal HTTP status code. `petstore_api_v_2`'s `get_pet_by_id_flow.resource` does this in `Pet - Get By Id - GET - By HTTP Status Code`:

```robotframework
Pet - Get By Id - GET - By HTTP Status Code
    [Arguments]    ${meuPetId}    ${meuHTTP}
    Run Keyword If    '${meuHTTP}' == '200'    GET Get Pet By Id - Status Code 200    ${meuPetId}
    ...    ELSE IF    '${meuHTTP}' == '400'    GET Get Pet By Id - Status Code 400    ${meuPetId}
    ...    ELSE IF    '${meuHTTP}' == '404'    GET Get Pet By Id - Status Code 404    ${meuPetId}
    ...    ELSE    Fail    HTTP status code '${meuHTTP}' is not supported for Get Pet By Id test scenario.
```

`viacep` cannot do this: both of its endpoints return `200` for a valid-but-unassigned/no-match lookup as well as for a real hit — only the response *body* differs. Its dispatcher, `Cep - Get By Code - By Scenario` in `exemples/exemple_robot_framework/viacep/src/flow/cep/get_cep_by_code/get_cep_by_code_flow.resource`, routes on a scenario-name string (`found` / `not_found` / `invalid_format`) instead:

```robotframework
Cep - Get By Code - By Scenario
    [Arguments]    ${cep}    ${scenario}
    Run Keyword If    '${scenario}' == 'found'             GET Get Cep By Code - Found    ${cep}
    ...    ELSE IF    '${scenario}' == 'not_found'          GET Get Cep By Code - Not Found    ${cep}
    ...    ELSE IF    '${scenario}' == 'invalid_format'     GET Get Cep By Code - Invalid Format    ${cep}
    ...    ELSE    Fail    Scenario '${scenario}' is not supported for Get Cep By Code test scenario.
```

The real HTTP status is still asserted *inside* each per-scenario keyword either way (`GET Get Cep By Code - Not Found` asserts `200`, `GET Get Cep By Code - Invalid Format` asserts `400`); only the *routing key* changed. `viacep`'s own README explains why: since "not found" isn't a distinct HTTP status on this API, a status-code dispatcher couldn't tell `found` from `not_found` apart. The rule: default to status-code dispatch, switch to scenario-name dispatch only when one status genuinely covers more than one business outcome.

## Seed-data pattern

`get_pet_by_id_flow.resource` (`petstore_api_v_2`) needs a real, currently-existing pet id, but the target server is a shared public demo instance whose data isn't under this repo's control — a hardcoded id could vanish at any time. Its `Seed A Pet For Lookup` keyword solves this by calling the Add Pet flow first:

```robotframework
Seed A Pet For Lookup
    [Documentation]    Creates a fresh pet via the Add Pet flow so this test has a guaranteed valid petId to look up.
    ${response}=    POST Add Pet - Status Code 200
    RETURN    ${response.json()['id']}
```

`GET Get Pet By Id - Status Code 200` calls this whenever no explicit `pet_id` is supplied, guaranteeing a valid id without relying on any value persisting on the shared server.

## The `resource/config/{driven,schema}` aggregator pair (Robot-only)

`petstore_api_v_2` (and `viacep`, Robot Framework) both carry a `resource/config/schema/schema.resource` and `resource/config/driven/data_driven.resource` — files with no logic, only `Resource` lines aggregating the individual per-domain files:

```robotframework
*** Settings ***
# PET
Resource    ../../schema/pet/pet_schema.resource
# STORE
Resource    ../../schema/store/store_schema.resource
# USER
Resource    ../../schema/user/user_schema.resource
```

Every FLOW resource imports this one aggregator rather than reaching into individual schema/data files directly. This exists because Robot Framework resolves variables through a single flat global namespace — without one shared entry point, avoiding collisions across unrelated files gets unwieldy fast. The Playwright port of `viacep` (`exemples/exemple_playwright/viacep/README.md`) drops this pair entirely: TypeScript's ES modules import each symbol by name, so there's no flat-namespace risk to work around, and the aggregator becomes pure indirection with no payoff. **This is a tool-specific workaround, not a portable LKDF rule** — see `agent/ARCHITECTURE.md` §5 for the general caution against carrying a namespace workaround into a tool that doesn't have the underlying problem.

## Auth via environment variable

None of this repo's four public examples require authentication, so none demonstrate this pattern in a committed file. The rule, per `AGENTS.md` §3 and `agent/ARCHITECTURE.md` §4, is stated here rather than invented against a public example that doesn't need it: a credential or token is always read from an environment variable with an empty default, never hardcoded in a `pom/common/` resource — so the suite is safe to commit/share and fails predictably (an auth error, not a leaked secret) when run without one configured.
