*** Settings ***
Resource    ../../../pom/pet/update_pet_with_form/update_pet_with_form_pom.resource
Resource    ../../../flow/pet/add_pet/add_pet_flow.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Keywords ***
Seed A Pet For Form Update
    [Documentation]    Creates a fresh pet via the Add Pet flow so this test has a guaranteed valid petId to update.
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${response}=    POST Add Pet - Status Code 200
    RETURN    ${response.json()['id']}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Build Update Pet With Form Data
    [Documentation]    Builds the form-urlencoded name/status fields used to update a pet.
    [Arguments]    ${custom_fields}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${base}=    Create Dictionary
    ...    name=doggie
    ...    status=available
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    $custom_fields == ''
        ${form_data}=    Set Variable    ${base}
    ELSE
        ${form_data}=    Evaluate    dict(${base}, **${custom_fields})
    END
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    RETURN    ${form_data}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

POST Update Pet With Form - Status Code 200
    [Arguments]    ${pet_id}=${EMPTY}    ${custom_fields}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    '${pet_id}' == '${EMPTY}'
        ${pet_id}=    Seed A Pet For Form Update
    END
    ${form_data}=    Build Update Pet With Form Data    ${custom_fields}
    ${response}=    Call POST Update Pet With Form    ${pet_id}    ${form_data}
    Should Be Equal As Integers    ${response.status_code}    200

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

POST Update Pet With Form - Status Code 405
    [Arguments]    ${pet_id}=${EMPTY}    ${custom_fields}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    '${pet_id}' == '${EMPTY}'
        ${pet_id}=    Seed A Pet For Form Update
    END
    ${form_data}=    Build Update Pet With Form Data    ${custom_fields}
    ${response}=    Call POST Update Pet With Form    ${pet_id}    ${form_data}
    Should Be Equal As Integers    ${response.status_code}    405

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Call POST Update Pet With Form
    [Documentation]    Calls the POST Update Pet With Form keyword from the POM.
    [Arguments]    ${pet_id}    ${form_data}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${response}=    POST Update Pet With Form    ${pet_id}    ${form_data}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Pet - Update With Form - POST - By HTTP Status Code
    [Documentation]    This keyword executes the appropriate Update Pet With Form test scenario based on the provided
    ...    HTTP status code.
    [Arguments]    ${meuPetId}    ${meuForm}    ${meuHTTP}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    Run Keyword If    '${meuHTTP}' == '200'    POST Update Pet With Form - Status Code 200    ${meuPetId}    ${meuForm}
    ...    ELSE IF    '${meuHTTP}' == '405'    POST Update Pet With Form - Status Code 405    ${meuPetId}    ${meuForm}
    ...    ELSE    Fail    HTTP status code '${meuHTTP}' is not supported for Update Pet With Form test scenario.
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
