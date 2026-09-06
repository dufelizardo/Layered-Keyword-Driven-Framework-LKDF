*** Settings ***
Resource    ../../../pom/user/create_user/create_user_pom.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Keywords ***
Build Create User Payload
    [Documentation]    Builds a flexible payload for creating a user, based on the Swagger Petstore v2 User schema.
    [Arguments]    ${custom_fields}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${base}=    Create Dictionary
    ...    id=0
    ...    username=lkdf_user
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

POST Create User - Status Code 200
    [Arguments]    ${custom_fields}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${payload}=    Build Create User Payload    ${custom_fields}
    ${response}=    Call POST Create User    ${payload}
    Should Be Equal As Integers    ${response.status_code}    200

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Call POST Create User
    [Documentation]    Calls the POST Create User keyword from the POM.
    [Arguments]    ${payload}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${response}=    POST Create User    ${payload}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

User - Create - POST - By HTTP Status Code
    [Documentation]    This keyword executes the appropriate Create User test scenario based on the provided HTTP
    ...    status code.
    [Arguments]    ${meuUser}    ${meuHTTP}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    Run Keyword If    '${meuHTTP}' == '200'    POST Create User - Status Code 200    ${meuUser}
    ...    ELSE    Fail    HTTP status code '${meuHTTP}' is not supported for Create User test scenario.
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
