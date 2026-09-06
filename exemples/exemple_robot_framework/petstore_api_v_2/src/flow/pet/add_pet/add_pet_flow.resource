*** Settings ***
Resource    ../../../pom/pet/add_pet/add_pet_pom.resource
Resource    ../../common/schema_validation_flow.resource
Resource    ../../../resource/config/schema/schema.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Keywords ***
Build Add Pet Payload
    [Documentation]    Builds a flexible payload for adding a new pet, based on the Swagger Petstore v2 Pet schema.
    [Arguments]    ${custom_fields}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${category}=    Create Dictionary
    ...    id=0
    ...    name=string
    ${tag}=    Create Dictionary
    ...    id=0
    ...    name=string
    ${tags}=    Create List    ${tag}
    ${photo_urls}=    Create List    string
    ${base}=    Create Dictionary
    ...    id=0
    ...    category=${category}
    ...    name=doggie
    ...    photoUrls=${photo_urls}
    ...    tags=${tags}
    ...    status=available
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
    # Note: the 200 response body is not documented in the OpenAPI spec (only 405 is) — this validates the
    # Pet echo behavior actually observed from the live server, not a documented contract.
    Validate Object Schema    ${response.json()}    ${PET_SCHEMA}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

POST Add Pet - Status Code 405
    [Arguments]    ${custom_fields}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${payload}=    Build Add Pet Payload    ${custom_fields}
    ${response}=    Call POST Add Pet    ${payload}
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
