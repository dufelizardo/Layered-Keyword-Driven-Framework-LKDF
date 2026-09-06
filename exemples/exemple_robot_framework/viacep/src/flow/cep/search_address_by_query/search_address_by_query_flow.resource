*** Settings ***
Resource    ../../../pom/cep/search_address_by_query/search_address_by_query_pom.resource
Resource    ../../common/schema_validation_flow.resource
Resource    ../../../resource/config/schema/schema.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
    Like get_cep_by_code, "no results" is not a distinct HTTP status here - an invalid UF or a street with no
    matches still returns 200, just with an empty array. The dispatcher below routes by a scenario name
    (found/no_results/invalid_format) rather than by HTTP status code alone.
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Keywords ***
GET Search Address By Query - Found
    [Arguments]    ${uf}=${EMPTY}    ${city}=${EMPTY}    ${street}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    '${uf}' == '${EMPTY}'
        ${uf}=    Set Variable    SP
    END
    IF    '${city}' == '${EMPTY}'
        ${city}=    Set Variable    São Paulo
    END
    IF    '${street}' == '${EMPTY}'
        ${street}=    Set Variable    Paulista
    END
    ${response}=    Call GET Search Address By Query    ${uf}    ${city}    ${street}
    Should Be Equal As Integers    ${response.status_code}    200
    Validate Array Schema    ${response.json()}    ${ADDRESS_SCHEMA}
    Log    ${response.json()}
    Log To Console    ${response.json()}
    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

GET Search Address By Query - No Results
    [Arguments]    ${uf}=${EMPTY}    ${city}=${EMPTY}    ${street}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    '${uf}' == '${EMPTY}'
        ${uf}=    Set Variable    SP
    END
    IF    '${city}' == '${EMPTY}'
        ${city}=    Set Variable    São Paulo
    END
    IF    '${street}' == '${EMPTY}'
        ${street}=    Set Variable    RuaQueNaoExisteXyzabc
    END
    ${response}=    Call GET Search Address By Query    ${uf}    ${city}    ${street}
    Should Be Equal As Integers    ${response.status_code}    200
    Validate Array Schema    ${response.json()}    ${ADDRESS_SCHEMA}
    Should Be Empty    ${response.json()}    msg=Expected an empty array for a no-results scenario, got: ${response.json()}
    
    Log    ${response.json()}
    Log To Console    ${response.json()}
    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

GET Search Address By Query - Invalid Format
    [Arguments]    ${uf}=${EMPTY}    ${city}=${EMPTY}    ${street}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    '${uf}' == '${EMPTY}'
        ${uf}=    Set Variable    SP
    END
    IF    '${city}' == '${EMPTY}'
        ${city}=    Set Variable    Sa
    END
    IF    '${street}' == '${EMPTY}'
        ${street}=    Set Variable    Paulista
    END
    ${response}=    Call GET Search Address By Query    ${uf}    ${city}    ${street}
    Should Be Equal As Integers    ${response.status_code}    400
    # Note: the 400 response body is HTML, not JSON - do not call response.json() here, it will raise
    # JSONDecodeError. Use response.text if you need to log/inspect the body in this scenario.

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Call GET Search Address By Query
    [Documentation]    Calls the GET Search Address By Query keyword from the POM.
    [Arguments]    ${uf}    ${city}    ${street}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${response}=    GET Search Address By Query    ${uf}    ${city}    ${street}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Cep - Search Address - By Scenario
    [Documentation]    This keyword executes the appropriate Search Address By Query test scenario based on the
    ...    provided scenario name.
    [Arguments]    ${uf}    ${city}    ${street}    ${scenario}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    Run Keyword If    '${scenario}' == 'found'             GET Search Address By Query - Found    ${uf}    ${city}    ${street}
    ...    ELSE IF    '${scenario}' == 'no_results'         GET Search Address By Query - No Results    ${uf}    ${city}    ${street}
    ...    ELSE IF    '${scenario}' == 'invalid_format'     GET Search Address By Query - Invalid Format    ${uf}    ${city}    ${street}
    ...    ELSE    Fail    Scenario '${scenario}' is not supported for Search Address By Query test scenario.
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
