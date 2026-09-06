*** Settings ***
Resource    ../../../pom/pet/delete_pet/delete_pet_pom.resource
Resource    ../../../flow/pet/add_pet/add_pet_flow.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Keywords ***
Seed A Pet For Deletion
    [Documentation]    Creates a fresh pet via the Add Pet flow so this test has a guaranteed valid petId to delete.
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${response}=    POST Add Pet - Status Code 200
    RETURN    ${response.json()['id']}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

DELETE Delete Pet - Status Code 200
    [Arguments]    ${pet_id}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    '${pet_id}' == '${EMPTY}'
        ${pet_id}=    Seed A Pet For Deletion
    END
    ${response}=    Call DELETE Delete Pet    ${pet_id}
    Should Be Equal As Integers    ${response.status_code}    200

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

DELETE Delete Pet - Status Code 400
    [Arguments]    ${pet_id}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    '${pet_id}' == '${EMPTY}'
        ${pet_id}=    Set Variable    invalid-id
    END
    ${response}=    Call DELETE Delete Pet    ${pet_id}
    Should Be Equal As Integers    ${response.status_code}    400

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

DELETE Delete Pet - Status Code 404
    [Arguments]    ${pet_id}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    '${pet_id}' == '${EMPTY}'
        ${pet_id}=    Set Variable    999999999
    END
    ${response}=    Call DELETE Delete Pet    ${pet_id}
    Should Be Equal As Integers    ${response.status_code}    404

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Call DELETE Delete Pet
    [Documentation]    Calls the DELETE Delete Pet keyword from the POM.
    [Arguments]    ${pet_id}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${response}=    DELETE Delete Pet    ${pet_id}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Pet - Delete - DELETE - By HTTP Status Code
    [Documentation]    This keyword executes the appropriate Delete Pet test scenario based on the provided HTTP
    ...    status code.
    [Arguments]    ${meuPetId}    ${meuHTTP}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    Run Keyword If    '${meuHTTP}' == '200'    DELETE Delete Pet - Status Code 200    ${meuPetId}
    ...    ELSE IF    '${meuHTTP}' == '400'    DELETE Delete Pet - Status Code 400    ${meuPetId}
    ...    ELSE IF    '${meuHTTP}' == '404'    DELETE Delete Pet - Status Code 404    ${meuPetId}
    ...    ELSE    Fail    HTTP status code '${meuHTTP}' is not supported for Delete Pet test scenario.
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
