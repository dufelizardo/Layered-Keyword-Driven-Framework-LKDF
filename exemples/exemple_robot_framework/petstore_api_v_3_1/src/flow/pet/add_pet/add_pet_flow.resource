*** Settings ***
Resource    ../../../pom/pet/add_pet/add_pet_pom.resource
Resource    ../../common/schema_validation_flow.resource
Resource    ../../../resource/config/schema/schema.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
    Note: the base payload deliberately omits "id" - the live server crashes with HTTP 500 when POST /pet is
    given an id that already exists on this shared public demo (see KNOWN_ISSUES.md). Omitting it lets the
    server assign a safe, non-colliding id itself.
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Keywords ***
Build Add Pet Payload
    [Documentation]    Builds a flexible payload for adding a new pet, based on the Swagger Petstore OpenAPI 3.1
    ...    Pet schema.
    [Arguments]    ${custom_fields}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${category}=    Create Dictionary
    ...    id=${0}
    ...    name=string
    ${tag}=    Create Dictionary
    ...    id=${0}
    ...    name=string
    ${tags}=    Create List    ${tag}
    ${photo_urls}=    Create List    string
    ${pet_details_category}=    Create Dictionary
    ...    id=${0}
    ...    name=string
    ${pet_details}=    Create Dictionary
    ...    id=${10}
    ...    category=${pet_details_category}
    ...    tag=${tag}
    ${base}=    Create Dictionary
    ...    category=${category}
    ...    name=doggie
    ...    photoUrls=${photo_urls}
    ...    tags=${tags}
    ...    status=available
    ...    availableInstances=${7}
    ...    petDetailsId=${10}
    ...    petDetails=${pet_details}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    $custom_fields == ''
        ${payload}=    Set Variable    ${base}
    ELSE
        ${payload}=    Evaluate    dict(${base}, **${custom_fields})
    END
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    RETURN    ${payload}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

POST Add Pet - Status Code 200
    [Arguments]    ${custom_fields}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${payload}=    Build Add Pet Payload    ${custom_fields}
    ${response}=    Call POST Add Pet    ${payload}
    Should Be Equal As Integers    ${response.status_code}    200
    Validate Object Schema    ${response.json()}    ${PET_SCHEMA}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

POST Add Pet - Status Code 405
    [Arguments]    ${custom_fields}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${payload}=    Build Add Pet Payload    ${custom_fields}
    ${response}=    Call POST Add Pet    ${payload}
    # Known live-server issue — see KNOWN_ISSUES.md #2: this actually returns 400, not the documented 405.
    Should Be Equal As Integers    ${response.status_code}    405

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Call POST Add Pet
    [Documentation]    Calls the POST Add Pet keyword from the POM.
    [Arguments]    ${payload}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${response}=    POST Add Pet    ${payload}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Pet - Add - POST - By HTTP Status Code
    [Documentation]    This keyword executes the appropriate Add Pet test scenario based on the provided HTTP
    ...    status code.
    [Arguments]    ${meuPet}    ${meuHTTP}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    Run Keyword If    '${meuHTTP}' == '200'    POST Add Pet - Status Code 200    ${meuPet}
    ...    ELSE IF    '${meuHTTP}' == '405'    POST Add Pet - Status Code 405    ${meuPet}
    ...    ELSE    Fail    HTTP status code '${meuHTTP}' is not supported for Add Pet test scenario.
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
