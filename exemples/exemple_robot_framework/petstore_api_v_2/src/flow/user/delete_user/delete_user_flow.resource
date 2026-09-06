*** Settings ***
Library    String
Resource    ../../../pom/user/delete_user/delete_user_pom.resource
Resource    ../../../flow/user/create_user/create_user_flow.resource
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Comments ***
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
*** Keywords ***
Seed A User For Deletion
    [Documentation]    Creates a fresh user via the Create User flow so this test has a guaranteed valid username
    ...    to delete.
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${suffix}=    Generate Random String    8    [LOWER]
    ${username}=    Set Variable    lkdf_${suffix}
    ${custom_fields}=    Create Dictionary
    ...    username=${username}
    POST Create User - Status Code 200    ${custom_fields}
    RETURN    ${username}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

DELETE Delete User - Status Code 200
    [Arguments]    ${username}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    '${username}' == '${EMPTY}'
        ${username}=    Seed A User For Deletion
    END
    ${response}=    Call DELETE Delete User    ${username}
    Should Be Equal As Integers    ${response.status_code}    200

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

DELETE Delete User - Status Code 400
    [Arguments]    ${username}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    '${username}' == '${EMPTY}'
        ${username}=    Set Variable    invalid_user!!
    END
    ${response}=    Call DELETE Delete User    ${username}
    Should Be Equal As Integers    ${response.status_code}    400

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

DELETE Delete User - Status Code 404
    [Arguments]    ${username}=${EMPTY}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    IF    '${username}' == '${EMPTY}'
        ${username}=    Set Variable    nonexistent_user_999999999
    END
    ${response}=    Call DELETE Delete User    ${username}
    Should Be Equal As Integers    ${response.status_code}    404

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

Call DELETE Delete User
    [Documentation]    Calls the DELETE Delete User keyword from the POM.
    [Arguments]    ${username}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    ${response}=    DELETE Delete User    ${username}

    RETURN    ${response}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

User - Delete - DELETE - By HTTP Status Code
    [Documentation]    This keyword executes the appropriate Delete User test scenario based on the provided HTTP
    ...    status code.
    [Arguments]    ${meuUsername}    ${meuHTTP}
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
    Run Keyword If    '${meuHTTP}' == '200'    DELETE Delete User - Status Code 200    ${meuUsername}
    ...    ELSE IF    '${meuHTTP}' == '400'    DELETE Delete User - Status Code 400    ${meuUsername}
    ...    ELSE IF    '${meuHTTP}' == '404'    DELETE Delete User - Status Code 404    ${meuUsername}
    ...    ELSE    Fail    HTTP status code '${meuHTTP}' is not supported for Delete User test scenario.
    # ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════
# ══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
