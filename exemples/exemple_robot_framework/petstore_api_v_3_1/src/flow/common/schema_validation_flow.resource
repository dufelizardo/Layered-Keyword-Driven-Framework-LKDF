*** Settings ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
    Shared, reusable response-schema validation keywords, based on the Swagger Petstore OpenAPI 3.1 definitions.
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Keywords ***
Validate Object Schema
    [Documentation]    Validates that ${data} is a JSON object satisfying ${schema}: every key listed in
    ...    schema['required'] is present, every key present in schema['types'] has the expected Python type,
    ...    and every key present in schema['enums'] has a value inside its allowed list.
    [Arguments]    ${data}    ${schema}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    Should Be True    isinstance($data, dict)    msg=Response body is not a JSON object: ${data}

    ${errors}=    Evaluate
    ...    [m for m in (['missing required field: ' + f for f in $schema['required'] if f not in $data] + ['field ' + f + ' expected type ' + t.__name__ + ' but got ' + type($data.get(f)).__name__ for f, t in $schema['types'].items() if f in $data and $data.get(f) is not None and not isinstance($data[f], t)] + ['field ' + f + ' value ' + repr($data[f]) + ' not in allowed values ' + repr(v) for f, v in $schema['enums'].items() if f in $data and $data[f] not in v])]

    Should Be Empty    ${errors}    msg=Schema validation failed: ${errors}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
