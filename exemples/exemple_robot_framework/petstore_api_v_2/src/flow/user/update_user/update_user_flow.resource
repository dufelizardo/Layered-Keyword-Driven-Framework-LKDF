*** Settings ***
Library    String
Resource    ../../../pom/user/update_user/update_user_pom.resource
Resource    ../../../flow/user/create_user/create_user_flow.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Keywords ***
Seed A User For Update
    [Documentation]    Creates a fresh user via the Create User flow so this test has a guaranteed valid username
    ...    to update.
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${suffix}=    Generate Random String    8    [LOWER]
    ${username}=    Set Variable    lkdf_${suffix}
    ${custom_fields}=    Create Dictionary
    ...    username=${username}
    POST Create User - Status Code 200    ${custom_fields}
    RETURN    ${username}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Build Update User Payload
    [Documentation]    Builds a flexible payload for updating a user, based on the Swagger Petstore v2 User schema.
    [Arguments]    ${username}    ${custom_fields}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${base}=    Create Dictionary
    ...    id=0
    ...    username=${username}
    ...    firstName=John
    ...    lastName=Doe
    ...    email=john.doe@example.com
    ...    password=Password123
    ...    phone=+55 11 90000-0000
    ...    userStatus=1
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

PUT Update User - Status Code 200
    [Arguments]    ${username}=${EMPTY}    ${custom_fields}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    '${username}' == '${EMPTY}'
        ${username}=    Seed A User For Update
    END
    ${payload}=    Build Update User Payload    ${username}    ${custom_fields}
    ${response}=    Call PUT Update User    ${username}    ${payload}
    Should Be Equal As Integers    ${response.status_code}    200

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

PUT Update User - Status Code 400
    [Arguments]    ${username}=${EMPTY}    ${custom_fields}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    '${username}' == '${EMPTY}'
        ${username}=    Set Variable    invalid_user!!
    END
    ${payload}=    Build Update User Payload    ${username}    ${custom_fields}
    ${response}=    Call PUT Update User    ${username}    ${payload}
    Should Be Equal As Integers    ${response.status_code}    400

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

PUT Update User - Status Code 404
    [Arguments]    ${username}=${EMPTY}    ${custom_fields}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    '${username}' == '${EMPTY}'
        ${username}=    Set Variable    nonexistent_user_999999999
    END
    ${payload}=    Build Update User Payload    ${username}    ${custom_fields}
    ${response}=    Call PUT Update User    ${username}    ${payload}
    Should Be Equal As Integers    ${response.status_code}    404

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Call PUT Update User
    [Documentation]    Calls the PUT Update User keyword from the POM.
    [Arguments]    ${username}    ${payload}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${response}=    PUT Update User    ${username}    ${payload}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

User - Update - PUT - By HTTP Status Code
    [Documentation]    This keyword executes the appropriate Update User test scenario based on the provided HTTP
    ...    status code.
    [Arguments]    ${meuUsername}    ${meuPayload}    ${meuHTTP}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    Run Keyword If    '${meuHTTP}' == '200'    PUT Update User - Status Code 200    ${meuUsername}    ${meuPayload}
    ...    ELSE IF    '${meuHTTP}' == '400'    PUT Update User - Status Code 400    ${meuUsername}    ${meuPayload}
    ...    ELSE IF    '${meuHTTP}' == '404'    PUT Update User - Status Code 404    ${meuUsername}    ${meuPayload}
    ...    ELSE    Fail    HTTP status code '${meuHTTP}' is not supported for Update User test scenario.
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
