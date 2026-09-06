*** Settings ***
Resource    ../../pom/put/put_petstore_pom.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*keywords***
Build Flexible Update Pet PUT Payload
    [Documentation]    Builds a flexible PUT payload for updating a pet.
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
    ${pet_details_category}=    Create Dictionary
    ...    id=0
    ...    name=string
    ${pet_details}=    Create Dictionary
    ...    id=10
    ...    category=${pet_details_category}
    ...    tag=${tag}
    ${base}=    Create Dictionary
    ...    id=0
    ...    category=${category}
    ...    name=doggie
    ...    photoUrls=${photo_urls}
    ...    tags=${tags}
    ...    status=available
    ...    availableInstances=7
    ...    petDetailsId=10
    ...    petDetails=${pet_details}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    '${custom_fields}' == '${EMPTY}'
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
    Should Be Equal As Integers    ${response.status_code}    404

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

PUT Update Pet - Status Code 405
    [Arguments]    ${custom_fields}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${payload}=    Build Flexible Update Pet PUT Payload    ${custom_fields}
    ${response}=    Call PUT Update Pet    ${payload}
    Should Be Equal As Integers    ${response.status_code}    405

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

PUT Update Pet - Status Code 500
    [Arguments]    ${custom_fields}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${payload}=    Build Flexible Update Pet PUT Payload    ${custom_fields}
    ${response}=    Call PUT Update Pet    ${payload}
    Should Be Equal As Integers    ${response.status_code}    500

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
    ...    ELSE IF    '${meuHTTP}' == '500'    PUT Update Pet - Status Code 500    ${meuPet}
    ...    ELSE    Fail    HTTP status code '${meuHTTP}' is not supported for PUT Update Pet test scenario.
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════