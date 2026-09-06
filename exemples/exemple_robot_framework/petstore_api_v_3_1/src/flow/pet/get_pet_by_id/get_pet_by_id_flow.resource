*** Settings ***
Resource    ../../../pom/pet/get_pet_by_id/get_pet_by_id_pom.resource
Resource    ../../common/schema_validation_flow.resource
Resource    ../../../resource/config/schema/schema.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
    Note: unlike petstore_api_v_2's get_pet_by_id, this does NOT seed a fresh pet via Add Pet for the 200 case.
    The OpenAPI 3.1 spec documents petId as exclusiveMinimum=1, exclusiveMaximum=10 (only 2-9 are valid), and a
    freshly added pet's id is very unlikely to land inside that narrow range - a literal in-range id is a more
    faithful test of the documented contract than a seeded one here.
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Keywords ***
GET Get Pet By Id - Status Code 200
    [Arguments]    ${pet_id}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    '${pet_id}' == '${EMPTY}'
        ${pet_id}=    Set Variable    5
    END
    ${response}=    Call GET Get Pet By Id    ${pet_id}
    Should Be Equal As Integers    ${response.status_code}    200
    Validate Object Schema    ${response.json()}    ${PET_SCHEMA}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

GET Get Pet By Id - Status Code 400
    [Arguments]    ${pet_id}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    '${pet_id}' == '${EMPTY}'
        ${pet_id}=    Set Variable    1
    END
    ${response}=    Call GET Get Pet By Id    ${pet_id}
    # Known live-server issue — see KNOWN_ISSUES.md #3: the documented exclusiveMinimum=1 boundary isn't
    # enforced, this actually returns 200, not 400.
    Should Be Equal As Integers    ${response.status_code}    400

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

GET Get Pet By Id - Status Code 404
    [Arguments]    ${pet_id}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    '${pet_id}' == '${EMPTY}'
        ${pet_id}=    Set Variable    999999999
    END
    ${response}=    Call GET Get Pet By Id    ${pet_id}
    # Known live-server issue — see KNOWN_ISSUES.md #3: this actually returns 400, not the documented 404.
    Should Be Equal As Integers    ${response.status_code}    404

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Call GET Get Pet By Id
    [Documentation]    Calls the GET Get Pet By Id keyword from the POM.
    [Arguments]    ${pet_id}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${response}=    GET Get Pet By Id    ${pet_id}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Pet - Get By Id - GET - By HTTP Status Code
    [Documentation]    This keyword executes the appropriate Get Pet By Id test scenario based on the provided HTTP
    ...    status code.
    [Arguments]    ${meuPetId}    ${meuHTTP}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    Run Keyword If    '${meuHTTP}' == '200'    GET Get Pet By Id - Status Code 200    ${meuPetId}
    ...    ELSE IF    '${meuHTTP}' == '400'    GET Get Pet By Id - Status Code 400    ${meuPetId}
    ...    ELSE IF    '${meuHTTP}' == '404'    GET Get Pet By Id - Status Code 404    ${meuPetId}
    ...    ELSE    Fail    HTTP status code '${meuHTTP}' is not supported for Get Pet By Id test scenario.
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
