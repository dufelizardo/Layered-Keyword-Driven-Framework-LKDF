*** Settings ***
Resource    ../../../pom/cep/get_cep_by_code/get_cep_by_code_pom.resource
Resource    ../../common/schema_validation_flow.resource
Resource    ../../../resource/config/schema/schema.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
    "Not found" is not a distinct HTTP status on this API - a syntactically valid but unassigned CEP still
    returns 200, just with a {"erro": "true"} body instead of an address. So the dispatcher below routes by a
    scenario name (found/not_found/invalid_format) rather than by HTTP status code alone.
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Keywords ***
GET Get Cep By Code - Found
    [Arguments]    ${cep}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    '${cep}' == '${EMPTY}'
        ${cep}=    Set Variable    01001000
    END
    ${response}=    Call GET Get Cep By Code    ${cep}
    Should Be Equal As Integers    ${response.status_code}    200
    Validate Object Schema    ${response.json()}    ${ADDRESS_SCHEMA}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

GET Get Cep By Code - Not Found
    [Arguments]    ${cep}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    '${cep}' == '${EMPTY}'
        ${cep}=    Set Variable    99999999
    END
    ${response}=    Call GET Get Cep By Code    ${cep}
    Should Be Equal As Integers    ${response.status_code}    200
    Validate Object Schema    ${response.json()}    ${CEP_NOT_FOUND_SCHEMA}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

GET Get Cep By Code - Invalid Format
    [Arguments]    ${cep}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    '${cep}' == '${EMPTY}'
        ${cep}=    Set Variable    123
    END
    ${response}=    Call GET Get Cep By Code    ${cep}
    Should Be Equal As Integers    ${response.status_code}    400
    # Note: the 400 response body is HTML, not JSON - no schema validation is attempted here on purpose.

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Call GET Get Cep By Code
    [Documentation]    Calls the GET Get Cep By Code keyword from the POM.
    [Arguments]    ${cep}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${response}=    GET Get Cep By Code    ${cep}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Cep - Get By Code - By Scenario
    [Documentation]    This keyword executes the appropriate Get Cep By Code test scenario based on the provided
    ...    scenario name.
    [Arguments]    ${cep}    ${scenario}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    Run Keyword If    '${scenario}' == 'found'             GET Get Cep By Code - Found    ${cep}
    ...    ELSE IF    '${scenario}' == 'not_found'          GET Get Cep By Code - Not Found    ${cep}
    ...    ELSE IF    '${scenario}' == 'invalid_format'     GET Get Cep By Code - Invalid Format    ${cep}
    ...    ELSE    Fail    Scenario '${scenario}' is not supported for Get Cep By Code test scenario.
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
