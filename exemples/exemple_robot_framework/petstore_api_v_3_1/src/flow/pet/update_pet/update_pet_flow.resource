*** Settings ***
Resource    ../../../pom/pet/update_pet/update_pet_pom.resource
Resource    ../../common/schema_validation_flow.resource
Resource    ../../../resource/config/schema/schema.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
    Note: the live server crashes with HTTP 500 when PUT-updating a Pet id that already exists (see
    KNOWN_ISSUES.md) - it only succeeds the first time a given id is used (an implicit create). A fresh random
    id is generated on every call to avoid colliding with pets created by this suite's own earlier runs, or by
    any of the countless other users of this shared public demo server.
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Keywords ***
Generate Fresh Pet Id
    [Documentation]    Returns a large random integer id, unlikely to already exist on the shared public demo
    ...    server, so PUT /pet is exercised as a create rather than colliding with an existing record.
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${fresh_id}=    Evaluate    random.randint(100000000, 999999999)    modules=random
    RETURN    ${fresh_id}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Build Flexible Update Pet PUT Payload
    [Documentation]    Builds a flexible PUT payload for updating a pet, based on the Swagger Petstore OpenAPI 3.1
    ...    Pet schema.
    [Arguments]    ${custom_fields}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${fresh_id}=    Generate Fresh Pet Id
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
    ...    id=${fresh_id}
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

PUT Update Pet - Status Code 200
    [Arguments]    ${custom_fields}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${payload}=    Build Flexible Update Pet PUT Payload    ${custom_fields}
    ${response}=    Call PUT Update Pet    ${payload}
    Should Be Equal As Integers    ${response.status_code}    200
    Validate Object Schema    ${response.json()}    ${PET_SCHEMA}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

PUT Update Pet - Status Code 400
    [Arguments]    ${custom_fields}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${payload}=    Build Flexible Update Pet PUT Payload    ${custom_fields}
    ${response}=    Call PUT Update Pet    ${payload}
    Should Be Equal As Integers    ${response.status_code}    400

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

PUT Update Pet - Status Code 404
    [Arguments]    ${custom_fields}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${payload}=    Build Flexible Update Pet PUT Payload    ${custom_fields}
    ${response}=    Call PUT Update Pet    ${payload}
    # Known live-server issue — see KNOWN_ISSUES.md #1: this id likely already exists on the shared demo
    # server, so this actually returns 500, not the documented 404.
    Should Be Equal As Integers    ${response.status_code}    404

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

PUT Update Pet - Status Code 405
    [Arguments]    ${custom_fields}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${payload}=    Build Flexible Update Pet PUT Payload    ${custom_fields}
    ${response}=    Call PUT Update Pet    ${payload}
    # Known live-server issue — see KNOWN_ISSUES.md #2: invalid enum/empty required fields aren't validated,
    # this actually returns 200, not the documented 405.
    Should Be Equal As Integers    ${response.status_code}    405

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Call PUT Update Pet
    [Documentation]    Calls the PUT Update Pet keyword from the POM.
    [Arguments]    ${payload}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${response}=    PUT Update Pet    ${payload}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Pet - Update - PUT - By HTTP Status Code
    [Documentation]    This keyword executes the appropriate PUT Update Pet test scenario based on the provided HTTP
    ...    status code.
    [Arguments]    ${meuPet}    ${meuHTTP}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    Run Keyword If    '${meuHTTP}' == '200'    PUT Update Pet - Status Code 200    ${meuPet}
    ...    ELSE IF    '${meuHTTP}' == '400'    PUT Update Pet - Status Code 400    ${meuPet}
    ...    ELSE IF    '${meuHTTP}' == '404'    PUT Update Pet - Status Code 404    ${meuPet}
    ...    ELSE IF    '${meuHTTP}' == '405'    PUT Update Pet - Status Code 405    ${meuPet}
    ...    ELSE    Fail    HTTP status code '${meuHTTP}' is not supported for PUT Update Pet test scenario.
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
