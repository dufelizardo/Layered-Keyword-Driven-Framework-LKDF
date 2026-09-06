*** Settings ***
Resource    ../../../pom/pet/get_pet_by_id/get_pet_by_id_pom.resource
Resource    ../../../flow/pet/add_pet/add_pet_flow.resource
Resource    ../../common/schema_validation_flow.resource
Resource    ../../../resource/config/schema/schema.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Keywords ***
Seed A Pet For Lookup
    [Documentation]    Creates a fresh pet via the Add Pet flow so this test has a guaranteed valid petId to look up.
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${response}=    POST Add Pet - Status Code 200
    RETURN    ${response.json()['id']}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

GET Get Pet By Id - Status Code 200
    [Arguments]    ${pet_id}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    '${pet_id}' == '${EMPTY}'
        ${pet_id}=    Seed A Pet For Lookup
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
        ${pet_id}=    Set Variable    invalid-id
    END
    ${response}=    Call GET Get Pet By Id    ${pet_id}
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
